<template>
  <div class="orders-page">
    <!-- 顶部导航栏 -->
    <header class="navbar">
      <div class="nav-inner">
        <div class="nav-left">
          <div class="brand" @click="router.push('/home')" role="button" title="回到首页">
            <span class="brand-badge"><i></i></span>
            <span class="brand-name">Hello Kitty</span>
          </div>
          <nav class="nav-menu">
            <button class="nav-item" @click="router.push('/home')">首页</button>
            <button class="nav-item" @click="router.push('/favorites')">💗 我的收藏</button>
            <button class="nav-item active" @click="router.push('/orders')">🧾 我的订单</button>
            <button class="nav-item" @click="router.push('/cart')" data-cart-fly-target>🛒 购物车</button>
          </nav>
        </div>
        <div class="nav-right">
          <span class="greet">Hi，{{ username }} <span class="cat">🐱</span></span>
          <button class="logout-btn" @click="router.push('/home')">返回首页</button>
        </div>
      </div>
    </header>

    <main class="content">
      <div class="content-inner">
        <div class="content-head">
          <h2>我的订单</h2>
          <span class="count" v-if="orders.length">共 {{ orders.length }} 笔订单</span>
        </div>

        <div class="order-list" v-if="orders.length">
          <div class="order-card" v-for="order in orders" :key="order.id">
            <div class="order-head">
              <span class="order-no">订单号 {{ order.orderNo }}</span>
              <span class="order-time">{{ formatTime(order.createTime) }}</span>
              <span class="order-status" :class="statusClass(order.status)">{{ statusText(order.status) }}</span>
            </div>
            <div class="order-items">
              <div class="order-item" v-for="(it, idx) in order.items" :key="idx">
                <span class="item-emoji">{{ it.emoji || '🎀' }}</span>
                <span class="item-name">{{ it.goodsName }}</span>
                <span class="item-qty">× {{ it.qty }}</span>
                <span class="item-price">¥{{ Number(it.price).toFixed(2) }}</span>
              </div>
            </div>
            <div class="order-foot">
              <span class="order-addr" v-if="order.receiver">收货：{{ order.receiver }} {{ order.phone }} · {{ order.address }}</span>
              <span class="order-total">合计 <b>¥{{ Number(order.total).toFixed(2) }}</b></span>
            </div>
          </div>
        </div>

        <div class="empty" v-else-if="!loading">
          <div class="empty-emoji">🧾</div>
          <p>还没有任何订单，去挑几件可爱的好物吧~</p>
          <button class="go-btn" @click="router.push('/home')">去首页逛逛</button>
        </div>

        <div class="loading" v-if="loading">订单加载中…</div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { listOrders } from '../api/orders'

const router = useRouter()
const user = JSON.parse(localStorage.getItem('user') || '{}')
const username = computed(() => user.nickname || user.username || '可爱用户')

const orders = ref([])
const loading = ref(true)

const STATUS_MAP = {
  PAID: '已支付',
  SHIPPED: '已发货',
  COMPLETED: '已完成',
  REFUNDED: '已退款'
}
function statusText(s) { return STATUS_MAP[s] || s || '未知' }
function statusClass(s) { return 'st-' + (s || 'paid').toLowerCase() }

function formatTime(t) {
  if (!t) return '-'
  return String(t).replace('T', ' ').slice(0, 16)
}

async function loadOrders() {
  loading.value = true
  try {
    const res = await listOrders(user.id)
    orders.value = res && res.code === 200 && Array.isArray(res.data) ? res.data : []
  } catch (e) {
    orders.value = []
  } finally {
    loading.value = false
  }
}

onMounted(loadOrders)
</script>

<style scoped>
.orders-page { position: relative; z-index: 2; width: 100%; min-height: 100vh; display: flex; flex-direction: column; }
.navbar { flex: none; padding: 14px 20px; }
.nav-inner {
  max-width: 1080px; margin: 0 auto;
  display: flex; align-items: center; justify-content: space-between; gap: 16px;
  background: var(--nav-glass); backdrop-filter: blur(8px);
  border: 2px solid var(--border); border-radius: 22px;
  box-shadow: 0 12px 30px var(--shadow-2); padding: 10px 20px;
}
.nav-left, .nav-menu { display: flex; align-items: center; gap: 8px; }
.brand { display: flex; align-items: center; gap: 10px; cursor: pointer; margin-right: 12px; }
.brand-badge {
  position: relative; width: 34px; height: 34px; border-radius: 50%; flex: none;
  background: linear-gradient(135deg, var(--brand-2), var(--brand)); box-shadow: 0 4px 12px var(--glow-2);
}
.brand-badge::before, .brand-badge::after {
  content: ''; position: absolute; top: 8px; width: 14px; height: 11px; background: #fff;
  border-radius: 50% 50% 50% 50% / 60% 60% 40% 40%;
}
.brand-badge::before { left: 4px; transform: rotate(-25deg); }
.brand-badge::after { right: 4px; transform: rotate(25deg); }
.brand-badge i {
  position: absolute; left: 50%; top: 50%; width: 9px; height: 9px; background: #fff;
  border-radius: 50%; transform: translate(-50%, -50%);
}
.brand-name { font-size: 18px; font-weight: 700; color: var(--brand); }
.nav-item {
  border: none; background: transparent; color: var(--text-2);
  font-size: 14px; font-weight: 600; padding: 8px 12px; border-radius: 12px;
  cursor: pointer; transition: background 0.18s, color 0.18s;
}
.nav-item:hover { background: var(--surface-tint); color: var(--brand); }
.nav-item.active { background: linear-gradient(90deg, var(--brand-2), var(--brand)); color: var(--on-brand); box-shadow: 0 6px 16px var(--glow-1); }
.nav-right { display: flex; align-items: center; gap: 14px; }
.greet { font-size: 14px; color: var(--text); font-weight: 600; }
.logout-btn {
  border: 2px solid var(--border); background: var(--surface-soft); color: var(--brand);
  font-size: 13px; font-weight: 600; padding: 7px 16px; border-radius: 12px; cursor: pointer;
}
.logout-btn:hover { background: var(--tint-2); }

.content { flex: 1 1 auto; padding: 6px 20px 40px; }
.content-inner { max-width: 860px; margin: 0 auto; }
.content-head { display: flex; align-items: baseline; justify-content: space-between; margin: 14px 4px 18px; }
.content-head h2 { font-size: 18px; color: var(--text); }
.count { font-size: 13px; color: var(--text-3); }

.order-list { display: flex; flex-direction: column; gap: 16px; }
.order-card {
  background: var(--card); border: 2px solid var(--border); border-radius: 18px;
  padding: 16px 20px; box-shadow: 0 10px 26px var(--shadow-1);
}
.order-head { display: flex; align-items: center; gap: 14px; padding-bottom: 12px; border-bottom: 1px dashed var(--border); }
.order-no { font-size: 14px; font-weight: 700; color: var(--text); }
.order-time { font-size: 12px; color: var(--text-3); flex: 1; }
.order-status { font-size: 12px; font-weight: 700; padding: 3px 10px; border-radius: 999px; background: var(--surface-tint); color: var(--brand); }
.order-status.st-completed { color: #2fa268; }
.order-status.st-refunded { color: var(--danger-strong); }

.order-items { padding: 8px 0; }
.order-item { display: flex; align-items: center; gap: 12px; padding: 6px 0; font-size: 13px; color: var(--text); }
.item-emoji { font-size: 24px; }
.item-name { flex: 1; }
.item-qty { color: var(--text-3); }
.item-price { font-weight: 700; color: var(--brand); min-width: 78px; text-align: right; }

.order-foot { display: flex; align-items: center; justify-content: space-between; gap: 12px; padding-top: 12px; border-top: 1px dashed var(--border); }
.order-addr { font-size: 12px; color: var(--text-3); }
.order-total { font-size: 13px; color: var(--text); white-space: nowrap; }
.order-total b { font-size: 18px; color: var(--brand); }

.empty { text-align: center; padding: 80px 0; color: var(--text-3); }
.empty-emoji { font-size: 52px; margin-bottom: 14px; }
.go-btn {
  margin-top: 16px; border: none; border-radius: 999px;
  background: linear-gradient(90deg, var(--brand-2), var(--brand)); color: var(--on-brand);
  font-size: 14px; font-weight: 600; padding: 11px 28px; cursor: pointer;
}
.loading { text-align: center; padding: 40px; color: var(--text-3); font-size: 14px; }

@media (max-width: 720px) {
  .nav-menu { display: none; }
  .order-addr { display: none; }
}
</style>
