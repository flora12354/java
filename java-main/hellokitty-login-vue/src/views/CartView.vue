<template>
  <div class="cart-page">
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
            <button class="nav-item" @click="router.push('/favorites')">
              💗 我的收藏<span class="nav-badge" v-if="store.favorites.length">{{ store.favorites.length }}</span>
            </button>
            <button class="nav-item active" @click="router.push('/cart')">
              🛒 购物车<span class="nav-badge" v-if="store.cartCount()">{{ store.cartCount() }}</span>
            </button>
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
          <h2>购物车</h2>
          <span class="count">共 {{ store.cartCount() }} 件商品</span>
        </div>

        <template v-if="store.cart.length">
          <div class="cart-list">
            <div class="cart-row" v-for="item in store.cart" :key="item.id">
              <div class="row-emoji">
                <img v-if="item.image" :src="item.image" :alt="item.name" class="row-img" loading="lazy">
                <template v-else>{{ item.emoji }}</template>
              </div>
              <div class="row-info">
                <div class="row-name">{{ item.name }}</div>
                <div class="row-price">¥{{ Number(item.price).toFixed(2) }}</div>
              </div>
              <div class="qty-box">
                <button class="qty-btn" @click="store.updateQty(item.id, item.qty - 1)">−</button>
                <span class="qty-num">{{ item.qty }}</span>
                <button class="qty-btn" @click="store.updateQty(item.id, item.qty + 1)">＋</button>
              </div>
              <div class="row-subtotal">¥{{ (Number(item.price) * item.qty).toFixed(2) }}</div>
              <button class="row-del" title="移除" @click="store.removeFromCart(item.id)">🗑️</button>
            </div>
          </div>

          <div class="cart-summary">
            <button class="clear-btn" @click="clearAll">清空购物车</button>
            <div class="summary-right">
              <div class="total-line">
                <span>合计：</span>
                <span class="total-price">¥{{ store.cartTotal().toFixed(2) }}</span>
              </div>
              <button class="checkout-btn" @click="checkout">去结算 ({{ store.cartCount() }})</button>
            </div>
          </div>
        </template>

        <div class="empty" v-else>
          <div class="empty-emoji">🧺</div>
          <p>购物车空空的，快去挑几件可爱的小东西吧~</p>
          <button class="go-btn" @click="router.push('/home')">去首页逛逛</button>
        </div>
      </div>
    </main>

    <!-- 结算成功弹层 -->
    <div class="toast-mask" v-if="paid" @click="paid = false">
      <div class="toast-box">
        <div class="toast-emoji">🎉</div>
        <p class="toast-text">下单成功！共 {{ paidCount }} 件，金额 ¥{{ paidTotal }}</p>
        <p class="toast-sub">这是演示结算，祝你购物愉快～</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { store } from '../api/store'

const router = useRouter()
const user = JSON.parse(localStorage.getItem('user') || '{}')
const username = computed(() => user.username || '可爱用户')

const paid = ref(false)
const paidCount = ref(0)
const paidTotal = ref('0.00')

function clearAll() {
  if (window.confirm('确定清空购物车吗？')) store.clearCart()
}

function checkout() {
  paidCount.value = store.cartCount()
  paidTotal.value = store.cartTotal().toFixed(2)
  store.clearCart()
  paid.value = true
}
</script>

<style scoped>
.cart-page {
  position: relative;
  z-index: 2;
  width: 100%;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}
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
.brand { display: flex; align-items: center; gap: 10px; cursor: pointer; }
.brand-badge {
  position: relative;
  width: 34px; height: 34px;
  border-radius: 50%;
  background: linear-gradient(135deg, #ff7aa8, #ff5c8a);
  box-shadow: 0 4px 12px rgba(255, 92, 138, 0.35);
  flex: none;
}
.brand-badge::before, .brand-badge::after {
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
.brand-name { font-size: 18px; font-weight: 700; color: #ff5c8a; }
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
  position: relative;
  transition: background 0.18s, color 0.18s;
}
.nav-item:hover { background: #fff0f6; color: #ff5c8a; }
.nav-item.active {
  background: linear-gradient(90deg, #ff7aa8, #ff5c8a);
  color: #fff;
  box-shadow: 0 6px 16px rgba(255, 92, 138, 0.3);
}
.nav-badge {
  position: absolute;
  top: -4px;
  right: -4px;
  min-width: 18px;
  height: 18px;
  padding: 0 5px;
  border-radius: 999px;
  background: linear-gradient(135deg, #ff5c8a, #ff7aa8);
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 8px rgba(255, 92, 138, 0.45);
}
.nav-item.active .nav-badge {
  background: #fff;
  color: #ff5c8a;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}
.nav-right { display: flex; align-items: center; gap: 14px; }
.greet { font-size: 14px; color: #5d3a47; font-weight: 600; }
.logout-btn {
  border: 2px solid #ffd9e6;
  background: #fff8fb;
  color: #ff5c8a;
  font-size: 13px;
  font-weight: 600;
  padding: 7px 16px;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.18s;
}
.logout-btn:hover { background: #ffe3ee; }

.content { flex: 1 1 auto; padding: 6px 20px 30px; }
.content-inner { max-width: 860px; margin: 0 auto; }
.content-head {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  margin: 14px 4px 18px;
}
.content-head h2 { font-size: 18px; color: #5d3a47; }
.count { font-size: 13px; color: #c48ba2; }

.cart-list {
  background: #ffffff;
  border: 2px solid #ffd9e6;
  border-radius: 20px;
  box-shadow: 0 10px 26px rgba(255, 105, 155, 0.14);
  overflow: hidden;
}
.cart-row {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px 20px;
}
.cart-row + .cart-row { border-top: 1px dashed #ffd9e6; }
.row-emoji { font-size: 32px; flex: none; }
.row-img {
  width: 56px;
  height: 56px;
  object-fit: cover;
  border-radius: 12px;
  display: block;
}
.row-info { flex: 1; min-width: 0; }
.row-name { font-size: 14px; font-weight: 600; color: #5d3a47; margin-bottom: 4px; }
.row-price { font-size: 13px; color: #b08898; }
.qty-box {
  display: flex;
  align-items: center;
  gap: 10px;
  background: #fff0f6;
  border-radius: 999px;
  padding: 4px 8px;
  flex: none;
}
.qty-btn {
  border: none;
  background: transparent;
  color: #ff5c8a;
  font-size: 15px;
  font-weight: 700;
  width: 24px; height: 24px;
  border-radius: 50%;
  cursor: pointer;
  transition: background 0.15s;
}
.qty-btn:hover { background: #ffe3ee; }
.qty-num { min-width: 22px; text-align: center; font-weight: 700; color: #5d3a47; font-size: 14px; }
.row-subtotal { width: 90px; text-align: right; font-weight: 700; color: #ff5c8a; font-size: 15px; flex: none; }
.row-del {
  border: none;
  background: transparent;
  font-size: 17px;
  cursor: pointer;
  opacity: 0.6;
  transition: opacity 0.15s, transform 0.15s;
  flex: none;
}
.row-del:hover { opacity: 1; transform: scale(1.15); }

.cart-summary {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 18px;
  background: #ffffff;
  border: 2px solid #ffd9e6;
  border-radius: 18px;
  padding: 14px 20px;
  box-shadow: 0 10px 26px rgba(255, 105, 155, 0.14);
}
.clear-btn {
  border: none;
  background: transparent;
  color: #c48ba2;
  font-size: 13px;
  cursor: pointer;
}
.clear-btn:hover { color: #e05260; }
.summary-right { display: flex; align-items: center; gap: 18px; }
.total-line { font-size: 14px; color: #5d3a47; }
.total-price { font-size: 20px; font-weight: 800; color: #ff5c8a; }
.checkout-btn {
  border: none;
  border-radius: 999px;
  background: linear-gradient(90deg, #ff7aa8, #ff5c8a);
  color: #fff;
  font-size: 15px;
  font-weight: 700;
  padding: 12px 30px;
  cursor: pointer;
  transition: transform 0.15s, box-shadow 0.15s;
}
.checkout-btn:hover { transform: translateY(-1px); box-shadow: 0 8px 20px rgba(255, 92, 138, 0.35); }

.empty { text-align: center; padding: 80px 0; color: #c48ba2; }
.empty-emoji { font-size: 52px; margin-bottom: 14px; }
.go-btn {
  margin-top: 16px;
  border: none;
  border-radius: 999px;
  background: linear-gradient(90deg, #ff7aa8, #ff5c8a);
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  padding: 11px 28px;
  cursor: pointer;
  transition: transform 0.15s, box-shadow 0.15s;
}
.go-btn:hover { transform: translateY(-1px); box-shadow: 0 8px 20px rgba(255, 92, 138, 0.35); }

.toast-mask {
  position: fixed;
  inset: 0;
  background: rgba(93, 58, 71, 0.35);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
}
.toast-box {
  background: #fff;
  border-radius: 22px;
  padding: 36px 46px;
  text-align: center;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2);
}
.toast-emoji { font-size: 48px; margin-bottom: 12px; }
.toast-text { font-size: 16px; color: #5d3a47; font-weight: 700; margin-bottom: 6px; }
.toast-sub { font-size: 13px; color: #c48ba2; }
</style>
