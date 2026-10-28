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
  },
  {
    path: '/goods/:id',
    name: 'goods-detail',
    component: () => import('../views/GoodsDetailView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/about',
    name: 'about',
    component: () => import('../views/AboutView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/favorites',
    name: 'favorites',
    component: () => import('../views/FavoritesView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/cart',
    name: 'cart',
    component: () => import('../views/CartView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/admin/login',
    name: 'admin-login',
    component: () => import('../views/AdminLoginView.vue')
  },
  {
    path: '/admin',
    name: 'admin',
    component: () => import('../views/AdminView.vue'),
    meta: { requiresAdmin: true }
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
  // 后台管理页面需要管理员登录
  if (to.meta.requiresAdmin && !localStorage.getItem('admin')) {
    return { path: '/admin/login' }
  }
  // 已登录时访问登录/注册页，直接进入主页
  if ((to.path === '/login' || to.path === '/register') && user) {
    return { path: '/home' }
  }
  return true
})

export default router
