<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../services/api'
import AppLayout from '../components/AppLayout.vue'

const route = useRoute()
const router = useRouter()

const employeeId = route.params.id
const isEditing = computed(() => !!employeeId)

const form = ref({ nombre: '', apellido: '', email: '', cargo: '', ciudad: '' })
const errors = ref([])
const loading = ref(false)

onMounted(async () => {
  if (!isEditing.value) return

  const response = await api.get(`/employees/${employeeId}`)
  const { nombre, apellido, email, cargo, ciudad } = response.data
  form.value = { nombre, apellido, email, cargo, ciudad }
})

async function handleSubmit() {
  errors.value = []
  loading.value = true

  try {
    const response = isEditing.value
      ? await api.put(`/employees/${employeeId}`, { employee: form.value })
      : await api.post('/employees', { employee: form.value })

    router.push(`/employees/${response.data.id}`)
  } catch (err) {
    const message = isEditing.value ? 'No se pudo actualizar el empleado' : 'No se pudo crear el empleado'
    errors.value = err.response?.data?.errors ?? [message]
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <AppLayout>
    <RouterLink to="/" class="mb-6 inline-block text-sm text-slate-500 hover:text-slate-700">
      &larr; Volver al listado
    </RouterLink>

    <h1 class="mb-6 text-xl font-semibold text-slate-800">
      {{ isEditing ? 'Editar empleado' : 'Nuevo empleado' }}
    </h1>

    <form class="max-w-md space-y-4 rounded-lg bg-white p-6 shadow-sm" @submit.prevent="handleSubmit">
      <div>
        <label class="mb-1 block text-sm font-medium text-slate-600" for="nombre">Nombre</label>
        <input
          id="nombre"
          v-model="form.nombre"
          required
          class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none"
        />
      </div>

      <div>
        <label class="mb-1 block text-sm font-medium text-slate-600" for="apellido">Apellido</label>
        <input
          id="apellido"
          v-model="form.apellido"
          class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none"
        />
      </div>

      <div>
        <label class="mb-1 block text-sm font-medium text-slate-600" for="email">Email</label>
        <input
          id="email"
          v-model="form.email"
          type="email"
          required
          class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none"
        />
      </div>

      <div>
        <label class="mb-1 block text-sm font-medium text-slate-600" for="cargo">Cargo</label>
        <input
          id="cargo"
          v-model="form.cargo"
          class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none"
        />
      </div>

      <div>
        <label class="mb-1 block text-sm font-medium text-slate-600" for="ciudad">Ciudad</label>
        <input
          id="ciudad"
          v-model="form.ciudad"
          required
          class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none"
        />
      </div>

      <ul v-if="errors.length" class="space-y-1 text-sm text-red-600">
        <li v-for="message in errors" :key="message">{{ message }}</li>
      </ul>

      <button
        type="submit"
        :disabled="loading"
        class="w-full rounded-md bg-slate-800 py-2 text-sm font-medium text-white hover:bg-slate-700 disabled:opacity-50"
      >
        {{ loading ? 'Guardando...' : isEditing ? 'Guardar cambios' : 'Crear empleado' }}
      </button>
    </form>
  </AppLayout>
</template>
