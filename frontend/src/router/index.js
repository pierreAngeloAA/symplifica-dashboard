import { createRouter, createWebHistory } from 'vue-router'
import EmployeeList from '../views/EmployeeList.vue'
import EmployeeDetail from '../views/EmployeeDetail.vue'
import Login from '../views/Login.vue'
import { useAuthStore } from '../stores/auth'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', name: 'home', component: EmployeeList, meta: { requiresAuth: true } },
    { path: '/employees/:id', name: 'employee-detail', component: EmployeeDetail, meta: { requiresAuth: true } },
    { path: '/login', name: 'login', component: Login },
  ],
})

router.beforeEach((to) => {
  const auth = useAuthStore()

  if (to.meta.requiresAuth && !auth.isAuthenticated) {
    return { name: 'login' }
  }

  if (to.name === 'login' && auth.isAuthenticated) {
    return { name: 'home' }
  }
})

export default router
