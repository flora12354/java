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
            <button class="nav-item" @click="router.push('/cart')" data-cart-fly-target>
              🛒 购物车<span class="nav-badge" v-if="store.cartCount()">{{ store.cartCount() }}</span>
            </button>
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
              <button class="btn cart" @click="handleCart($event)">加入购物车</button>
            </div>
            <p class="toast" v-if="toast">{{ toast }}</p>
          </div>
        </section>

        <!-- 评价区 -->
        <section class="review-card">
          <div class="review-head">
            <h2 class="review-title">宝贝评价 <span class="review-count">({{ reviewList.length }})</span></h2>
            <span class="review-avg" v-if="reviewList.length">
              {{ avgRating }} 分<span class="stars">⭐</span>
            </span>
            <button class="write-toggle" @click="formOpen = !formOpen">
              {{ formOpen ? '收起' : '✏️ 写评价' }}
            </button>
          </div>

          <div class="review-form" v-if="formOpen">
            <div class="star-row">
              <span class="star-label">评分：</span>
              <button
                v-for="n in 5" :key="n"
                class="star-btn" :class="{ on: n <= rating }"
                @click="rating = n"
              >{{ n <= rating ? '💖' : '🤍' }}</button>
              <span class="star-text">{{ rating }} 星</span>
            </div>
            <textarea
              v-model.trim="reviewContent"
              class="review-input"
              rows="3"
              maxlength="200"
              placeholder="说说你的使用感受吧～（2-200 字）"
            ></textarea>
            <div class="review-form-foot">
              <span class="review-hint">评价提交后需管理员审核通过才会展示</span>
              <button class="review-submit" :disabled="reviewSubmitting" @click="submitReview">
                {{ reviewSubmitting ? '提交中…' : '提交评价' }}
              </button>
            </div>
            <p class="review-error" v-if="reviewError">{{ reviewError }}</p>
          </div>

          <div class="review-list" v-if="reviewList.length">
            <div class="review-row" v-for="r in reviewList" :key="r.id">
              <span class="review-avatar">{{ (r.username || 'U').slice(0, 1).toUpperCase() }}</span>
              <div class="review-body">
                <div class="review-meta">
                  <b>{{ r.username }}</b>
                  <span class="review-stars">{{ '⭐'.repeat(Number(r.rating) || 0) }}</span>
                  <span class="review-time">{{ formatTime(r.createTime) }}</span>
                </div>
                <p class="review-content">{{ r.content }}</p>
              </div>
            </div>
          </div>
          <p class="review-empty" v-else>还没有评价，快来抢沙发吧～</p>
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
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { findGoodsById } from '../api/goodsData'
import { store } from '../api/store'
import { flyToCart } from '../utils/effects'
import { goodsReviewListApi, createReviewApi } from '../api/reviews'

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
function handleCart(e) {
  store.addToCart(goods)
  if (e && e.currentTarget) {
    // 从商品大图飞进导航栏购物车图标
    const imgEl = document.querySelector('.detail-emoji')
    flyToCart(imgEl || e.currentTarget, goods)
  }
  showToast('已加入购物车 🛒')
}

function handleLogout() {
  localStorage.removeItem('user')
  router.push('/login')
}

// ===== 评价区 =====
const reviewList = ref([])
const formOpen = ref(route.query.review === '1')
const rating = ref(5)
const reviewContent = ref('')
const reviewSubmitting = ref(false)
const reviewError = ref('')

const avgRating = computed(() => {
  if (!reviewList.value.length) return '-'
  const sum = reviewList.value.reduce((s, r) => s + (Number(r.rating) || 0), 0)
  return (sum / reviewList.value.length).toFixed(1)
})

function formatTime(t) {
  if (!t) return '-'
  return String(t).replace('T', ' ').slice(0, 10)
}

async function loadReviews() {
  if (!goods) return
  try {
    const res = await goodsReviewListApi(goods.id)
    reviewList.value = res && res.code === 200 ? (res.data || []) : []
  } catch (e) {
    reviewList.value = []
  }
}

async function submitReview() {
  reviewError.value = ''
  if (!user.id) {
    reviewError.value = '请先登录后再评价'
    return
  }
  if (!reviewContent.value || reviewContent.value.length < 2) {
    reviewError.value = '评价内容至少 2 个字'
    return
  }
  reviewSubmitting.value = true
  try {
    const res = await createReviewApi(user.id, goods.id, rating.value, reviewContent.value)
    if (res && res.code === 200) {
      showToast('评价已提交，审核通过后展示 💞')
      reviewContent.value = ''
      rating.value = 5
      formOpen.value = false
    } else {
      reviewError.value = (res && res.msg) || '提交失败'
    }
  } catch (e) {
    reviewError.value = e.message || '网络请求失败'
  } finally {
    reviewSubmitting.value = false
  }
}

onMounted(loadReviews)
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
  background: var(--nav-glass);
  backdrop-filter: blur(8px);
  border: 2px solid var(--border);
  border-radius: 22px;
  box-shadow: 0 12px 30px var(--shadow-2);
  padding: 10px 20px;
}
.nav-left { display: flex; align-items: center; gap: 22px; }
.brand { display: flex; align-items: center; gap: 10px; }
.brand-badge {
  position: relative;
  width: 34px; height: 34px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--brand-2), var(--brand));
  box-shadow: 0 4px 12px var(--glow-2);
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
.brand-name { font-size: 18px; font-weight: 700; color: var(--brand); letter-spacing: 0.5px; }
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
.nav-right { display: flex; align-items: center; gap: 14px; }
.greet { font-size: 14px; color: var(--text); font-weight: 600; }
.cat { font-size: 16px; }
.logout-btn {
  border: 2px solid var(--border);
  background: var(--surface-soft);
  color: var(--brand);
  font-size: 13px;
  font-weight: 600;
  padding: 7px 16px;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.18s, transform 0.15s;
}
.logout-btn:hover { background: var(--tint-2); transform: translateY(-1px); }

/* ===== 详情主体 ===== */
.page { flex: 1; padding: 6px 20px 40px; overflow-y: auto; }
.page-inner { max-width: 860px; margin: 0 auto; }
.back-btn {
  border: none;
  background: transparent;
  color: var(--brand);
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
  background: var(--card);
  border: 2px solid var(--border);
  border-radius: 24px;
  padding: 36px 32px;
  box-shadow: 0 14px 36px var(--shadow-2);
}
.detail-emoji {
  flex: none;
  width: 180px; height: 180px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 90px;
  background: linear-gradient(135deg, var(--surface-tint), var(--tint-2));
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
.detail-name { font-size: 26px; color: var(--text); margin-bottom: 12px; }
.detail-meta { display: flex; align-items: center; gap: 16px; margin-bottom: 18px; }
.good-tag {
  font-size: 13px;
  color: var(--brand);
  background: var(--surface-tint);
  border-radius: 999px;
  padding: 4px 14px;
}
.good-price {
  font-size: 24px;
  font-weight: 700;
  color: var(--brand);
}
.detail-desc {
  font-size: 15px;
  line-height: 1.8;
  color: var(--text-2);
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
  background: linear-gradient(90deg, var(--brand-2), var(--brand));
  color: var(--on-brand);
  box-shadow: 0 8px 20px var(--glow-2);
}
.btn.cart {
  border: 2px solid var(--border);
  background: var(--surface-soft);
  color: var(--brand);
}
.toast {
  margin-top: 14px;
  font-size: 13px;
  color: var(--brand-3);
}
.empty { text-align: center; padding: 80px 0; color: var(--text-3); }
.empty-emoji { font-size: 46px; margin-bottom: 12px; }

/* ===== 评价区 ===== */
.review-card {
  margin-top: 22px;
  background: var(--card);
  border: 2px solid var(--border);
  border-radius: 24px;
  padding: 24px 28px;
  box-shadow: 0 14px 36px var(--shadow-2);
}
.review-head {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 14px;
}
.review-title { font-size: 17px; color: var(--text); margin: 0; }
.review-count { font-size: 14px; color: var(--text-3); font-weight: 400; }
.review-avg { font-size: 14px; color: var(--brand); font-weight: 700; }
.review-avg .stars { font-size: 12px; }
.write-toggle {
  margin-left: auto;
  border: 2px solid var(--border);
  background: var(--surface-soft);
  color: var(--brand);
  font-size: 13px;
  font-weight: 600;
  padding: 7px 16px;
  border-radius: 999px;
  cursor: pointer;
  transition: background 0.18s, transform 0.15s;
}
.write-toggle:hover { background: var(--surface-tint); transform: translateY(-1px); }

.review-form {
  border: 2px dashed var(--border);
  border-radius: 16px;
  padding: 14px 16px;
  margin-bottom: 16px;
}
.star-row { display: flex; align-items: center; gap: 6px; margin-bottom: 10px; }
.star-label { font-size: 13px; color: var(--text-2); font-weight: 600; }
.star-btn {
  border: none;
  background: transparent;
  font-size: 20px;
  cursor: pointer;
  padding: 2px;
  transition: transform 0.15s;
}
.star-btn:hover { transform: scale(1.2); }
.star-text { font-size: 12px; color: var(--text-3); margin-left: 6px; }
.review-input {
  width: 100%;
  box-sizing: border-box;
  border: 2px solid var(--border);
  border-radius: 12px;
  padding: 10px 12px;
  font-size: 14px;
  color: var(--text);
  background: transparent;
  outline: none;
  resize: vertical;
  margin-bottom: 10px;
}
.review-input:focus { border-color: var(--brand-3); }
.review-form-foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}
.review-hint { font-size: 12px; color: var(--text-4); }
.review-submit {
  border: none;
  background: linear-gradient(90deg, var(--brand-2), var(--brand));
  color: var(--on-brand);
  font-size: 13px;
  font-weight: 700;
  padding: 8px 20px;
  border-radius: 999px;
  cursor: pointer;
  transition: transform 0.15s, box-shadow 0.15s, opacity 0.15s;
}
.review-submit:hover:not(:disabled) { transform: translateY(-1px); box-shadow: 0 6px 16px var(--glow-2); }
.review-submit:disabled { opacity: 0.6; cursor: not-allowed; }
.review-error { font-size: 13px; color: var(--danger-strong); margin: 8px 0 0; }

.review-list { display: flex; flex-direction: column; gap: 14px; }
.review-row { display: flex; gap: 12px; align-items: flex-start; }
.review-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  flex: none;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, var(--brand-4), var(--brand-2));
  color: var(--on-brand);
  font-size: 14px;
  font-weight: 700;
}
.review-body { flex: 1; min-width: 0; }
.review-meta { display: flex; align-items: baseline; gap: 10px; margin-bottom: 4px; }
.review-meta b { font-size: 13px; color: var(--text); }
.review-stars { font-size: 11px; letter-spacing: 1px; }
.review-time { font-size: 11px; color: var(--text-4); margin-left: auto; }
.review-content { font-size: 14px; color: var(--text-2); line-height: 1.6; margin: 0; }
.review-empty { font-size: 13px; color: var(--text-3); text-align: center; padding: 18px 0 4px; }

@media (max-width: 640px) {
  .detail-card { flex-direction: column; align-items: center; text-align: center; }
  .detail-actions { justify-content: center; }
}
</style>
