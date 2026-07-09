<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import api from '../services/api'
import AppLayout from '../components/AppLayout.vue'

const route = useRoute()
const employee = ref(null)
const loading = ref(true)
const error = ref('')

const newBenefit = ref({ nombre_beneficio: '', monto: '' })
const benefitError = ref('')

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

async function addBenefit() {
  benefitError.value = ''

  try {
    const response = await api.post(`/employees/${route.params.id}/benefits`, { benefit: newBenefit.value })
    employee.value.benefits.push(response.data)
    newBenefit.value = { nombre_beneficio: '', monto: '' }
  } catch (err) {
    benefitError.value = err.response?.data?.errors?.join(', ') ?? 'No se pudo agregar el beneficio'
  }
}

async function deleteBenefit(id) {
  if (!confirm('¿Eliminar este beneficio?')) return

  try {
    await api.delete(`/benefits/${id}`)
    employee.value.benefits = employee.value.benefits.filter((benefit) => benefit.id !== id)
  } catch {
    alert('No se pudo eliminar el beneficio')
  }
}
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
              class="flex items-center justify-between text-sm"
            >
              <span class="text-slate-600">{{ benefit.nombre_beneficio }}</span>
              <span class="flex items-center gap-2">
                <span class="font-medium text-slate-800">${{ benefit.monto }}</span>
                <button
                  class="flex h-5 w-5 items-center justify-center rounded text-base leading-none text-slate-400 hover:text-red-600"
                  title="Eliminar beneficio"
                  @click="deleteBenefit(benefit.id)"
                >
                  &times;
                </button>
              </span>
            </li>
          </ul>

          <form class="mt-4 flex gap-2" @submit.prevent="addBenefit">
            <input
              v-model="newBenefit.nombre_beneficio"
              placeholder="Beneficio"
              required
              class="w-1/2 rounded-md border border-slate-300 px-2 py-1.5 text-sm focus:border-slate-500 focus:outline-none"
            />
            <input
              v-model="newBenefit.monto"
              type="number"
              step="0.01"
              min="0"
              placeholder="Monto"
              required
              class="w-1/3 rounded-md border border-slate-300 px-2 py-1.5 text-sm focus:border-slate-500 focus:outline-none"
            />
            <button
              type="submit"
              class="rounded-md bg-slate-800 px-3 text-sm font-medium text-white hover:bg-slate-700"
            >
              +
            </button>
          </form>
          <p v-if="benefitError" class="mt-2 text-xs text-red-600">{{ benefitError }}</p>
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
