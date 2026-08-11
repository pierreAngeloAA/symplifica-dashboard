import { beforeEach, describe, expect, it, vi } from 'vitest'
import { createPinia, setActivePinia } from 'pinia'
import { TOKEN_KEY } from '../services/api'

// El router es un singleton, asi que se reimporta en cada test para que cada
// caso arranque desde la ruta inicial y no herede la navegacion del anterior.
async function freshRouter() {
  vi.resetModules()
  const { default: router } = await import('./index')
  return router
}

describe('guard de rutas', () => {
  beforeEach(() => {
    localStorage.clear()
    setActivePinia(createPinia())
  })

  it('manda al login cuando se entra sin sesion a una ruta protegida', async () => {
    const router = await freshRouter()

    await router.push('/')
    await router.isReady()

    expect(router.currentRoute.value.name).toBe('login')
  })

  it('protege tambien el detalle y los formularios de empleado', async () => {
    const router = await freshRouter()

    await router.push('/employees/1/edit')
    await router.isReady()

    expect(router.currentRoute.value.name).toBe('login')
  })

  it('deja pasar a la ruta protegida cuando hay token', async () => {
    localStorage.setItem(TOKEN_KEY, 'token-valido')
    const router = await freshRouter()

    await router.push('/')
    await router.isReady()

    expect(router.currentRoute.value.name).toBe('home')
  })

  it('saca del login a quien ya tiene sesion', async () => {
    localStorage.setItem(TOKEN_KEY, 'token-valido')
    const router = await freshRouter()

    await router.push('/login')
    await router.isReady()

    expect(router.currentRoute.value.name).toBe('home')
  })

  it('deja ver el login a quien no tiene sesion', async () => {
    const router = await freshRouter()

    await router.push('/login')
    await router.isReady()

    expect(router.currentRoute.value.name).toBe('login')
  })
})
