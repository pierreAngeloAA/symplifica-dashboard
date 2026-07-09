<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import api from '../services/api'
import AppLayout from '../components/AppLayout.vue'

const route = useRoute()
const employee = ref(null)
const loading = ref(true)
const error = ref('')

onMounted(async () => {
  try {
    const response = await api.get(`/employees/${route.params.id}`)
    employee.value = response.data
  } catch {
    error.value = 'No se pudo cargar el empleado'
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <AppLayout>
    <RouterLink to="/" class="mb-6 inline-block text-sm text-slate-500 hover:text-slate-700">
      &larr; Volver al listado
    </RouterLink>

    <p v-if="loading" class="text-sm text-slate-500">Cargando...</p>
    <p v-else-if="error" class="text-sm text-red-600">{{ error }}</p>

    <template v-else>
      <h1 class="mb-1 text-xl font-semibold text-slate-800">
        {{ employee.nombre }} {{ employee.apellido }}
      </h1>
      <p class="mb-6 text-sm text-slate-500">{{ employee.cargo }} &middot; {{ employee.email }}</p>

      <div class="grid gap-6 sm:grid-cols-2">
        <section class="rounded-lg bg-white p-5 shadow-sm">
          <h2 class="mb-3 text-sm font-semibold text-slate-700">Beneficios</h2>
          <p v-if="employee.benefits.length === 0" class="text-sm text-slate-500">
            Sin beneficios asignados.
          </p>
          <ul v-else class="space-y-2">
            <li
              v-for="benefit in employee.benefits"
              :key="benefit.id"
              class="flex justify-between text-sm"
            >
              <span class="text-slate-600">{{ benefit.nombre_beneficio }}</span>
              <span class="font-medium text-slate-800">${{ benefit.monto }}</span>
            </li>
          </ul>
        </section>

        <section class="rounded-lg bg-white p-5 shadow-sm">
          <h2 class="mb-3 text-sm font-semibold text-slate-700">Ubicación ({{ employee.ciudad }})</h2>
          <p v-if="!employee.coordenadas" class="text-sm text-slate-500">
            Coordenadas no disponibles.
          </p>
          <dl v-else class="space-y-1 text-sm">
            <div class="flex justify-between">
              <dt class="text-slate-500">Latitud</dt>
              <dd class="text-slate-800">{{ employee.coordenadas.latitud }}</dd>
            </div>
            <div class="flex justify-between">
              <dt class="text-slate-500">Longitud</dt>
              <dd class="text-slate-800">{{ employee.coordenadas.longitud }}</dd>
            </div>
          </dl>
        </section>
      </div>
    </template>
  </AppLayout>
</template>
