import { defineStore } from 'pinia'
import api, { TOKEN_KEY } from '../services/api'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: localStorage.getItem(TOKEN_KEY),
  }),

  getters: {
    isAuthenticated: (state) => !!state.token,
  },

  actions: {
    async login(email, password) {
      const response = await api.post('/login', { email, password })
      this.token = response.data.token
      localStorage.setItem(TOKEN_KEY, this.token)
    },

    logout() {
      this.token = null
      localStorage.removeItem(TOKEN_KEY)
    },
  },
})
