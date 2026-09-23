<template>
  <div class="card">
    <div class="logo">
      <div class="mark">永夜星河</div>
      <div class="sub">E T E R N A L · N I G H T</div>
    </div>
    <div class="divider"></div>

    <form @submit.prevent="handleLogin">
      <div class="field">
        <label for="account">账号</label>
        <input
          id="account"
          v-model="account"
          type="text"
          placeholder="手机号 / 邮箱 / 星河 ID"
          autocomplete="username"
        />
      </div>
      <div class="field">
        <label for="pwd">密码</label>
        <input
          id="pwd"
          v-model="pwd"
          type="password"
          placeholder="请输入密码"
          autocomplete="current-password"
        />
      </div>

      <div class="row">
        <label><input type="checkbox" v-model="remember" /> 记住我</label>
        <a href="#">忘记密码？</a>
      </div>

      <button class="btn" type="submit" :disabled="loading">
        <span v-if="loading" class="spinner"></span>
        {{ loading ? '穿越中…' : '进 入 星 河' }}
      </button>
      <div class="hint" :style="{ color: hintColor }">{{ hint }}</div>
    </form>

    <div class="footer">还没有账号？<span>立即注册</span> · 开启你的穿越之旅</div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const account = ref('')
const pwd = ref('')
const remember = ref(true)
const loading = ref(false)
const hint = ref('')
const hintColor = ref('#ff9d7b')

function validate() {
  if (!account.value.trim()) {
    hint.value = '请输入账号，方可踏星河。'
    hintColor.value = '#ff9d7b'
    return false
  }
  if (pwd.value.length < 6) {
    hint.value = '密码至少需 6 位。'
    hintColor.value = '#ff9d7b'
    return false
  }
  return true
}

// 模拟向后端发起的登录请求
function mockLogin() {
  return new Promise((resolve) => setTimeout(resolve, 1100))
}

async function handleLogin() {
  if (!validate()) return
  loading.value = true
  hint.value = ''
  await mockLogin()
  // 模拟后端返回的令牌与用户信息
  localStorage.setItem('yongye_token', 'mock-' + Date.now())
  localStorage.setItem('yongye_user', account.value.trim())
  loading.value = false
  router.push('/home')
}
</script>

<style scoped>
.card {
  position: relative;
  z-index: 10;
  width: 380px;
  max-width: 92vw;
  padding: 44px 38px 38px;
  background: rgba(24, 22, 56, 0.72);
  border: 1px solid rgba(155, 108, 255, 0.35);
  border-radius: 22px;
  backdrop-filter: blur(18px);
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.55),
    inset 0 0 30px rgba(155, 108, 255, 0.12);
}

.logo {
  text-align: center;
  margin-bottom: 6px;
}
.logo .mark {
  font-size: 42px;
  font-weight: 800;
  letter-spacing: 6px;
  background: linear-gradient(120deg, var(--accent-2), var(--accent), var(--accent-3));
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  text-shadow: 0 0 28px rgba(155, 108, 255, 0.45);
}
.logo .sub {
  margin-top: 8px;
  font-size: 13px;
  letter-spacing: 4px;
  color: var(--text-dim);
}
.divider {
  height: 1px;
  margin: 22px 0 26px;
  background: linear-gradient(90deg, transparent, rgba(155, 108, 255, 0.35), transparent);
}

.field {
  margin-bottom: 18px;
}
.field label {
  display: block;
  font-size: 13px;
  color: var(--text-dim);
  margin-bottom: 8px;
  letter-spacing: 1px;
}
.field input {
  width: 100%;
  padding: 13px 16px;
  font-size: 15px;
  color: var(--text);
  background: rgba(10, 10, 31, 0.6);
  border: 1px solid rgba(155, 108, 255, 0.25);
  border-radius: 12px;
  outline: none;
  transition: border-color 0.25s, box-shadow 0.25s;
}
.field input:focus {
  border-color: var(--accent);
  box-shadow: 0 0 0 3px rgba(155, 108, 255, 0.18);
}
.field input::placeholder {
  color: #6b6c93;
}

.row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 12.5px;
  color: var(--text-dim);
  margin: 4px 0 24px;
}
.row label {
  display: flex;
  align-items: center;
  gap: 7px;
  cursor: pointer;
}
.row input {
  accent-color: var(--accent);
  width: 14px;
  height: 14px;
}
.row a {
  color: var(--accent-2);
  text-decoration: none;
}
.row a:hover {
  text-decoration: underline;
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
.btn:disabled {
  opacity: 0.85;
  cursor: not-allowed;
  transform: none;
}
.spinner {
  width: 15px;
  height: 15px;
  border: 2px solid rgba(255, 255, 255, 0.35);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.footer {
  margin-top: 22px;
  text-align: center;
  font-size: 12px;
  color: var(--text-dim);
  letter-spacing: 1px;
}
.footer span {
  color: var(--accent-2);
}

.hint {
  margin-top: 14px;
  text-align: center;
  font-size: 12px;
  color: #ff9d7b;
  min-height: 16px;
}
</style>
