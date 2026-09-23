<template>
  <div class="home">
    <div class="panel">
      <div class="title">欢迎来到 · 永夜星河</div>
      <p class="desc">你已成功穿越星河之门，这是登录后的示例主页。</p>
      <div class="info">当前旅行者：<b>{{ user }}</b></div>
      <button class="btn" @click="logout">退 出 星 河</button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const user = ref('旅行者')

onMounted(() => {
  const saved = localStorage.getItem('yongye_user')
  if (saved) user.value = saved
})

function logout() {
  localStorage.removeItem('yongye_token')
  localStorage.removeItem('yongye_user')
  router.push('/')
}
</script>

<style scoped>
.home {
  position: relative;
  z-index: 10;
  width: 420px;
  max-width: 92vw;
  padding: 48px 40px;
  text-align: center;
  background: rgba(24, 22, 56, 0.72);
  border: 1px solid rgba(155, 108, 255, 0.35);
  border-radius: 22px;
  backdrop-filter: blur(18px);
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.55),
    inset 0 0 30px rgba(155, 108, 255, 0.12);
}
.title {
  font-size: 30px;
  font-weight: 800;
  letter-spacing: 4px;
  background: linear-gradient(120deg, var(--accent-2), var(--accent), var(--accent-3));
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  text-shadow: 0 0 28px rgba(155, 108, 255, 0.45);
}
.desc {
  margin: 18px 0;
  font-size: 14px;
  line-height: 1.7;
  color: var(--text-dim);
  letter-spacing: 1px;
}
.info {
  margin-bottom: 26px;
  font-size: 14px;
  color: var(--text);
}
.info b {
  color: var(--accent-2);
}
.btn {
  width: 100%;
  padding: 14px;
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 4px;
  color: #fff;
  border: none;
  border-radius: 12px;
  cursor: pointer;
  background: linear-gradient(120deg, var(--accent), var(--accent-3));
  box-shadow: 0 10px 28px rgba(155, 108, 255, 0.45);
  transition: transform 0.15s, box-shadow 0.25s;
}
.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 14px 36px rgba(155, 108, 255, 0.6);
}
.btn:active {
  transform: translateY(0);
}
</style>
