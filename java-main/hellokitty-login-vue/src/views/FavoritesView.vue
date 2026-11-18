<template>
  <div class="fav-page">
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
            <button class="nav-item active" @click="router.push('/favorites')">
              💗 我的收藏<span class="nav-badge" v-if="store.favorites.length">{{ store.favorites.length }}</span>
            </button>
            <button class="nav-item" @click="router.push('/cart')" data-cart-fly-target>
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
          <h2>我的收藏</h2>
          <span class="count">{{ store.favorites.length }} 件心水好物</span>
        </div>

        <!-- 批量操作栏 -->
        <div class="batch-bar" v-if="store.favorites.length">
          <label class="check-all">
            <input type="checkbox" :checked="allChecked" @change="toggleCheckAll">
            全选
          </label>
          <span class="batch-count">已选 {{ selectedIds.length }} 件</span>
          <div class="batch-actions">
            <button class="batch-btn primary" :disabled="!selectedIds.length || batchAdding" @click="batchAddToCart">
              {{ batchAdding ? '加入中…' : '🛒 批量加入购物车' }}
            </button>
            <button class="batch-btn danger" :disabled="!selectedIds.length" @click="batchRemove">
              💔 移除收藏
            </button>
          </div>
        </div>

        <div class="grid" v-if="store.favorites.length">
          <div class="good-card" v-for="item in store.favorites" :key="item.id" :class="{ selected: isChecked(item.id) }">
            <label class="pick-box" @click.stop>
              <input type="checkbox" :checked="isChecked(item.id)" @change="toggleCheck(item.id)">
            </label>
            <button
              class="fav-btn on"
              title="取消收藏"
              @click.stop="removeFav(item, $event)"
            >💖</button>
            <div class="good-emoji">
              <img v-if="item.image" :src="item.image" :alt="item.name" class="good-img" loading="lazy">
              <template v-else>{{ item.emoji }}</template>
            </div>
            <div class="good-name">{{ item.name }}</div>
            <div class="good-desc">{{ item.description }}</div>
            <div class="good-foot">
              <span class="good-price">¥{{ Number(item.price).toFixed(2) }}</span>
              <span class="good-tag">{{ item.tag }}</span>
            </div>
            <button class="cart-add-btn" @click="addOne(item, $event)">＋ 加入购物车</button>
          </div>
        </div>

        <div class="empty" v-else>
          <div class="empty-emoji">💝</div>
          <p>还没有收藏任何好物，去首页逛逛吧~</p>
          <button class="go-btn" @click="router.push('/home')">去首页看看</button>
        </div>
      </div>
    </main>

    <ToastMessage :message="toast" :visible="!!toast" />
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useRouter } from 'vue-router'
import { store } from '../api/store'
import { heartBurst, beatHeart, flyToCart } from '../utils/effects'
import ToastMessage from '../components/ToastMessage.vue'

const router = useRouter()
const user = JSON.parse(localStorage.getItem('user') || '{}')
const username = computed(() => user.username || '可爱用户')

// ===== 批量选择 =====
const selectedIds = ref([])
const batchAdding = ref(false)
const toast = ref('')
let toastTimer = null
function showToast(msg) {
  toast.value = msg
  clearTimeout(toastTimer)
  toastTimer = setTimeout(() => (toast.value = ''), 2000)
}

function isChecked(id) {
  return selectedIds.value.includes(String(id))
}

function toggleCheck(id) {
  const key = String(id)
  const i = selectedIds.value.indexOf(key)
  if (i >= 0) selectedIds.value.splice(i, 1)
  else selectedIds.value.push(key)
}

const allChecked = computed(() =>
  store.favorites.length > 0 && store.favorites.every(i => isChecked(i.id))
)

function toggleCheckAll() {
  if (allChecked.value) {
    selectedIds.value = []
  } else {
    selectedIds.value = store.favorites.map(i => String(i.id))
  }
}

// ===== 取消收藏 =====
function removeFav(item, e) {
  // 收藏页的爱心是取消操作：给一个粉色闪光告别动画
  if (e && e.currentTarget) heartBurst(e.currentTarget)
  store.toggleFavorite(item)
  selectedIds.value = selectedIds.value.filter(k => k !== String(item.id))
}

// ===== 加入购物车 =====
function addOne(item, e) {
  store.addToCart(item)
  if (e && e.currentTarget) flyToCart(e.currentTarget, item)
}

async function batchAddToCart() {
  if (!selectedIds.value.length) return
  batchAdding.value = true
  const items = store.favorites.filter(i => isChecked(i.id))
  // 逐个加入并播放飞入动画（每个间隔 90ms，形成连飞效果）
  for (const it of items) {
    store.addToCart(it)
  }
  const source = document.querySelector('.batch-btn.primary')
  items.forEach((it, idx) => {
    setTimeout(() => flyToCart(source || document.body, it), idx * 90)
  })
  setTimeout(() => {
    batchAdding.value = false
    showToast(`已把 ${items.length} 件好物加入购物车 🛒`)
    selectedIds.value = []
  }, items.length * 90 + 500)
}

function batchRemove() {
  if (!selectedIds.value.length) return
  if (!window.confirm(`确定移除选中的 ${selectedIds.value.length} 件收藏吗？`)) return
  store.favorites = store.favorites.filter(i => !isChecked(i.id))
  store.persist()
  selectedIds.value = []
}
</script>

<style scoped>
.fav-page {
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
.content-inner { max-width: 1080px; margin: 0 auto; }
.content-head {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  margin: 14px 4px 12px;
}
.content-head h2 { font-size: 18px; color: var(--text); }
.count { font-size: 13px; color: var(--text-3); }

/* ===== 批量操作栏 ===== */
.batch-bar {
  display: flex;
  align-items: center;
  gap: 16px;
  flex-wrap: wrap;
  background: var(--card);
  border: 2px solid var(--border);
  border-radius: 16px;
  padding: 10px 16px;
  margin: 0 4px 16px;
  box-shadow: 0 8px 22px var(--shadow-1);
}
.check-all {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  font-size: 14px;
  font-weight: 600;
  color: var(--text);
  cursor: pointer;
}
.check-all input { width: 16px; height: 16px; accent-color: var(--brand); cursor: pointer; }
.batch-count { font-size: 13px; color: var(--text-3); }
.batch-actions { margin-left: auto; display: flex; gap: 10px; }
.batch-btn {
  border: 2px solid var(--border);
  border-radius: 999px;
  font-size: 13px;
  font-weight: 600;
  padding: 8px 18px;
  cursor: pointer;
  transition: background 0.18s, color 0.18s, transform 0.15s, opacity 0.15s;
}
.batch-btn.primary {
  background: linear-gradient(90deg, var(--brand-2), var(--brand));
  border-color: transparent;
  color: var(--on-brand);
}
.batch-btn.primary:hover:not(:disabled) { transform: translateY(-1px); box-shadow: 0 6px 16px var(--glow-2); }
.batch-btn.danger {
  background: var(--surface-soft);
  color: var(--admin-danger, #e05666);
}
.batch-btn.danger:hover:not(:disabled) { background: var(--surface-tint); }
.batch-btn:disabled { opacity: 0.5; cursor: not-allowed; }

.grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 16px; }
.good-card {
  position: relative;
  background: var(--card);
  border: 2px solid var(--border);
  border-radius: 20px;
  padding: 22px 16px 14px;
  text-align: center;
  box-shadow: 0 10px 26px var(--shadow-1);
  transition: transform 0.18s, box-shadow 0.18s, border-color 0.18s;
  display: flex;
  flex-direction: column;
}
.good-card:hover { transform: translateY(-4px); box-shadow: 0 16px 34px var(--shadow-3); }
.good-card.selected { border-color: var(--brand-3); }
.pick-box {
  position: absolute;
  top: 10px;
  left: 10px;
  display: inline-flex;
  align-items: center;
  cursor: pointer;
}
.pick-box input { width: 17px; height: 17px; accent-color: var(--brand); cursor: pointer; }
.fav-btn {
  position: absolute;
  top: 10px; right: 10px;
  border: none;
  background: transparent;
  font-size: 18px;
  cursor: pointer;
  padding: 4px;
  border-radius: 50%;
  transition: transform 0.15s;
}
.fav-btn:hover { transform: scale(1.25); }
.good-emoji { font-size: 40px; margin-bottom: 12px; }
.good-img {
  width: 100%;
  height: 140px;
  object-fit: cover;
  border-radius: 14px;
  display: block;
}
.good-name { font-size: 14px; color: var(--text); font-weight: 600; margin-bottom: 6px; }
.good-desc {
  font-size: 12px;
  color: var(--text-6);
  line-height: 1.5;
  margin-bottom: 10px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.good-foot { display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; }
.good-price { font-size: 15px; font-weight: 700; color: var(--brand); }
.good-tag {
  display: inline-block;
  font-size: 12px;
  color: var(--brand);
  background: var(--surface-tint);
  border-radius: 999px;
  padding: 3px 12px;
}
.cart-add-btn {
  margin-top: auto;
  border: 2px solid var(--border);
  background: var(--surface-soft);
  color: var(--brand);
  font-size: 13px;
  font-weight: 600;
  padding: 8px 0;
  border-radius: 12px;
  width: 100%;
  cursor: pointer;
  transition: background 0.18s, color 0.18s, transform 0.15s;
}
.cart-add-btn:hover {
  background: linear-gradient(90deg, var(--brand-2), var(--brand));
  border-color: transparent;
  color: var(--on-brand);
  transform: translateY(-1px);
}
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
</style>
