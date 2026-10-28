<template>
  <div class="admin-page">
    <!-- 顶部导航 -->
    <header class="admin-navbar">
      <div class="admin-nav-inner">
        <div class="admin-brand">⚙️ 后台管理系统</div>
        <div class="admin-nav-right">
          <span class="admin-greet">管理员：{{ adminName }}</span>
          <button class="admin-btn-ghost" @click="router.push('/home')">返回首页</button>
          <button class="admin-btn-ghost danger" @click="handleLogout">退出</button>
        </div>
      </div>
    </header>

    <!-- 工具栏 -->
    <section class="toolbar">
      <form class="toolbar-search" @submit.prevent="loadGoods">
        <input v-model.trim="keyword" type="text" placeholder="搜索商品名称 / 分类 / 描述">
        <select v-model="activeCategory">
          <option value="全部">全部分类</option>
          <option v-for="c in categories" :key="c" :value="c">{{ c }}</option>
        </select>
        <button type="submit" class="btn primary">查询</button>
        <button type="button" class="btn ghost" @click="resetFilter">重置</button>
      </form>
      <button class="btn primary add-btn" @click="openAdd">＋ 新增商品</button>
    </section>

    <!-- 商品表格 -->
    <main class="table-wrap">
      <table class="goods-table">
        <thead>
          <tr>
            <th style="width:64px">ID</th>
            <th style="width:70px">图标</th>
            <th>商品名称</th>
            <th style="width:110px">分类</th>
            <th style="width:110px">价格(¥)</th>
            <th>描述</th>
            <th style="width:160px">创建时间</th>
            <th style="width:140px">操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="loading">
            <td colspan="8" class="table-tip">加载中…</td>
          </tr>
          <tr v-else-if="!goodsList.length">
            <td colspan="8" class="table-tip">暂无商品数据</td>
          </tr>
          <tr v-else v-for="g in goodsList" :key="g.id">
            <td>{{ g.id }}</td>
            <td class="emoji-cell">{{ g.emoji }}</td>
            <td class="name-cell">{{ g.name }}</td>
            <td><span class="tag">{{ g.category }}</span></td>
            <td class="price-cell">¥{{ Number(g.price).toFixed(2) }}</td>
            <td class="desc-cell">{{ g.description }}</td>
            <td class="time-cell">{{ formatTime(g.createTime) }}</td>
            <td>
              <button class="btn small" @click="openEdit(g)">编辑</button>
              <button class="btn small danger" @click="handleDelete(g)">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </main>

    <!-- 新增 / 编辑弹窗 -->
    <div class="modal-mask" v-if="dialogVisible" @click.self="closeDialog">
      <div class="modal">
        <h3 class="modal-title">{{ editing ? '编辑商品' : '新增商品' }}</h3>
        <div class="modal-body">
          <div class="m-field">
            <label>图标 emoji</label>
            <input v-model.trim="form.emoji" type="text" placeholder="如 🧸" maxlength="8">
          </div>
          <div class="m-field">
            <label>商品名称 *</label>
            <input v-model.trim="form.name" type="text" placeholder="商品名称">
          </div>
          <div class="m-row">
            <div class="m-field">
              <label>分类 *</label>
              <input v-model.trim="form.category" type="text" placeholder="如 公仔 / 配饰" list="category-list">
              <datalist id="category-list">
                <option v-for="c in categories" :key="c" :value="c" />
              </datalist>
            </div>
            <div class="m-field">
              <label>价格（¥）*</label>
              <input v-model.number="form.price" type="number" min="0" step="0.01" placeholder="0.00">
            </div>
          </div>
          <div class="m-field">
            <label>描述</label>
            <textarea v-model.trim="form.description" rows="3" placeholder="商品描述"></textarea>
          </div>
          <p class="modal-error" v-if="dialogError">{{ dialogError }}</p>
        </div>
        <div class="modal-foot">
          <button class="btn ghost" @click="closeDialog">取消</button>
          <button class="btn primary" :disabled="saving" @click="handleSave">
            {{ saving ? '保存中…' : '保 存' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { goodsListApi, goodsAddApi, goodsUpdateApi, goodsDeleteApi } from '../api/admin'

const router = useRouter()

const admin = JSON.parse(localStorage.getItem('admin') || '{}')
const adminName = computed(() => admin.username || 'admin')

const keyword = ref('')
const activeCategory = ref('全部')
const goodsList = ref([])
const loading = ref(false)

const dialogVisible = ref(false)
const editing = ref(false)
const saving = ref(false)
const dialogError = ref('')
const emptyForm = { id: null, emoji: '', name: '', category: '', price: null, description: '' }
const form = ref({ ...emptyForm })

const categories = computed(() =>
  [...new Set(goodsList.value.map(i => i.category).filter(Boolean))].sort()
)

function formatTime(t) {
  if (!t) return '-'
  return String(t).replace('T', ' ').slice(0, 19)
}

async function loadGoods() {
  loading.value = true
  try {
    const res = await goodsListApi(keyword.value, activeCategory.value)
    if (res && res.code === 200) {
      goodsList.value = res.data || []
    } else {
      goodsList.value = []
    }
  } catch (e) {
    goodsList.value = []
  } finally {
    loading.value = false
  }
}

function resetFilter() {
  keyword.value = ''
  activeCategory.value = '全部'
  loadGoods()
}

function openAdd() {
  editing.value = false
  form.value = { ...emptyForm }
  dialogError.value = ''
  dialogVisible.value = true
}

function openEdit(g) {
  editing.value = true
  form.value = {
    id: g.id,
    emoji: g.emoji || '',
    name: g.name || '',
    category: g.category || '',
    price: Number(g.price),
    description: g.description || ''
  }
  dialogError.value = ''
  dialogVisible.value = true
}

function closeDialog() {
  dialogVisible.value = false
}

async function handleSave() {
  dialogError.value = ''
  const f = form.value
  if (!f.name) { dialogError.value = '请输入商品名称'; return }
  if (!f.category) { dialogError.value = '请输入商品分类'; return }
  if (f.price == null || isNaN(f.price) || f.price < 0) { dialogError.value = '请输入正确的价格'; return }
  saving.value = true
  try {
    const res = editing.value ? await goodsUpdateApi(f) : await goodsAddApi(f)
    if (res && res.code === 200) {
      dialogVisible.value = false
      await loadGoods()
    } else {
      dialogError.value = (res && res.msg) || '保存失败'
    }
  } catch (e) {
    dialogError.value = e.message || '网络请求失败'
  } finally {
    saving.value = false
  }
}

async function handleDelete(g) {
  if (!window.confirm(`确定删除商品「${g.name}」吗？删除后不可恢复。`)) return
  try {
    const res = await goodsDeleteApi(g.id)
    if (res && res.code === 200) {
      await loadGoods()
    }
  } catch (e) {
    window.alert(e.message || '删除失败')
  }
}

function handleLogout() {
  localStorage.removeItem('admin')
  router.push('/admin/login')
}

onMounted(loadGoods)
</script>

<style scoped>
.admin-page {
  min-height: 100vh;
  background: #f2f5fa;
  display: flex;
  flex-direction: column;
}
/* ===== 顶部导航 ===== */
.admin-navbar {
  background: #2c3757;
  padding: 0 24px;
  flex: none;
}
.admin-nav-inner {
  max-width: 1200px;
  margin: 0 auto;
  height: 58px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.admin-brand {
  color: #fff;
  font-size: 17px;
  font-weight: 700;
}
.admin-nav-right {
  display: flex;
  align-items: center;
  gap: 12px;
}
.admin-greet {
  color: #b7c2e0;
  font-size: 13px;
}
.admin-btn-ghost {
  border: 1px solid #4a587e;
  background: transparent;
  color: #d5ddf2;
  font-size: 13px;
  padding: 6px 14px;
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.18s;
}
.admin-btn-ghost:hover { background: rgba(255, 255, 255, 0.1); }
.admin-btn-ghost.danger:hover { background: rgba(224, 82, 96, 0.25); }

/* ===== 工具栏 ===== */
.toolbar {
  max-width: 1200px;
  width: 100%;
  margin: 20px auto 0;
  padding: 0 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 14px;
  flex-wrap: wrap;
  box-sizing: border-box;
}
.toolbar-search {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}
.toolbar-search input[type="text"],
.toolbar-search select {
  border: 1px solid #d5dbe8;
  border-radius: 10px;
  padding: 9px 14px;
  font-size: 14px;
  color: #2c3757;
  outline: none;
  background: #fff;
  min-width: 180px;
}
.toolbar-search input:focus { border-color: #5b7bd5; }

.btn {
  border: none;
  border-radius: 10px;
  font-size: 14px;
  font-weight: 600;
  padding: 10px 18px;
  cursor: pointer;
  transition: transform 0.15s, box-shadow 0.15s;
}
.btn.primary {
  background: linear-gradient(90deg, #5b7bd5, #3b5cc4);
  color: #fff;
}
.btn.primary:hover { transform: translateY(-1px); box-shadow: 0 6px 16px rgba(59, 92, 196, 0.3); }
.btn.ghost {
  background: #fff;
  border: 1px solid #d5dbe8;
  color: #4a5470;
}
.btn.ghost:hover { background: #f2f5fa; }
.btn.danger {
  background: #fff;
  border: 1px solid #f0b9bf;
  color: #e05260;
}
.btn.danger:hover { background: #fdf0f1; }
.btn.small { padding: 5px 12px; font-size: 13px; border-radius: 8px; margin-right: 6px; }
.btn.small.danger { margin-right: 0; }
.add-btn { flex: none; }

/* ===== 表格 ===== */
.table-wrap {
  max-width: 1200px;
  width: 100%;
  margin: 16px auto 30px;
  padding: 0 20px;
  box-sizing: border-box;
}
.goods-table {
  width: 100%;
  border-collapse: collapse;
  background: #fff;
  border-radius: 14px;
  overflow: hidden;
  box-shadow: 0 4px 18px rgba(44, 55, 87, 0.08);
}
.goods-table th {
  background: #eef2fa;
  color: #4a5470;
  font-size: 13px;
  text-align: left;
  padding: 12px 14px;
  white-space: nowrap;
}
.goods-table td {
  padding: 12px 14px;
  font-size: 14px;
  color: #2c3757;
  border-top: 1px solid #eef1f7;
  vertical-align: top;
}
.emoji-cell { font-size: 22px; }
.name-cell { font-weight: 600; }
.desc-cell { color: #6b7590; font-size: 13px; line-height: 1.5; }
.time-cell { color: #8a93a8; font-size: 12px; white-space: nowrap; }
.price-cell { font-weight: 700; color: #e05260; white-space: nowrap; }
.tag {
  display: inline-block;
  background: #eef2fa;
  color: #3b5cc4;
  font-size: 12px;
  padding: 3px 12px;
  border-radius: 999px;
  white-space: nowrap;
}
.table-tip {
  text-align: center;
  color: #8a93a8;
  padding: 40px 0 !important;
}

/* ===== 弹窗 ===== */
.modal-mask {
  position: fixed;
  inset: 0;
  background: rgba(15, 22, 40, 0.45);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
  padding: 20px;
}
.modal {
  width: 480px;
  max-width: 100%;
  background: #fff;
  border-radius: 16px;
  padding: 26px 26px 20px;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.25);
}
.modal-title {
  margin: 0 0 18px;
  font-size: 18px;
  color: #2c3757;
}
.modal-body { max-height: 55vh; overflow-y: auto; }
.m-field { margin-bottom: 14px; }
.m-field label {
  display: block;
  font-size: 13px;
  font-weight: 600;
  color: #4a5470;
  margin-bottom: 6px;
}
.m-field input,
.m-field textarea {
  width: 100%;
  box-sizing: border-box;
  border: 1px solid #d5dbe8;
  border-radius: 10px;
  padding: 9px 12px;
  font-size: 14px;
  color: #2c3757;
  outline: none;
  resize: vertical;
}
.m-field input:focus,
.m-field textarea:focus { border-color: #5b7bd5; }
.m-row { display: flex; gap: 12px; }
.m-row .m-field { flex: 1; }
.modal-error { font-size: 13px; color: #e05260; margin: 0 0 10px; }
.modal-foot {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 10px;
}
</style>
