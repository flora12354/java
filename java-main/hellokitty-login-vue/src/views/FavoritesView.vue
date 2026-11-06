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
            <button class="nav-item" @click="router.push('/cart')">
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

        <div class="grid" v-if="store.favorites.length">
          <div class="good-card" v-for="item in store.favorites" :key="item.id">
            <button class="fav-btn on" title="取消收藏" @click="store.toggleFavorite(item)">💖</button>
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
            <button class="cart-add-btn" @click="store.addToCart(item)">＋ 加入购物车</button>
          </div>
        </div>

        <div class="empty" v-else>
          <div class="empty-emoji">💝</div>
          <p>还没有收藏任何好物，去首页逛逛吧~</p>
          <button class="go-btn" @click="router.push('/home')">去首页看看</button>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { store } from '../api/store'

const router = useRouter()
const user = JSON.parse(localStorage.getItem('user') || '{}')
const username = computed(() => user.username || '可爱用户')
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
.content-inner { max-width: 1080px; margin: 0 auto; }
.content-head {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  margin: 14px 4px 18px;
}
.content-head h2 { font-size: 18px; color: #5d3a47; }
.count { font-size: 13px; color: #c48ba2; }

.grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 16px; }
.good-card {
  position: relative;
  background: #ffffff;
  border: 2px solid #ffd9e6;
  border-radius: 20px;
  padding: 22px 16px 14px;
  text-align: center;
  box-shadow: 0 10px 26px rgba(255, 105, 155, 0.14);
  transition: transform 0.18s, box-shadow 0.18s;
  display: flex;
  flex-direction: column;
}
.good-card:hover { transform: translateY(-4px); box-shadow: 0 16px 34px rgba(255, 105, 155, 0.28); }
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
.good-name { font-size: 14px; color: #5d3a47; font-weight: 600; margin-bottom: 6px; }
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
.good-foot { display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; }
.good-price { font-size: 15px; font-weight: 700; color: #ff5c8a; }
.good-tag {
  display: inline-block;
  font-size: 12px;
  color: #ff5c8a;
  background: #fff0f6;
  border-radius: 999px;
  padding: 3px 12px;
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
  width: 100%;
  transition: background 0.18s, color 0.18s, transform 0.15s;
}
.cart-add-btn:hover {
  background: linear-gradient(90deg, #ff7aa8, #ff5c8a);
  border-color: transparent;
  color: #fff;
  transform: translateY(-1px);
}
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
</style>
