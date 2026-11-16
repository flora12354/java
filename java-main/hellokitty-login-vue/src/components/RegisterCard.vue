<template>
  <div class="card">
    <HelloKitty />

    <h1 class="title">加入我们</h1>
    <p class="subtitle">注册一个可爱的账号吧</p>

    <form @submit.prevent="handleSubmit">
      <div class="field">
        <label for="reg-username">用户名</label>
        <input
          type="text"
          id="reg-username"
          v-model.trim="form.username"
          placeholder="请输入用户名"
          autocomplete="username"
        >
      </div>
      <div class="field">
        <label for="reg-password">密码</label>
        <input
          type="password"
          id="reg-password"
          v-model="form.password"
          placeholder="至少 6 位密码"
          autocomplete="new-password"
        >
      </div>
      <div class="field">
        <label for="reg-confirm">确认密码</label>
        <input
          type="password"
          id="reg-confirm"
          v-model="form.confirm"
          placeholder="请再次输入密码"
          autocomplete="new-password"
        >
      </div>
      <button type="submit" class="btn" :disabled="loading">{{ loading ? '注册中...' : '注 册' }}</button>
    </form>

    <p class="signup">已有账号？<router-link to="/login">去登录</router-link></p>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import HelloKitty from './HelloKitty.vue'
import { registerApi } from '../api/auth'

const emit = defineEmits(['notify'])
const router = useRouter()

const form = reactive({
  username: '',
  password: '',
  confirm: ''
})
const loading = ref(false)

async function handleSubmit() {
  if (!form.username) {
    emit('notify', '请先输入用户名哦')
    return
  }
  if (form.password.length < 6) {
    emit('notify', '密码至少需要 6 位')
    return
  }
  if (form.password !== form.confirm) {
    emit('notify', '两次输入的密码不一致')
    return
  }
  loading.value = true
  try {
    const res = await registerApi(form.username, form.password)
    if (res.code === 200) {
      emit('notify', `注册成功，${form.username}！快去登录吧`)
      setTimeout(() => router.push('/login'), 1200)
    } else {
      emit('notify', res.msg || '注册失败')
    }
  } catch (e) {
    emit('notify', '无法连接服务器，请确认后端已启动')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.card {
  position: relative;
  width: 360px;
  background: var(--card);
  border-radius: 28px;
  box-shadow: 0 20px 60px var(--shadow-3);
  padding: 90px 36px 36px;
  z-index: 2;
}

.title {
  text-align: center;
  font-size: 24px;
  color: var(--brand);
  letter-spacing: 1px;
  margin-bottom: 6px;
}
.subtitle {
  text-align: center;
  font-size: 13px;
  color: var(--text-3);
  margin-bottom: 28px;
}

.field { margin-bottom: 18px; }
.field label {
  display: block;
  font-size: 13px;
  color: var(--text-2);
  margin-bottom: 6px;
  font-weight: 600;
}
.field input {
  width: 100%;
  padding: 12px 16px;
  border: 2px solid var(--border);
  border-radius: 14px;
  font-size: 14px;
  color: var(--text);
  background: var(--surface-soft);
  outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.field input:focus {
  border-color: var(--brand-3);
  box-shadow: 0 0 0 4px var(--ring);
}

.btn {
  width: 100%;
  padding: 13px;
  margin-top: 6px;
  border: none;
  border-radius: 14px;
  background: linear-gradient(90deg, var(--brand-2), var(--brand));
  color: var(--on-brand);
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 2px;
  cursor: pointer;
  transition: transform 0.15s, box-shadow 0.15s;
}
.btn:hover { transform: translateY(-2px); box-shadow: 0 10px 24px var(--glow-2); }
.btn:active { transform: translateY(0); }

.signup {
  text-align: center;
  font-size: 13px;
  color: var(--text-3);
  margin-top: 20px;
}
.signup a { color: var(--brand); text-decoration: none; font-weight: 600; }
</style>
