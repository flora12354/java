<template>
  <div class="card">
    <HelloKitty />

    <h1 class="title">Hello Kitty</h1>
    <p class="subtitle">欢迎回来，登录开启可爱的一天</p>

    <form @submit.prevent="handleSubmit">
      <div class="field">
        <label for="username">用户名</label>
        <input
          type="text"
          id="username"
          v-model.trim="form.username"
          placeholder="请输入用户名"
          autocomplete="username"
        >
      </div>
      <div class="field">
        <label for="password">密码</label>
        <input
          type="password"
          id="password"
          v-model="form.password"
          placeholder="请输入密码"
          autocomplete="current-password"
        >
      </div>
      <div class="row">
        <label class="remember">
          <input type="checkbox" v-model="form.remember"> 记住我
        </label>
        <a href="#" @click.prevent>忘记密码？</a>
      </div>
      <button type="submit" class="btn" :disabled="loading">{{ loading ? '登录中...' : '登 录' }}</button>
    </form>

    <p class="signup">还没有账号？<router-link to="/register">立即注册</router-link></p>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import HelloKitty from './HelloKitty.vue'
import { loginApi } from '../api/auth'

const emit = defineEmits(['notify'])
const router = useRouter()

const form = reactive({
  username: '',
  password: '',
  remember: true
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
  loading.value = true
  try {
    const res = await loginApi(form.username, form.password)
    if (res.code === 200) {
      localStorage.setItem('user', JSON.stringify(res.data))
      emit('notify', `欢迎回来，${form.username}！登录成功`)
      setTimeout(() => router.push('/home'), 800)
    } else {
      emit('notify', res.msg || '登录失败')
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
  background: #ffffff;
  border-radius: 28px;
  box-shadow: 0 20px 60px rgba(255, 105, 155, 0.25);
  padding: 90px 36px 36px;
  z-index: 2;
}

.title {
  text-align: center;
  font-size: 24px;
  color: #ff5c8a;
  letter-spacing: 1px;
  margin-bottom: 6px;
}
.subtitle {
  text-align: center;
  font-size: 13px;
  color: #c48ba2;
  margin-bottom: 28px;
}

.field { margin-bottom: 18px; }
.field label {
  display: block;
  font-size: 13px;
  color: #a96f88;
  margin-bottom: 6px;
  font-weight: 600;
}
.field input {
  width: 100%;
  padding: 12px 16px;
  border: 2px solid #ffd9e6;
  border-radius: 14px;
  font-size: 14px;
  color: #5d3a47;
  background: #fff8fb;
  outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.field input:focus {
  border-color: #ff8fb8;
  box-shadow: 0 0 0 4px rgba(255, 143, 184, 0.18);
}

.row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 13px;
  color: #c48ba2;
  margin: 4px 2px 22px;
}
.row a { color: #ff5c8a; text-decoration: none; }
.row a:hover { text-decoration: underline; }
.remember { display: flex; align-items: center; gap: 6px; cursor: pointer; }
.remember input { accent-color: #ff5c8a; }

.btn {
  width: 100%;
  padding: 13px;
  border: none;
  border-radius: 14px;
  background: linear-gradient(90deg, #ff7aa8, #ff5c8a);
  color: #fff;
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 2px;
  cursor: pointer;
  transition: transform 0.15s, box-shadow 0.15s;
}
.btn:hover { transform: translateY(-2px); box-shadow: 0 10px 24px rgba(255, 92, 138, 0.35); }
.btn:active { transform: translateY(0); }

.signup {
  text-align: center;
  font-size: 13px;
  color: #c48ba2;
  margin-top: 20px;
}
.signup a { color: #ff5c8a; text-decoration: none; font-weight: 600; }
</style>
