<template>
  <div class="profile-page">
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
            <button class="nav-item" @click="router.push('/favorites')">💗 我的收藏</button>
            <button class="nav-item" @click="router.push('/orders')">🧾 我的订单</button>
            <button class="nav-item" @click="router.push('/cart')" data-cart-fly-target>🛒 购物车</button>
            <button class="nav-item active" @click="router.push('/profile')">个人中心</button>
          </nav>
        </div>
        <div class="nav-right">
          <span class="greet">Hi，{{ username }} <span class="cat">🐱</span></span>
          <button class="logout-btn" @click="handleLogout">退出</button>
        </div>
      </div>
    </header>

    <main class="content">
      <div class="content-inner">
        <!-- 用户信息卡 -->
        <section class="card profile-card">
          <div class="avatar-lg">
            <img v-if="user.avatar" :src="user.avatar" alt="头像">
            <template v-else>{{ avatarText }}</template>
          </div>
          <div class="profile-meta">
            <h2>{{ username }}</h2>
            <p v-if="user.nickname && user.nickname !== user.username">昵称：{{ user.nickname }}</p>
            <p>用户 ID：{{ user.id || '-' }}</p>
          </div>
        </section>

        <!-- 收货地址 -->
        <section class="card">
          <div class="sec-head">
            <h2>📍 收货地址</h2>
            <button class="add-btn" @click="openAdd">＋ 新增地址</button>
          </div>

          <div class="addr-grid" v-if="addresses.length">
            <div
              class="addr-card"
              v-for="a in addresses"
              :key="a.id"
              :class="{ on: a.isDefault }"
            >
              <div class="addr-line">
                <b>{{ a.receiver }}</b>
                <span>{{ a.phone }}</span>
                <span class="default-tag" v-if="a.isDefault">默认</span>
              </div>
              <div class="addr-detail">{{ addrFull(a) }}</div>
              <div class="addr-actions">
                <button class="mini-btn" v-if="!a.isDefault" @click="makeDefault(a)">设为默认</button>
                <button class="mini-btn" @click="openEdit(a)">编辑</button>
                <button class="mini-btn danger" @click="removeAddr(a)">删除</button>
              </div>
            </div>
          </div>
          <p class="addr-empty" v-else>还没有收货地址，点「新增地址」添加一个吧～</p>
        </section>
      </div>
    </main>

    <!-- 地址编辑弹层 -->
    <div class="mask" v-if="formVisible" @click.self="formVisible = false">
      <div class="form-box">
        <h3 class="form-title">{{ editingId ? '编辑地址' : '新增地址' }}</h3>
        <div class="form-body">
          <label>收货人<input v-model.trim="form.receiver" placeholder="收货人姓名"></label>
          <label>联系电话<input v-model.trim="form.phone" placeholder="手机号"></label>
          <label>省 / 市 / 区
            <div class="form-row">
              <input v-model.trim="form.province" placeholder="省">
              <input v-model.trim="form.city" placeholder="市">
              <input v-model.trim="form.district" placeholder="区">
            </div>
          </label>
          <label>详细地址<input v-model.trim="form.detail" placeholder="街道、门牌号等"></label>
          <label class="check-line"><input type="checkbox" v-model="form.isDefault"> 设为默认地址</label>
          <p class="form-error" v-if="formError">{{ formError }}</p>
        </div>
        <div class="form-foot">
          <button class="ghost-btn" @click="formVisible = false">取消</button>
          <button class="primary-btn" :disabled="saving" @click="saveAddr">{{ saving ? '保存中…' : '保存' }}</button>
        </div>
      </div>
    </div>

    <ToastMessage :message="toast" :visible="!!toast" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import {
  listAddresses, addAddress, updateAddress, deleteAddress, setDefaultAddress
} from '../api/user'
import ToastMessage from '../components/ToastMessage.vue'

const router = useRouter()
const user = JSON.parse(localStorage.getItem('user') || '{}')
const username = computed(() => user.nickname || user.username || '可爱用户')
const avatarText = computed(() => (username.value || 'K').slice(0, 1).toUpperCase())

const addresses = ref([])
const toast = ref('')
let toastTimer = null
function showToast(msg) {
  toast.value = msg
  clearTimeout(toastTimer)
  toastTimer = setTimeout(() => (toast.value = ''), 2000)
}

function addrFull(a) {
  return [a.province, a.city, a.district, a.detail].filter(Boolean).join(' ')
}

async function loadAddresses() {
  try {
    const res = await listAddresses()
    addresses.value = res && Array.isArray(res.data) ? res.data : []
  } catch (e) {
    addresses.value = []
  }
}

// ===== 地址表单 =====
const formVisible = ref(false)
const editingId = ref(null)
const saving = ref(false)
const formError = ref('')
const emptyForm = () => ({ receiver: '', phone: '', province: '', city: '', district: '', detail: '', isDefault: false })
const form = ref(emptyForm())

function openAdd() {
  editingId.value = null
  form.value = emptyForm()
  formError.value = ''
  formVisible.value = true
}
function openEdit(a) {
  editingId.value = a.id
  form.value = { ...a }
  formError.value = ''
  formVisible.value = true
}
async function saveAddr() {
  formError.value = ''
  if (!form.value.receiver || !form.value.phone || !form.value.detail) {
    formError.value = '请填写收货人、联系电话和详细地址'
    return
  }
  saving.value = true
  try {
    if (editingId.value) {
      await updateAddress({ ...form.value, id: editingId.value })
      showToast('地址已更新 💞')
    } else {
      await addAddress(form.value)
      showToast('地址已添加 💞')
    }
    formVisible.value = false
    await loadAddresses()
  } catch (e) {
    formError.value = e.message || '保存失败'
  } finally {
    saving.value = false
  }
}
async function makeDefault(a) {
  await setDefaultAddress(a.id)
  await loadAddresses()
  showToast('已设为默认地址')
}
async function removeAddr(a) {
  if (!window.confirm(`确定删除「${a.receiver}」这个地址吗？`)) return
  await deleteAddress(a.id)
  await loadAddresses()
  showToast('地址已删除')
}

function handleLogout() {
  localStorage.removeItem('user')
  router.push('/login')
}

onMounted(loadAddresses)
</script>

<style scoped>
.profile-page { position: relative; z-index: 2; width: 100%; min-height: 100vh; display: flex; flex-direction: column; }
.navbar { flex: none; padding: 14px 20px; }
.nav-inner {
  max-width: 1080px; margin: 0 auto;
  display: flex; align-items: center; justify-content: space-between; gap: 16px;
  background: var(--nav-glass); backdrop-filter: blur(8px);
  border: 2px solid var(--border); border-radius: 22px;
  box-shadow: 0 12px 30px var(--shadow-2); padding: 10px 20px;
}
.nav-left, .nav-menu { display: flex; align-items: center; gap: 8px; }
.brand { display: flex; align-items: center; gap: 10px; cursor: pointer; margin-right: 12px; }
.brand-badge {
  position: relative; width: 34px; height: 34px; border-radius: 50%; flex: none;
  background: linear-gradient(135deg, var(--brand-2), var(--brand)); box-shadow: 0 4px 12px var(--glow-2);
}
.brand-badge::before, .brand-badge::after {
  content: ''; position: absolute; top: 8px; width: 14px; height: 11px; background: #fff;
  border-radius: 50% 50% 50% 50% / 60% 60% 40% 40%;
}
.brand-badge::before { left: 4px; transform: rotate(-25deg); }
.brand-badge::after { right: 4px; transform: rotate(25deg); }
.brand-badge i {
  position: absolute; left: 50%; top: 50%; width: 9px; height: 9px; background: #fff;
  border-radius: 50%; transform: translate(-50%, -50%);
}
.brand-name { font-size: 18px; font-weight: 700; color: var(--brand); }
.nav-item {
  border: none; background: transparent; color: var(--text-2);
  font-size: 14px; font-weight: 600; padding: 8px 12px; border-radius: 12px;
  cursor: pointer; transition: background 0.18s, color 0.18s;
}
.nav-item:hover { background: var(--surface-tint); color: var(--brand); }
.nav-item.active { background: linear-gradient(90deg, var(--brand-2), var(--brand)); color: var(--on-brand); box-shadow: 0 6px 16px var(--glow-1); }
.nav-right { display: flex; align-items: center; gap: 14px; }
.greet { font-size: 14px; color: var(--text); font-weight: 600; }
.logout-btn {
  border: 2px solid var(--border); background: var(--surface-soft); color: var(--brand);
  font-size: 13px; font-weight: 600; padding: 7px 16px; border-radius: 12px; cursor: pointer;
}
.logout-btn:hover { background: var(--tint-2); }

.content { flex: 1 1 auto; padding: 16px 20px 40px; }
.content-inner { max-width: 860px; margin: 0 auto; display: flex; flex-direction: column; gap: 18px; }
.card {
  background: var(--card); border: 2px solid var(--border); border-radius: 20px;
  padding: 22px 24px; box-shadow: 0 10px 26px var(--shadow-1);
}

.profile-card { display: flex; align-items: center; gap: 20px; }
.avatar-lg {
  width: 72px; height: 72px; border-radius: 50%; flex: none; overflow: hidden;
  display: flex; align-items: center; justify-content: center;
  background: linear-gradient(135deg, var(--brand-2), var(--brand));
  color: var(--on-brand); font-size: 30px; font-weight: 700;
  box-shadow: 0 8px 18px var(--glow-2);
}
.avatar-lg img { width: 100%; height: 100%; object-fit: cover; }
.profile-meta h2 { font-size: 20px; color: var(--text); margin-bottom: 6px; }
.profile-meta p { font-size: 13px; color: var(--text-3); }

.sec-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px; }
.sec-head h2 { font-size: 17px; color: var(--text); }
.add-btn {
  border: none; border-radius: 999px; padding: 8px 16px; cursor: pointer;
  background: linear-gradient(90deg, var(--brand-2), var(--brand)); color: var(--on-brand);
  font-size: 13px; font-weight: 700;
}
.add-btn:hover { box-shadow: 0 6px 16px var(--glow-2); }

.addr-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 14px; }
.addr-card {
  border: 2px solid var(--border); border-radius: 14px; padding: 14px 16px;
  background: var(--surface-soft); transition: border-color 0.18s, background 0.18s;
}
.addr-card.on { border-color: var(--brand-3); background: var(--surface-tint); }
.addr-line { display: flex; align-items: center; gap: 8px; font-size: 14px; color: var(--text); }
.addr-line span { font-size: 13px; color: var(--text-2); }
.default-tag {
  font-size: 11px; color: var(--on-brand); background: var(--brand);
  border-radius: 999px; padding: 1px 8px;
}
.addr-detail { font-size: 12px; color: var(--text-3); margin: 8px 0 12px; line-height: 1.5; }
.addr-actions { display: flex; gap: 8px; flex-wrap: wrap; }
.mini-btn {
  border: 1px solid var(--border); background: var(--card); color: var(--brand);
  font-size: 12px; padding: 4px 10px; border-radius: 8px; cursor: pointer;
}
.mini-btn:hover { background: var(--tint-2); }
.mini-btn.danger { color: var(--danger-strong); }
.addr-empty { font-size: 13px; color: var(--text-3); padding: 12px 0; }

.mask {
  position: fixed; inset: 0; background: var(--overlay); backdrop-filter: blur(4px);
  display: flex; align-items: center; justify-content: center; z-index: 100;
}
.form-box {
  width: 480px; max-width: calc(100vw - 40px); background: var(--card);
  border-radius: 20px; padding: 24px 26px 20px; box-shadow: 0 20px 50px var(--shadow-neutral-strong);
  max-height: 88vh; display: flex; flex-direction: column;
}
.form-title { margin: 0 0 16px; font-size: 18px; color: var(--text); }
.form-body { overflow-y: auto; display: flex; flex-direction: column; gap: 12px; }
.form-body label { display: flex; flex-direction: column; gap: 6px; font-size: 13px; color: var(--text-2); font-weight: 600; }
.form-body input[type='text'], .form-body input:not([type]) {
  border: 2px solid var(--border); border-radius: 10px; padding: 9px 12px;
  font-size: 13px; color: var(--text); background: transparent; outline: none; width: 100%;
}
.form-body input:focus { border-color: var(--brand-3); }
.form-row { display: flex; gap: 8px; }
.check-line { flex-direction: row !important; align-items: center; gap: 8px !important; }
.check-line input { accent-color: var(--brand); width: auto; }
.form-error { font-size: 12px; color: var(--danger-strong); }
.form-foot { display: flex; justify-content: flex-end; gap: 12px; padding-top: 16px; }
.ghost-btn {
  border: 2px solid var(--border); background: var(--surface-soft); color: var(--text-2);
  font-size: 14px; font-weight: 600; padding: 10px 20px; border-radius: 12px; cursor: pointer;
}
.primary-btn {
  border: none; background: linear-gradient(90deg, var(--brand-2), var(--brand)); color: var(--on-brand);
  font-size: 14px; font-weight: 700; padding: 10px 24px; border-radius: 12px; cursor: pointer;
}
.primary-btn:disabled { opacity: 0.6; cursor: not-allowed; }

@media (max-width: 720px) { .nav-menu { display: none; } }
</style>
