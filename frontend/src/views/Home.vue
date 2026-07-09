<script setup>
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const auth = useAuthStore()

function handleLogout() {
  auth.logout()
  router.push('/login')
}
</script>

<template>
  <div class="flex min-h-screen flex-col items-center justify-center gap-4">
    <h1 class="text-3xl font-semibold text-slate-800">Symplifica Dashboard</h1>
    <button class="text-sm text-slate-500 underline" @click="handleLogout">Cerrar sesión</button>
  </div>
</template>
