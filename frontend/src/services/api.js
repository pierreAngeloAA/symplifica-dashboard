import axios from 'axios'

const TOKEN_KEY = 'symplifica_token'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:3000/api',
})

api.interceptors.request.use((config) => {
  const token = localStorage.getItem(TOKEN_KEY)
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// El JWT expira (24 h). Sin este manejo, un token vencido deja la app en una
// pantalla vacia: cada peticion falla con 401 y nada devuelve al login.
// El handler se registra desde main.js en vez de importar el router aca, para
// no crear el ciclo api -> router -> store -> api.
let onUnauthorized = null

export function setUnauthorizedHandler(handler) {
  onUnauthorized = handler
}

api.interceptors.response.use(
  (response) => response,
  (error) => {
    const isLoginRequest = error.config?.url?.endsWith('/login')

    // Un 401 en /login son credenciales malas: lo maneja la vista de Login.
    if (error.response?.status === 401 && !isLoginRequest) {
      onUnauthorized?.()
    }

    return Promise.reject(error)
  },
)

export { TOKEN_KEY }
export default api
