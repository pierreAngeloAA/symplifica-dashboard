<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const email = ref('')
const password = ref('')
const error = ref('')
const loading = ref(false)

const router = useRouter()
const auth = useAuthStore()

async function handleSubmit() {
  error.value = ''
  loading.value = true

  try {
    await auth.login(email.value, password.value)
    router.push('/')
  } catch {
    error.value = 'Email o contraseña inválidos'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="flex min-h-screen items-center justify-center bg-slate-50">
    <form
      class="w-full max-w-sm rounded-lg bg-white p-8 shadow-sm"
      @submit.prevent="handleSubmit"
    >
      <h1 class="mb-6 text-2xl font-semibold text-slate-800">Symplifica Dashboard</h1>

      <label class="mb-1 block text-sm font-medium text-slate-600" for="email">Email</label>
      <input
        id="email"
        v-model="email"
        type="email"
        required
        class="mb-4 w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none"
      />

      <label class="mb-1 block text-sm font-medium text-slate-600" for="password">Contraseña</label>
      <input
        id="password"
        v-model="password"
        type="password"
        required
        class="mb-4 w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none"
      />

      <p v-if="error" class="mb-4 text-sm text-red-600">{{ error }}</p>

      <button
        type="submit"
        :disabled="loading"
        class="w-full rounded-md bg-slate-800 py-2 text-sm font-medium text-white hover:bg-slate-700 disabled:opacity-50"
      >
        {{ loading ? 'Ingresando...' : 'Ingresar' }}
      </button>
    </form>
  </div>
</template>
