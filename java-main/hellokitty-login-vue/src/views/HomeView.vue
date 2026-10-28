<template>
  <div class="home">
    <!-- 顶部导航栏 -->
    <header class="navbar">
      <div class="nav-inner">
        <div class="nav-left">
          <div class="brand" @click="goHome" role="button" title="回到首页">
            <span class="brand-badge"><i></i></span>
            <span class="brand-name">Hello Kitty</span>
          </div>
          <nav class="nav-menu">
            <button class="nav-item active" @click="goHome">首页</button>
            <button class="nav-item" @click="router.push('/about')">介绍</button>
            <button class="nav-item nav-icon-btn" @click="router.push('/favorites')" title="我的收藏">
              <span class="nav-ico">💗</span>
              <span class="nav-label">我的收藏</span>
              <span class="nav-badge" v-if="store.favorites.length">{{ store.favorites.length }}</span>
            </button>
            <button class="nav-item nav-icon-btn" @click="router.push('/cart')" title="购物车">
              <span class="nav-ico">🛒</span>
              <span class="nav-label">购物车</span>
              <span class="nav-badge" v-if="store.cartCount()">{{ store.cartCount() }}</span>
            </button>
            <button class="nav-item admin-btn" @click="router.push('/admin/login')">后台管理</button>
          </nav>
        </div>
        <div class="nav-right">
          <span class="greet">Hi，{{ username }} <span class="cat">🐱</span></span>
          <button class="logout-btn" @click="handleLogout">退出</button>
        </div>
      </div>
    </header>

    <!-- 搜索栏 -->
    <section class="hero">
      <h1 class="hero-title">今天想找点可爱的小东西吗？</h1>
      <p class="hero-sub">搜一搜，发现你的专属 Hello Kitty 好物</p>

      <form class="search-bar" @submit.prevent="onSearch">
        <span class="search-icon">🔍</span>
        <input
          v-model.trim="keyword"
          type="text"
          class="search-input"
          placeholder="搜索公仔、配饰、文具、家居…"
        >
        <button type="submit" class="search-btn" :disabled="loading">
          {{ loading ? '搜索中…' : '搜 索' }}
        </button>
      </form>

      <p class="search-hint" v-if="hasSearched && !usedBackend">
        当前展示为前端演示数据（后端 /api/search 接口已预留，待接入）
      </p>
    </section>

    <!-- 内容区 -->
    <main class="content" ref="contentRef">
      <div class="content-inner">
        <div class="content-head">
          <h2>{{ keyword ? `“${keyword}” 的搜索结果` : (activeTag === '全部' ? '为你推荐' : activeTag + ' · 分类') }}</h2>
          <span class="count">{{ results.length }} 件好物</span>
        </div>

        <div class="tag-bar">
          <button
            v-for="t in allTags" :key="t"
            class="tag-chip" :class="{ on: activeTag === t }"
            @click="pickTag(t)"
          >{{ t }}</button>
        </div>

        <div class="grid" v-if="results.length">
          <div class="good-card" v-for="item in results" :key="item.id">
            <button
              class="fav-btn"
              :class="{ on: store.isFavorite(item.id) }"
              :title="store.isFavorite(item.id) ? '取消收藏' : '加入收藏'"
              @click.stop="toggleFav(item)"
            >{{ store.isFavorite(item.id) ? '💖' : '🤍' }}</button>
            <div class="good-emoji" @click="goDetail(item)">{{ item.emoji }}</div>
            <div class="good-name" @click="goDetail(item)">{{ item.name }}</div>
            <div class="good-desc" @click="goDetail(item)">{{ item.description }}</div>
            <div class="good-foot">
              <span class="good-price">¥{{ Number(item.price).toFixed(2) }}</span>
              <span class="good-tag">{{ item.tag }}</span>
            </div>
            <button class="cart-add-btn" @click.stop="addToCart(item)" title="加入购物车">
              ＋ 加入购物车
            </button>
          </div>
        </div>

        <div class="empty" v-else>
          <div class="empty-emoji">🐾</div>
          <p>没有找到相关结果，换个关键词试试吧~</p>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { searchApi } from '../api/home'
import { mockGoods, filterGoods, allTags } from '../api/goodsData'
import { store } from '../api/store'

const router = useRouter()

const user = JSON.parse(localStorage.getItem('user') || '{}')
const username = computed(() => user.username || '可爱用户')

// 本地演示数据见 api/goodsData.js（与后端 goods 表字段一致，含 id/价格/描述）

const keyword = ref('')
const results = ref([...mockGoods])
const activeTag = ref('全部')
const loading = ref(false)
const usedBackend = ref(false)
const hasSearched = ref(false)
const contentRef = ref(null)

function filterLocal(kw) {
  return filterGoods(kw, activeTag.value)
}

function pickTag(t) {
  activeTag.value = t
  // 切换分类时在本地数据内筛选（若有关键词则一并应用）
  results.value = filterLocal(keyword.value)
  usedBackend.value = false
  if (contentRef.value) contentRef.value.scrollTop = 0
}

async function onSearch() {
  const kw = keyword.value.trim()
  loading.value = true
  hasSearched.value = true
  try {
    const res = await searchApi(kw)
    if (res && res.code === 200) {
      results.value = res.data || []
      usedBackend.value = true
    } else {
      throw new Error('empty')
    }
  } catch (e) {
    // 后端未实现 / 未启动：回退到本地演示数据
    results.value = filterLocal(kw)
    usedBackend.value = false
  } finally {
    loading.value = false
  }
}

function goHome() {
  keyword.value = ''
  activeTag.value = '全部'
  results.value = [...mockGoods]
  hasSearched.value = false
  usedBackend.value = false
  if (contentRef.value) contentRef.value.scrollTop = 0
}

function toggleFav(item) {
  store.toggleFavorite(item)
}

function addToCart(item) {
  store.addToCart(item)
}

function goDetail(item) {
  if (item && item.id != null) {
    router.push(`/goods/${item.id}`)
  }
}

function handleLogout() {
  localStorage.removeItem('user')
  router.push('/login')
}
</script>

<style scoped>
.home {
  position: relative;
  z-index: 2;
  width: 100%;
  height: 100vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

/* ===== 顶部导航栏 ===== */
.navbar {
  flex: none;
  padding: 14px 20px;
}
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
.nav-left {
  display: flex;
  align-items: center;
  gap: 22px;
}
.brand {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
}
.brand:hover .brand-name { color: #ff7aa8; }
.brand-badge {
  position: relative;
  width: 34px;
  height: 34px;
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
  width: 14px;
  height: 11px;
  background: #fff;
  border-radius: 50% 50% 50% 50% / 60% 60% 40% 40%;
}
.brand-badge::before { left: 4px; transform: rotate(-25deg); }
.brand-badge::after { right: 4px; transform: rotate(25deg); }
.brand-badge i {
  position: absolute;
  left: 50%;
  top: 50%;
  width: 9px;
  height: 9px;
  background: #fff;
  border-radius: 50%;
  transform: translate(-50%, -50%);
}
.brand-name {
  font-size: 18px;
  font-weight: 700;
  color: #ff5c8a;
  letter-spacing: 0.5px;
}
.nav-menu {
  display: flex;
  gap: 6px;
}
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
.nav-item:hover {
  background: #fff0f6;
  color: #ff5c8a;
}
.nav-item.admin-btn {
  border: 2px solid #ffd9e6;
  background: #fff8fb;
}
.nav-item.admin-btn:hover {
  background: #ffe3ee;
}
.nav-icon-btn {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  position: relative;
}
.nav-ico { font-size: 15px; line-height: 1; }
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
.nav-item.active {
  background: linear-gradient(90deg, #ff7aa8, #ff5c8a);
  color: #fff;
  box-shadow: 0 6px 16px rgba(255, 92, 138, 0.3);
}
.nav-right {
  display: flex;
  align-items: center;
  gap: 14px;
}
.greet {
  font-size: 14px;
  color: #5d3a47;
  font-weight: 600;
}
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
.logout-btn:hover {
  background: #ffe3ee;
  transform: translateY(-1px);
}

/* ===== 搜索栏 ===== */
.hero {
  flex: none;
  text-align: center;
  padding: 26px 20px 18px;
}
.hero-title {
  font-size: 26px;
  color: #ff5c8a;
  letter-spacing: 0.5px;
  margin-bottom: 8px;
}
.hero-sub {
  font-size: 14px;
  color: #c48ba2;
  margin-bottom: 22px;
}
.search-bar {
  max-width: 560px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  background: #ffffff;
  border: 2px solid #ffd9e6;
  border-radius: 999px;
  padding: 6px 6px 6px 18px;
  box-shadow: 0 14px 34px rgba(255, 105, 155, 0.22);
  transition: border-color 0.2s, box-shadow 0.2s;
}
.search-bar:focus-within {
  border-color: #ff8fb8;
  box-shadow: 0 0 0 5px rgba(255, 143, 184, 0.18), 0 14px 34px rgba(255, 105, 155, 0.22);
}
.search-icon {
  font-size: 18px;
  margin-right: 8px;
}
.search-input {
  flex: 1;
  border: none;
  outline: none;
  background: transparent;
  font-size: 15px;
  color: #5d3a47;
}
.search-input::placeholder { color: #d3a9bb; }
.search-btn {
  border: none;
  border-radius: 999px;
  background: linear-gradient(90deg, #ff7aa8, #ff5c8a);
  color: #fff;
  font-size: 15px;
  font-weight: 600;
  letter-spacing: 2px;
  padding: 11px 26px;
  cursor: pointer;
  transition: transform 0.15s, box-shadow 0.15s;
}
.search-btn:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 8px 20px rgba(255, 92, 138, 0.35);
}
.search-btn:disabled { opacity: 0.7; cursor: default; }
.search-hint {
  margin-top: 14px;
  font-size: 12px;
  color: #c48ba2;
}

/* ===== 内容区 ===== */
.content {
  flex: 1 1 auto;
  overflow-y: auto;
  padding: 6px 20px 30px;
}
.content-inner {
  max-width: 1080px;
  margin: 0 auto;
}
.content-head {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  margin: 10px 4px 18px;
}
.content-head h2 {
  font-size: 18px;
  color: #5d3a47;
}
.count {
  font-size: 13px;
  color: #c48ba2;
}
.tag-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin: 0 4px 18px;
}
.tag-chip {
  border: 2px solid #ffd9e6;
  background: #fff8fb;
  color: #a96f88;
  font-size: 13px;
  font-weight: 600;
  padding: 6px 16px;
  border-radius: 999px;
  cursor: pointer;
  transition: background 0.18s, color 0.18s, transform 0.15s;
}
.tag-chip:hover {
  background: #ffe3ee;
  color: #ff5c8a;
  transform: translateY(-1px);
}
.tag-chip.on {
  background: linear-gradient(90deg, #ff7aa8, #ff5c8a);
  border-color: transparent;
  color: #fff;
  box-shadow: 0 6px 16px rgba(255, 92, 138, 0.3);
}
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
  gap: 16px;
}
.good-card {
  position: relative;
  background: #ffffff;
  border: 2px solid #ffd9e6;
  border-radius: 20px;
  padding: 22px 16px 14px;
  text-align: center;
  box-shadow: 0 10px 26px rgba(255, 105, 155, 0.14);
  cursor: pointer;
  transition: transform 0.18s, box-shadow 0.18s;
  display: flex;
  flex-direction: column;
}
.good-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 16px 34px rgba(255, 105, 155, 0.28);
}
.fav-btn {
  position: absolute;
  top: 10px;
  right: 10px;
  border: none;
  background: transparent;
  font-size: 18px;
  line-height: 1;
  cursor: pointer;
  padding: 4px;
  border-radius: 50%;
  transition: transform 0.15s;
}
.fav-btn:hover { transform: scale(1.25); }
.fav-btn.on { animation: fav-pop 0.3s ease; }
@keyframes fav-pop {
  0% { transform: scale(0.6); }
  60% { transform: scale(1.3); }
  100% { transform: scale(1); }
}
.cart-add-btn {
  margin-top: auto;
  border: 2px solid #ffd9e6;
  background: #fff8fb;
  color: #ff5c8a;
  font-size: 13px;
  font-weight: 600;
  padding: 8px 0;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.18s, color 0.18s, transform 0.15s;
  width: 100%;
}
.cart-add-btn:hover {
  background: linear-gradient(90deg, #ff7aa8, #ff5c8a);
  border-color: transparent;
  color: #fff;
  transform: translateY(-1px);
}
.good-card .good-foot { margin-bottom: 10px; }
.good-emoji {
  font-size: 40px;
  margin-bottom: 12px;
}
.good-name {
  font-size: 14px;
  color: #5d3a47;
  font-weight: 600;
  margin-bottom: 6px;
}
.good-desc {
  font-size: 12px;
  color: #b08898;
  line-height: 1.5;
  margin-bottom: 10px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.good-foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.good-price {
  font-size: 15px;
  font-weight: 700;
  color: #ff5c8a;
}
.good-tag {
  display: inline-block;
  font-size: 12px;
  color: #ff5c8a;
  background: #fff0f6;
  border-radius: 999px;
  padding: 3px 12px;
}.empty {
  text-align: center;
  padding: 60px 0;
  color: #c48ba2;
}
.empty-emoji {
  font-size: 46px;
  margin-bottom: 12px;
}

@media (max-width: 640px) {
  .nav-menu { display: none; }
  .hero-title { font-size: 21px; }
  .search-btn { padding: 11px 18px; letter-spacing: 1px; }
}
</style>
