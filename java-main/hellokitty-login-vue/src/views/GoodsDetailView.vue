<template>
  <div class="detail-page">
    <!-- 顶部导航栏 -->
    <header class="navbar">
      <div class="nav-inner">
        <div class="nav-left">
          <div class="brand">
            <span class="brand-badge"><i></i></span>
            <span class="brand-name">Hello Kitty</span>
          </div>
          <nav class="nav-menu">
            <button class="nav-item" @click="router.push('/home')">首页</button>
            <button class="nav-item" @click="router.push('/about')">介绍</button>
          </nav>
        </div>
        <div class="nav-right">
          <span class="greet">Hi，{{ username }} <span class="cat">🐱</span></span>
          <button class="logout-btn" @click="handleLogout">退出</button>
        </div>
      </div>
    </header>

    <main class="page">
      <div class="page-inner" v-if="goods">
        <button class="back-btn" @click="router.push('/home')">← 返回首页</button>

        <section class="detail-card">
          <div class="detail-emoji">
            <img v-if="goods.image" :src="goods.image" :alt="goods.name" class="detail-img" loading="lazy">
            <template v-else>{{ goods.emoji }}</template>
          </div>
          <div class="detail-info">
            <h1 class="detail-name">{{ goods.name }}</h1>
            <div class="detail-meta">
              <span class="good-tag">{{ goods.tag }}</span>
              <span class="good-price">¥{{ goods.price.toFixed(2) }}</span>
            </div>
            <p class="detail-desc">{{ goods.description }}</p>

            <div class="detail-actions">
              <button class="btn buy" @click="handleBuy">立即购买</button>
              <button class="btn cart" @click="handleCart">加入购物车</button>
            </div>
            <p class="toast" v-if="toast">{{ toast }}</p>
          </div>
        </section>
      </div>

      <div class="page-inner" v-else>
        <div class="empty">
          <div class="empty-emoji">🐾</div>
          <p>商品不存在或已下架</p>
          <button class="back-btn" @click="router.push('/home')">← 返回首页</button>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { findGoodsById } from '../api/goodsData'

const router = useRouter()
const route = useRoute()

const user = JSON.parse(localStorage.getItem('user') || '{}')
const username = computed(() => user.username || '可爱用户')

const goods = findGoodsById(route.params.id)

const toast = ref('')
let toastTimer = null
function showToast(msg) {
  toast.value = msg
  clearTimeout(toastTimer)
  toastTimer = setTimeout(() => (toast.value = ''), 2000)
}

function handleBuy() {
  showToast('演示项目～下单功能敬请期待 💕')
}
function handleCart() {
  showToast('已加入购物车（演示）🛒')
}

function handleLogout() {
  localStorage.removeItem('user')
  router.push('/login')
}
</script>

<style scoped>
.detail-page {
  position: relative;
  z-index: 2;
  width: 100%;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

/* ===== 顶部导航栏（与首页一致） ===== */
.navbar { flex: none; padding: 14px 20px; }
.nav-inner {
  max-width: 1080px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(8px);
  border: 2px solid #ffd9e6;
  border-radius: 22px;
  box-shadow: 0 12px 30px rgba(255, 105, 155, 0.18);
  padding: 10px 20px;
}
.nav-left { display: flex; align-items: center; gap: 22px; }
.brand { display: flex; align-items: center; gap: 10px; }
.brand-badge {
  position: relative;
  width: 34px; height: 34px;
  border-radius: 50%;
  background: linear-gradient(135deg, #ff7aa8, #ff5c8a);
  box-shadow: 0 4px 12px rgba(255, 92, 138, 0.35);
  flex: none;
}
.brand-badge::before,
.brand-badge::after {
  content: "";
  position: absolute;
  top: 8px;
  width: 14px; height: 11px;
  background: #fff;
  border-radius: 50% 50% 50% 50% / 60% 60% 40% 40%;
}
.brand-badge::before { left: 4px; transform: rotate(-25deg); }
.brand-badge::after { right: 4px; transform: rotate(25deg); }
.brand-badge i {
  position: absolute;
  left: 50%; top: 50%;
  width: 9px; height: 9px;
  background: #fff;
  border-radius: 50%;
  transform: translate(-50%, -50%);
}
.brand-name { font-size: 18px; font-weight: 700; color: #ff5c8a; letter-spacing: 0.5px; }
.nav-menu { display: flex; gap: 6px; }
.nav-item {
  border: none;
  background: transparent;
  color: #a96f88;
  font-size: 15px;
  font-weight: 600;
  padding: 8px 14px;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.18s, color 0.18s;
}
.nav-item:hover { background: #fff0f6; color: #ff5c8a; }
.nav-right { display: flex; align-items: center; gap: 14px; }
.greet { font-size: 14px; color: #5d3a47; font-weight: 600; }
.cat { font-size: 16px; }
.logout-btn {
  border: 2px solid #ffd9e6;
  background: #fff8fb;
  color: #ff5c8a;
  font-size: 13px;
  font-weight: 600;
  padding: 7px 16px;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.18s, transform 0.15s;
}
.logout-btn:hover { background: #ffe3ee; transform: translateY(-1px); }

/* ===== 详情主体 ===== */
.page { flex: 1; padding: 6px 20px 40px; overflow-y: auto; }
.page-inner { max-width: 860px; margin: 0 auto; }
.back-btn {
  border: none;
  background: transparent;
  color: #ff5c8a;
  font-size: 14px;
  font-weight: 600;
  padding: 8px 4px;
  cursor: pointer;
  margin: 8px 0 12px;
}
.back-btn:hover { text-decoration: underline; }

.detail-card {
  display: flex;
  gap: 32px;
  align-items: flex-start;
  background: #ffffff;
  border: 2px solid #ffd9e6;
  border-radius: 24px;
  padding: 36px 32px;
  box-shadow: 0 14px 36px rgba(255, 105, 155, 0.16);
}
.detail-emoji {
  flex: none;
  width: 180px; height: 180px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 90px;
  background: linear-gradient(135deg, #fff0f6, #ffe3ee);
  border-radius: 24px;
  overflow: hidden;
}
.detail-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 24px;
  display: block;
}
.detail-info { flex: 1; }
.detail-name { font-size: 26px; color: #5d3a47; margin-bottom: 12px; }
.detail-meta { display: flex; align-items: center; gap: 16px; margin-bottom: 18px; }
.good-tag {
  font-size: 13px;
  color: #ff5c8a;
  background: #fff0f6;
  border-radius: 999px;
  padding: 4px 14px;
}
.good-price {
  font-size: 24px;
  font-weight: 700;
  color: #ff5c8a;
}
.detail-desc {
  font-size: 15px;
  line-height: 1.8;
  color: #8a5f70;
  margin-bottom: 26px;
}
.detail-actions { display: flex; gap: 14px; }
.btn {
  border: none;
  border-radius: 14px;
  font-size: 15px;
  font-weight: 600;
  padding: 12px 28px;
  cursor: pointer;
  transition: transform 0.15s, box-shadow 0.15s;
}
.btn:hover { transform: translateY(-1px); }
.btn.buy {
  background: linear-gradient(90deg, #ff7aa8, #ff5c8a);
  color: #fff;
  box-shadow: 0 8px 20px rgba(255, 92, 138, 0.35);
}
.btn.cart {
  border: 2px solid #ffd9e6;
  background: #fff8fb;
  color: #ff5c8a;
}
.toast {
  margin-top: 14px;
  font-size: 13px;
  color: #ff8fb8;
}
.empty { text-align: center; padding: 80px 0; color: #c48ba2; }
.empty-emoji { font-size: 46px; margin-bottom: 12px; }

@media (max-width: 640px) {
  .detail-card { flex-direction: column; align-items: center; text-align: center; }
  .detail-actions { justify-content: center; }
}
</style>
