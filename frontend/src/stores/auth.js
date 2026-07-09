import { defineStore } from 'pinia'
import api from '../services/api'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: localStorage.getItem('symplifica_token'),
  }),

  getters: {
    isAuthenticated: (state) => !!state.token,
  },

  actions: {
    async login(email, password) {
      const response = await api.post('/login', { email, password })
      this.token = response.data.token
      localStorage.setItem('symplifica_token', this.token)
    },

    logout() {
      this.token = null
      localStorage.removeItem('symplifica_token')
    },
  },
})
