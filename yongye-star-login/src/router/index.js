import { createRouter, createWebHistory } from 'vue-router'
import LoginCard from '../components/LoginCard.vue'
import HomeView from '../views/HomeView.vue'

const routes = [
  { path: '/', name: 'login', component: LoginCard },
  { path: '/home', name: 'home', component: HomeView, meta: { requiresAuth: true } }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫：进入 /home 需已登录（本地令牌）
router.beforeEach((to) => {
  const token = localStorage.getItem('yongye_token')
  if (to.meta.requiresAuth && !token) {
    return { name: 'login' }
  }
})

export default router
