import { beforeEach, describe, expect, it, vi } from 'vitest'
import { createPinia, setActivePinia } from 'pinia'
import { useAuthStore } from './auth'
import api, { TOKEN_KEY } from '../services/api'

describe('auth store', () => {
  beforeEach(() => {
    localStorage.clear()
    setActivePinia(createPinia())
  })

  it('arranca sin sesion cuando no hay token guardado', () => {
    const auth = useAuthStore()

    expect(auth.token).toBeNull()
    expect(auth.isAuthenticated).toBe(false)
  })

  it('rehidrata el token desde localStorage al crearse', () => {
    localStorage.setItem(TOKEN_KEY, 'token-previo')

    const auth = useAuthStore()

    expect(auth.token).toBe('token-previo')
    expect(auth.isAuthenticated).toBe(true)
  })

  it('guarda el token en el estado y en localStorage al hacer login', async () => {
    vi.spyOn(api, 'post').mockResolvedValue({ data: { token: 'token-nuevo' } })
    const auth = useAuthStore()

    await auth.login('admin@symplifica.com', 'symplifica2026')

    expect(api.post).toHaveBeenCalledWith('/login', {
      email: 'admin@symplifica.com',
      password: 'symplifica2026',
    })
    expect(auth.token).toBe('token-nuevo')
    expect(localStorage.getItem(TOKEN_KEY)).toBe('token-nuevo')
    expect(auth.isAuthenticated).toBe(true)
  })

  it('propaga el error y no guarda token si las credenciales son invalidas', async () => {
    vi.spyOn(api, 'post').mockRejectedValue(new Error('401'))
    const auth = useAuthStore()

    await expect(auth.login('admin@symplifica.com', 'mala')).rejects.toThrow()

    expect(auth.token).toBeNull()
    expect(localStorage.getItem(TOKEN_KEY)).toBeNull()
  })

  it('limpia estado y localStorage al hacer logout', () => {
    localStorage.setItem(TOKEN_KEY, 'token-previo')
    const auth = useAuthStore()

    auth.logout()

    expect(auth.token).toBeNull()
    expect(localStorage.getItem(TOKEN_KEY)).toBeNull()
    expect(auth.isAuthenticated).toBe(false)
  })
})
