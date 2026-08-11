import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'
import { AxiosError } from 'axios'
import api, { TOKEN_KEY, setUnauthorizedHandler } from './api'

// Reemplazar el adapter deja intactos los interceptores, que es justo lo que se
// quiere probar. Un adapter propio es responsable de rechazar los no-2xx por su
// cuenta: axios solo aplica validateStatus dentro de sus adapters internos.
function stubResponse({ status = 200, data = {} } = {}) {
  const seen = {}

  api.defaults.adapter = async (config) => {
    seen.config = config
    const response = { data, status, statusText: '', headers: {}, config }

    if (status >= 200 && status < 300) return response

    throw new AxiosError(
      `Request failed with status code ${status}`,
      AxiosError.ERR_BAD_REQUEST,
      config,
      null,
      response,
    )
  }

  return seen
}

describe('cliente de API', () => {
  beforeEach(() => {
    localStorage.clear()
    setUnauthorizedHandler(null)
  })

  afterEach(() => {
    delete api.defaults.adapter
  })

  describe('interceptor de request', () => {
    it('agrega el header Authorization cuando hay token', async () => {
      localStorage.setItem(TOKEN_KEY, 'token-valido')
      const seen = stubResponse()

      await api.get('/employees')

      expect(seen.config.headers.Authorization).toBe('Bearer token-valido')
    })

    it('no agrega el header cuando no hay token', async () => {
      const seen = stubResponse()

      await api.get('/employees')

      expect(seen.config.headers.Authorization).toBeUndefined()
    })
  })

  describe('interceptor de response', () => {
    it('llama al handler de sesion vencida ante un 401', async () => {
      const onUnauthorized = vi.fn()
      setUnauthorizedHandler(onUnauthorized)
      stubResponse({ status: 401 })

      await expect(api.get('/employees')).rejects.toThrow()

      expect(onUnauthorized).toHaveBeenCalledOnce()
    })

    it('no dispara el handler ante un 401 de /login: son credenciales malas', async () => {
      const onUnauthorized = vi.fn()
      setUnauthorizedHandler(onUnauthorized)
      stubResponse({ status: 401 })

      await expect(api.post('/login', {})).rejects.toThrow()

      expect(onUnauthorized).not.toHaveBeenCalled()
    })

    it('no dispara el handler ante otros errores', async () => {
      const onUnauthorized = vi.fn()
      setUnauthorizedHandler(onUnauthorized)
      stubResponse({ status: 500 })

      await expect(api.get('/employees')).rejects.toThrow()

      expect(onUnauthorized).not.toHaveBeenCalled()
    })

    it('deja pasar las respuestas exitosas sin tocarlas', async () => {
      stubResponse({ status: 200, data: [{ id: 1 }] })

      const response = await api.get('/employees')

      expect(response.data).toEqual([{ id: 1 }])
    })
  })
})
