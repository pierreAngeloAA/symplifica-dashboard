<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import api from '../services/api'
import AppLayout from '../components/AppLayout.vue'

const router = useRouter()

const employees = ref([])
const loading = ref(true)
const error = ref('')
const openMenuId = ref(null)

onMounted(async () => {
  try {
    const response = await api.get('/employees')
    employees.value = response.data
  } catch {
    error.value = 'No se pudo cargar la lista de empleados'
  } finally {
    loading.value = false
  }
})

function toggleMenu(id) {
  openMenuId.value = openMenuId.value === id ? null : id
}

function closeMenu() {
  openMenuId.value = null
}

onMounted(() => window.addEventListener('click', closeMenu))
onUnmounted(() => window.removeEventListener('click', closeMenu))

async function deleteEmployee(id) {
  openMenuId.value = null
  if (!confirm('¿Eliminar este empleado? Esta acción no se puede deshacer.')) return

  try {
    await api.delete(`/employees/${id}`)
    employees.value = employees.value.filter((employee) => employee.id !== id)
  } catch {
    alert('No se pudo eliminar el empleado')
  }
}
</script>

<template>
  <AppLayout>
    <div class="mb-6 flex items-center justify-between">
      <h1 class="text-xl font-semibold text-slate-800">Empleados</h1>
      <RouterLink
        to="/employees/new"
        class="rounded-md bg-slate-800 px-4 py-2 text-sm font-medium text-white hover:bg-slate-700"
      >
        Nuevo empleado
      </RouterLink>
    </div>

    <p v-if="loading" class="text-sm text-slate-500">Cargando...</p>
    <p v-else-if="error" class="text-sm text-red-600">{{ error }}</p>
    <p v-else-if="employees.length === 0" class="text-sm text-slate-500">No hay empleados registrados.</p>

    <table v-else class="w-full rounded-lg bg-white text-left text-sm shadow-sm">
      <thead class="bg-slate-100 text-slate-600">
        <tr>
          <th class="px-4 py-3 font-medium">Nombre</th>
          <th class="px-4 py-3 font-medium">Cargo</th>
          <th class="px-4 py-3 font-medium">Ciudad</th>
          <th class="px-4 py-3 font-medium">Email</th>
          <th class="px-4 py-3 font-medium">Acciones</th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="employee in employees"
          :key="employee.id"
          class="cursor-pointer border-t border-slate-100 hover:bg-slate-50"
          @click="router.push(`/employees/${employee.id}`)"
        >
          <td class="px-4 py-3">{{ employee.nombre }} {{ employee.apellido }}</td>
          <td class="px-4 py-3">{{ employee.cargo }}</td>
          <td class="px-4 py-3">{{ employee.ciudad }}</td>
          <td class="px-4 py-3">{{ employee.email }}</td>
          <td class="px-4 py-3 text-right" @click.stop>
            <div class="relative inline-block">
              <button
                class="flex h-8 w-8 items-center justify-center rounded text-xl leading-none text-slate-400 hover:bg-slate-100 hover:text-slate-600"
                @click="toggleMenu(employee.id)"
              >
                &#8942;
              </button>

              <div
                v-if="openMenuId === employee.id"
                class="absolute right-0 z-10 mt-1 w-32 rounded-md border border-slate-200 bg-white py-1 shadow-lg"
              >
                <RouterLink
                  :to="`/employees/${employee.id}/edit`"
                  class="block w-full px-3 py-1.5 text-left text-sm text-slate-700 hover:bg-slate-50"
                >
                  Editar
                </RouterLink>
                <button
                  class="block w-full px-3 py-1.5 text-left text-sm text-red-600 hover:bg-red-50"
                  @click="deleteEmployee(employee.id)"
                >
                  Eliminar
                </button>
              </div>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </AppLayout>
</template>
