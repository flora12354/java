<template>
  <div class="admin-login-page">
    <div class="login-box">
      <div class="box-badge">⚙️</div>
      <h1 class="box-title">后台管理系统</h1>
      <p class="box-sub">请使用管理员账号登录</p>

      <form @submit.prevent="handleLogin">
        <div class="field">
          <label for="admin-username">账号</label>
          <input
            id="admin-username"
            v-model.trim="username"
            type="text"
            placeholder="管理员账号"
            autocomplete="username"
          >
        </div>
        <div class="field">
          <label for="admin-password">密码</label>
          <input
            id="admin-password"
            v-model.trim="password"
            type="password"
            placeholder="管理员密码"
            autocomplete="current-password"
          >
        </div>

        <p class="error" v-if="errorMsg">{{ errorMsg }}</p>

        <button type="submit" class="login-btn" :disabled="loading">
          {{ loading ? '登录中…' : '登 录' }}
        </button>
      </form>

      <button class="back-link" @click="router.push('/home')">← 返回首页</button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { adminLoginApi } from '../api/admin'

const router = useRouter()

const username = ref('')
const password = ref('')
const loading = ref(false)
const errorMsg = ref('')

async function handleLogin() {
  errorMsg.value = ''
  if (!username.value || !password.value) {
    errorMsg.value = '请输入账号和密码'
    return
  }
  loading.value = true
  try {
    const res = await adminLoginApi(username.value, password.value)
    if (res && res.code === 200) {
      localStorage.setItem('admin', JSON.stringify(res.data || { username: username.value }))
      router.push('/admin')
    } else {
      errorMsg.value = (res && res.msg) || '登录失败'
    }
  } catch (e) {
    errorMsg.value = e.message || '网络请求失败'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.admin-login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #3b4a6b 0%, #2c3757 100%);
  padding: 20px;
}
.login-box {
  width: 380px;
  max-width: 100%;
  background: #ffffff;
  border-radius: 22px;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
  padding: 40px 36px 30px;
  text-align: center;
}
.box-badge {
  font-size: 42px;
  margin-bottom: 10px;
}
.box-title {
  font-size: 22px;
  color: #2c3757;
  margin-bottom: 6px;
}
.box-sub {
  font-size: 13px;
  color: #8a93a8;
  margin-bottom: 26px;
}
.field {
  text-align: left;
  margin-bottom: 16px;
}
.field label {
  display: block;
  font-size: 13px;
  font-weight: 600;
  color: #4a5470;
  margin-bottom: 6px;
}
.field input {
  width: 100%;
  box-sizing: border-box;
  border: 2px solid #dde3f0;
  border-radius: 12px;
  padding: 11px 14px;
  font-size: 15px;
  color: #2c3757;
  outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.field input:focus {
  border-color: #5b7bd5;
  box-shadow: 0 0 0 4px rgba(91, 123, 213, 0.15);
}
.error {
  font-size: 13px;
  color: #e05260;
  margin: 0 0 12px;
  text-align: left;
}
.login-btn {
  width: 100%;
  border: none;
  border-radius: 12px;
  background: linear-gradient(90deg, #5b7bd5, #3b5cc4);
  color: #fff;
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 4px;
  padding: 13px 0;
  cursor: pointer;
  transition: transform 0.15s, box-shadow 0.15s;
}
.login-btn:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 8px 20px rgba(59, 92, 196, 0.35);
}
.login-btn:disabled {
  opacity: 0.7;
  cursor: default;
}
.back-link {
  margin-top: 18px;
  border: none;
  background: transparent;
  color: #8a93a8;
  font-size: 13px;
  cursor: pointer;
}
.back-link:hover {
  color: #5b7bd5;
}
</style>
