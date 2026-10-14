import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/', redirect: '/login' },
  {
    path: '/login',
    name: 'login',
    component: () => import('../views/LoginView.vue')
  },
  {
    path: '/register',
    name: 'register',
    component: () => import('../views/RegisterView.vue')
  },
  {
    path: '/home',
    name: 'home',
    component: () => import('../views/HomeView.vue'),
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫：需要登录的页面，未登录跳回登录页
router.beforeEach((to) => {
  const user = localStorage.getItem('user')
  if (to.meta.requiresAuth && !user) {
    return { path: '/login' }
  }
  // 已登录时访问登录/注册页，直接进入主页
  if ((to.path === '/login' || to.path === '/register') && user) {
    return { path: '/home' }
  }
  return true
})

export default router
