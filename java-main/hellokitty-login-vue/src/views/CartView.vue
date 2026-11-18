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
            <button class="nav-item" @click="router.push('/orders')">
              🧾 我的订单
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

    <!-- 结算弹层：选收货地址 -->
    <div class="toast-mask" v-if="checkoutVisible" @click.self="checkoutVisible = false">
      <div class="checkout-box">
        <h3 class="checkout-title">确认订单</h3>
        <div class="checkout-body">
          <p class="sec-label">收货地址</p>
          <label
            v-for="a in addressList" :key="a.id"
            class="addr-row" :class="{ on: selectedAddressId === String(a.id) }"
          >
            <input type="radio" name="addr" :value="String(a.id)" v-model="selectedAddressId">
            <span class="addr-text">
              <b>{{ a.receiver }}</b> {{ a.phone }}<br>
              <span class="addr-detail">{{ addrFull(a) }}</span>
              <span class="addr-default" v-if="a.isDefault">默认</span>
            </span>
          </label>
          <label class="addr-row" :class="{ on: selectedAddressId === 'manual' }">
            <input type="radio" name="addr" value="manual" v-model="selectedAddressId">
            <span class="addr-text">手动填写地址</span>
          </label>
          <div class="manual-box" v-if="selectedAddressId === 'manual'">
            <input v-model.trim="manual.receiver" type="text" placeholder="收货人">
            <input v-model.trim="manual.phone" type="text" placeholder="联系电话">
            <input v-model.trim="manual.address" type="text" placeholder="收货地址（省市区 + 详细地址）">
          </div>
          <p class="addr-empty" v-if="!addressList.length">还没有收货地址，可以先去「个人中心 → 收货地址」添加，或选择手动填写。</p>

          <p class="sec-label">商品清单（{{ store.cart.length }} 种）</p>
          <div class="mini-list">
            <div class="mini-row" v-for="it in store.cart" :key="it.id">
              <span class="mini-emoji">{{ it.emoji }}</span>
              <span class="mini-name">{{ it.name }} × {{ it.qty }}</span>
              <span class="mini-price">¥{{ (Number(it.price) * it.qty).toFixed(2) }}</span>
            </div>
          </div>
          <div class="checkout-total">合计：<b>¥{{ store.cartTotal().toFixed(2) }}</b></div>
          <p class="checkout-error" v-if="checkoutError">{{ checkoutError }}</p>
        </div>
        <div class="checkout-foot">
          <button class="ghost-btn" @click="checkoutVisible = false">取消</button>
          <button class="primary-btn" :disabled="submitting" @click="submitOrder">
            {{ submitting ? '提交中…' : '提交订单' }}
          </button>
        </div>
      </div>
    </div>

    <!-- 下单成功弹层 -->
    <div class="toast-mask" v-if="paid" @click="paid = false">
      <div class="toast-box">
        <div class="toast-emoji">🎉</div>
        <p class="toast-text">下单成功！</p>
        <p class="toast-sub">订单号 {{ paidOrderNo }} · 共 {{ paidCount }} 件，金额 ¥{{ paidTotal }}</p>
        <div class="paid-actions">
          <button class="ghost-btn" @click="paid = false">继续逛逛</button>
          <button class="primary-btn" @click="router.push('/orders')">查看我的订单</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { store } from '../api/store'
import { listAddresses } from '../api/user'
import { createOrderApi } from '../api/orders'

const router = useRouter()
const user = JSON.parse(localStorage.getItem('user') || '{}')
const username = computed(() => user.username || '可爱用户')

// ===== 结算 =====
const checkoutVisible = ref(false)
const checkoutError = ref('')
const submitting = ref(false)
const addressList = ref([])
const selectedAddressId = ref('')
const manual = ref({ receiver: '', phone: '', address: '' })

const paid = ref(false)
const paidCount = ref(0)
const paidTotal = ref('0.00')
const paidOrderNo = ref('')

function clearAll() {
  if (window.confirm('确定清空购物车吗？')) store.clearCart()
}

function addrFull(a) {
  return [a.province, a.city, a.district, a.detail].filter(Boolean).join(' ')
}

async function checkout() {
  checkoutError.value = ''
  checkoutVisible.value = true
  const res = await listAddresses()
  addressList.value = (res && res.ok && Array.isArray(res.data)) ? res.data : []
  const def = addressList.value.find(a => a.isDefault)
  selectedAddressId.value = def ? String(def.id) : (addressList.value.length ? String(addressList.value[0].id) : 'manual')
}

async function submitOrder() {
  checkoutError.value = ''
  const items = store.cart.map(i => ({
    goodsId: i.id,
    goodsName: i.name,
    emoji: i.emoji || '',
    price: Number(i.price),
    qty: i.qty || 1
  }))
  const payload = { userId: user.id, items }
  if (selectedAddressId.value !== 'manual') {
    payload.addressId = selectedAddressId.value
  } else {
    payload.receiver = manual.value.receiver
    payload.phone = manual.value.phone
    payload.address = manual.value.address
  }
  submitting.value = true
  try {
    const res = await createOrderApi(payload)
    if (res && res.code === 200 && res.data) {
      paidCount.value = store.cartCount()
      paidTotal.value = store.cartTotal().toFixed(2)
      paidOrderNo.value = res.data.orderNo || '-'
      store.clearCart()
      checkoutVisible.value = false
      paid.value = true
    } else {
      checkoutError.value = (res && res.msg) || '下单失败，请稍后重试'
    }
  } catch (e) {
    checkoutError.value = e.message || '网络请求失败'
  } finally {
    submitting.value = false
  }
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
  background: var(--nav-glass);
  backdrop-filter: blur(8px);
  border: 2px solid var(--border);
  border-radius: 22px;
  box-shadow: 0 12px 30px var(--shadow-2);
  padding: 10px 20px;
}
.nav-left { display: flex; align-items: center; gap: 22px; }
.brand { display: flex; align-items: center; gap: 10px; cursor: pointer; }
.brand-badge {
  position: relative;
  width: 34px; height: 34px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--brand-2), var(--brand));
  box-shadow: 0 4px 12px var(--glow-2);
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
.brand-name { font-size: 18px; font-weight: 700; color: var(--brand); }
.nav-menu { display: flex; gap: 6px; }
.nav-item {
  border: none;
  background: transparent;
  color: var(--text-2);
  font-size: 15px;
  font-weight: 600;
  padding: 8px 14px;
  border-radius: 12px;
  cursor: pointer;
  position: relative;
  transition: background 0.18s, color 0.18s;
}
.nav-item:hover { background: var(--surface-tint); color: var(--brand); }
.nav-item.active {
  background: linear-gradient(90deg, var(--brand-2), var(--brand));
  color: var(--on-brand);
  box-shadow: 0 6px 16px var(--glow-1);
}
.nav-badge {
  position: absolute;
  top: -4px;
  right: -4px;
  min-width: 18px;
  height: 18px;
  padding: 0 5px;
  border-radius: 999px;
  background: linear-gradient(135deg, var(--brand), var(--brand-2));
  color: var(--on-brand);
  font-size: 11px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 8px var(--glow-2);
}
.nav-item.active .nav-badge {
  background: var(--on-brand);
  color: var(--brand);
  box-shadow: 0 2px 8px var(--shadow-neutral);
}
.nav-right { display: flex; align-items: center; gap: 14px; }
.greet { font-size: 14px; color: var(--text); font-weight: 600; }
.logout-btn {
  border: 2px solid var(--border);
  background: var(--surface-soft);
  color: var(--brand);
  font-size: 13px;
  font-weight: 600;
  padding: 7px 16px;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.18s;
}
.logout-btn:hover { background: var(--tint-2); }

.content { flex: 1 1 auto; padding: 6px 20px 30px; }
.content-inner { max-width: 860px; margin: 0 auto; }
.content-head {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  margin: 14px 4px 18px;
}
.content-head h2 { font-size: 18px; color: var(--text); }
.count { font-size: 13px; color: var(--text-3); }

.cart-list {
  background: var(--card);
  border: 2px solid var(--border);
  border-radius: 20px;
  box-shadow: 0 10px 26px var(--shadow-1);
  overflow: hidden;
}
.cart-row {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px 20px;
}
.cart-row + .cart-row { border-top: 1px dashed var(--border); }
.row-emoji { font-size: 32px; flex: none; }
.row-img {
  width: 56px;
  height: 56px;
  object-fit: cover;
  border-radius: 12px;
  display: block;
}
.row-info { flex: 1; min-width: 0; }
.row-name { font-size: 14px; font-weight: 600; color: var(--text); margin-bottom: 4px; }
.row-price { font-size: 13px; color: var(--text-6); }
.qty-box {
  display: flex;
  align-items: center;
  gap: 10px;
  background: var(--surface-tint);
  border-radius: 999px;
  padding: 4px 8px;
  flex: none;
}
.qty-btn {
  border: none;
  background: transparent;
  color: var(--brand);
  font-size: 15px;
  font-weight: 700;
  width: 24px; height: 24px;
  border-radius: 50%;
  cursor: pointer;
  transition: background 0.15s;
}
.qty-btn:hover { background: var(--tint-2); }
.qty-num { min-width: 22px; text-align: center; font-weight: 700; color: var(--text); font-size: 14px; }
.row-subtotal { width: 90px; text-align: right; font-weight: 700; color: var(--brand); font-size: 15px; flex: none; }
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
  background: var(--card);
  border: 2px solid var(--border);
  border-radius: 18px;
  padding: 14px 20px;
  box-shadow: 0 10px 26px var(--shadow-1);
}
.clear-btn {
  border: none;
  background: transparent;
  color: var(--text-3);
  font-size: 13px;
  cursor: pointer;
}
.clear-btn:hover { color: var(--danger-strong); }
.summary-right { display: flex; align-items: center; gap: 18px; }
.total-line { font-size: 14px; color: var(--text); }
.total-price { font-size: 20px; font-weight: 800; color: var(--brand); }
.checkout-btn {
  border: none;
  border-radius: 999px;
  background: linear-gradient(90deg, var(--brand-2), var(--brand));
  color: var(--on-brand);
  font-size: 15px;
  font-weight: 700;
  padding: 12px 30px;
  cursor: pointer;
  transition: transform 0.15s, box-shadow 0.15s;
}
.checkout-btn:hover { transform: translateY(-1px); box-shadow: 0 8px 20px var(--glow-2); }

.empty { text-align: center; padding: 80px 0; color: var(--text-3); }
.empty-emoji { font-size: 52px; margin-bottom: 14px; }
.go-btn {
  margin-top: 16px;
  border: none;
  border-radius: 999px;
  background: linear-gradient(90deg, var(--brand-2), var(--brand));
  color: var(--on-brand);
  font-size: 14px;
  font-weight: 600;
  padding: 11px 28px;
  cursor: pointer;
  transition: transform 0.15s, box-shadow 0.15s;
}
.go-btn:hover { transform: translateY(-1px); box-shadow: 0 8px 20px var(--glow-2); }

.toast-mask {
  position: fixed;
  inset: 0;
  background: var(--overlay);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
}
.toast-box {
  background: var(--card);
  border-radius: 22px;
  padding: 36px 46px;
  text-align: center;
  box-shadow: 0 20px 50px var(--shadow-neutral-strong);
}
.toast-emoji { font-size: 48px; margin-bottom: 12px; }
.toast-text { font-size: 16px; color: var(--text); font-weight: 700; margin-bottom: 6px; }
.toast-sub { font-size: 13px; color: var(--text-3); }
.paid-actions { display: flex; gap: 12px; justify-content: center; margin-top: 18px; }

/* ===== 结算弹层 ===== */
.checkout-box {
  width: 520px;
  max-width: calc(100vw - 40px);
  background: var(--card);
  border-radius: 22px;
  padding: 24px 26px 20px;
  box-shadow: 0 20px 50px var(--shadow-neutral-strong);
  max-height: 86vh;
  display: flex;
  flex-direction: column;
}
.checkout-title { margin: 0 0 14px; font-size: 18px; color: var(--text); }
.checkout-body { overflow-y: auto; min-height: 0; }
.sec-label { font-size: 13px; font-weight: 700; color: var(--text-2); margin: 8px 0 8px; }
.addr-row {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  border: 2px solid var(--border);
  border-radius: 14px;
  padding: 10px 14px;
  margin-bottom: 8px;
  cursor: pointer;
  transition: border-color 0.18s, background 0.18s;
}
.addr-row.on { border-color: var(--brand-3); background: var(--surface-tint); }
.addr-row input { margin-top: 4px; accent-color: var(--brand); }
.addr-text { font-size: 13px; color: var(--text); line-height: 1.5; }
.addr-detail { color: var(--text-6); font-size: 12px; }
.addr-default {
  display: inline-block;
  margin-left: 8px;
  font-size: 11px;
  color: var(--brand);
  background: var(--surface-tint);
  border-radius: 999px;
  padding: 1px 8px;
}
.manual-box { display: flex; flex-direction: column; gap: 8px; margin: 8px 0 4px; }
.manual-box input {
  border: 2px solid var(--border);
  border-radius: 12px;
  padding: 9px 12px;
  font-size: 13px;
  color: var(--text);
  background: transparent;
  outline: none;
}
.manual-box input:focus { border-color: var(--brand-3); }
.addr-empty { font-size: 12px; color: var(--text-3); margin: 6px 0; }
.mini-list { border: 2px dashed var(--border); border-radius: 14px; padding: 10px 14px; }
.mini-row {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 5px 0;
  font-size: 13px;
  color: var(--text);
}
.mini-emoji { font-size: 20px; }
.mini-name { flex: 1; }
.mini-price { font-weight: 700; color: var(--brand); }
.checkout-total { text-align: right; font-size: 14px; color: var(--text); margin: 12px 0 4px; }
.checkout-total b { font-size: 20px; color: var(--brand); }
.checkout-error { font-size: 13px; color: var(--danger-strong); margin: 6px 0; }
.checkout-foot {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding-top: 14px;
}
.ghost-btn {
  border: 2px solid var(--border);
  background: var(--surface-soft);
  color: var(--text-2);
  font-size: 14px;
  font-weight: 600;
  padding: 10px 20px;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.18s;
}
.ghost-btn:hover { background: var(--surface-tint); }
.primary-btn {
  border: none;
  background: linear-gradient(90deg, var(--brand-2), var(--brand));
  color: var(--on-brand);
  font-size: 14px;
  font-weight: 700;
  padding: 10px 24px;
  border-radius: 12px;
  cursor: pointer;
  transition: transform 0.15s, box-shadow 0.15s;
}
.primary-btn:hover { transform: translateY(-1px); box-shadow: 0 8px 20px var(--glow-2); }
.primary-btn:disabled { opacity: 0.6; cursor: not-allowed; }
</style>
