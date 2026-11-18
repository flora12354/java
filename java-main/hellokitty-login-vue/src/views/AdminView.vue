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

    <!-- 标签页 -->
    <nav class="tab-bar">
      <button
        v-for="t in tabs" :key="t.key"
        class="tab-btn" :class="{ on: activeTab === t.key }"
        @click="switchTab(t.key)"
      >{{ t.label }}</button>
    </nav>

    <div class="admin-scroll">
      <!-- ============ 商品管理 ============ -->
      <template v-if="activeTab === 'goods'">
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
              <tr v-if="goodsLoading">
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
                  <button class="btn small danger" @click="handleGoodsDelete(g)">删除</button>
                </td>
              </tr>
            </tbody>
          </table>
        </main>
      </template>

      <!-- ============ 订单管理 ============ -->
      <template v-if="activeTab === 'orders'">
        <section class="toolbar">
          <form class="toolbar-search" @submit.prevent="loadOrders">
            <input v-model.trim="orderKeyword" type="text" placeholder="搜索订单号 / 用户名 / 收货人">
            <select v-model="orderStatusFilter">
              <option value="全部">全部状态</option>
              <option v-for="(text, key) in ORDER_STATUS_TEXT" :key="key" :value="key">{{ text }}</option>
            </select>
            <button type="submit" class="btn primary">查询</button>
            <button type="button" class="btn ghost" @click="resetOrderFilter">重置</button>
          </form>
        </section>

        <main class="table-wrap">
          <table class="goods-table">
            <thead>
              <tr>
                <th style="width:150px">订单号</th>
                <th style="width:90px">用户</th>
                <th>商品明细</th>
                <th style="width:96px">金额(¥)</th>
                <th>收货信息</th>
                <th style="width:104px">状态</th>
                <th style="width:150px">下单时间</th>
                <th style="width:170px">操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="orderLoading">
                <td colspan="8" class="table-tip">加载中…</td>
              </tr>
              <tr v-else-if="!orderList.length">
                <td colspan="8" class="table-tip">暂无订单数据</td>
              </tr>
              <tr v-else v-for="o in orderList" :key="o.id">
                <td class="mono-cell">{{ o.orderNo }}</td>
                <td>{{ o.username }}</td>
                <td class="desc-cell">
                  <div v-for="it in o.items" :key="it.id" class="order-item-line">
                    {{ it.emoji }} {{ it.goodsName }} × {{ it.qty }}
                  </div>
                  <div class="remark-line" v-if="o.remark">备注：{{ o.remark }}</div>
                </td>
                <td class="price-cell">¥{{ Number(o.totalAmount).toFixed(2) }}</td>
                <td class="desc-cell">
                  {{ o.receiver || '-' }}<br>
                  <span class="muted">{{ o.phone || '' }}</span><br>
                  <span class="muted">{{ o.address || '' }}</span>
                </td>
                <td>
                  <span class="status-badge" :class="'st-' + o.status">{{ ORDER_STATUS_TEXT[o.status] || o.status }}</span>
                </td>
                <td class="time-cell">{{ formatTime(o.createTime) }}</td>
                <td>
                  <button v-if="o.status === 'PAID'" class="btn small" @click="shipOrder(o)">发货</button>
                  <button v-if="o.status === 'SHIPPED'" class="btn small" @click="completeOrder(o)">确认完成</button>
                  <template v-if="o.status === 'REFUND_REQUESTED'">
                    <button class="btn small" @click="handleRefund(o, true)">同意退款</button>
                    <button class="btn small danger" @click="handleRefund(o, false)">驳回</button>
                  </template>
                  <span v-if="!['PAID','SHIPPED','REFUND_REQUESTED'].includes(o.status)" class="muted">—</span>
                </td>
              </tr>
            </tbody>
          </table>
        </main>
      </template>

      <!-- ============ 用户管理 ============ -->
      <template v-if="activeTab === 'users'">
        <section class="toolbar">
          <form class="toolbar-search" @submit.prevent="loadUsers">
            <input v-model.trim="userKeyword" type="text" placeholder="搜索用户名 / 昵称 / 手机号">
            <button type="submit" class="btn primary">查询</button>
            <button type="button" class="btn ghost" @click="userKeyword = ''; loadUsers()">重置</button>
          </form>
        </section>

        <main class="table-wrap">
          <table class="goods-table">
            <thead>
              <tr>
                <th style="width:64px">ID</th>
                <th style="width:60px">头像</th>
                <th style="width:130px">用户名</th>
                <th style="width:130px">昵称</th>
                <th style="width:140px">手机号</th>
                <th style="width:170px">注册时间</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="userLoading">
                <td colspan="6" class="table-tip">加载中…</td>
              </tr>
              <tr v-else-if="!userList.length">
                <td colspan="6" class="table-tip">暂无注册用户</td>
              </tr>
              <tr v-else v-for="u in userList" :key="u.id">
                <td>{{ u.id }}</td>
                <td>
                  <span class="user-avatar">
                    <img v-if="u.avatar && u.avatar.startsWith('data:')" :src="u.avatar" alt="">
                    <template v-else>{{ (u.avatar && u.avatar.startsWith('emoji:')) ? u.avatar.slice(6) : (u.username || 'U').slice(0, 1).toUpperCase() }}</template>
                  </span>
                </td>
                <td class="name-cell">{{ u.username }}</td>
                <td>{{ u.nickname || '-' }}</td>
                <td>{{ u.phone || '-' }}</td>
                <td class="time-cell">{{ formatTime(u.createTime) }}</td>
              </tr>
            </tbody>
          </table>
        </main>
      </template>

      <!-- ============ 评价管理 ============ -->
      <template v-if="activeTab === 'reviews'">
        <section class="toolbar">
          <form class="toolbar-search" @submit.prevent="loadReviews">
            <input v-model.trim="reviewKeyword" type="text" placeholder="搜索用户名 / 评价内容">
            <select v-model="reviewStatusFilter">
              <option value="全部">全部状态</option>
              <option v-for="(text, key) in REVIEW_STATUS_TEXT" :key="key" :value="key">{{ text }}</option>
            </select>
            <button type="submit" class="btn primary">查询</button>
            <button type="button" class="btn ghost" @click="resetReviewFilter">重置</button>
          </form>
        </section>

        <main class="table-wrap">
          <table class="goods-table">
            <thead>
              <tr>
                <th style="width:64px">ID</th>
                <th style="width:170px">商品</th>
                <th style="width:100px">用户</th>
                <th style="width:120px">评分</th>
                <th>评价内容</th>
                <th style="width:96px">状态</th>
                <th style="width:150px">评价时间</th>
                <th style="width:170px">操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="reviewLoading">
                <td colspan="8" class="table-tip">加载中…</td>
              </tr>
              <tr v-else-if="!reviewList.length">
                <td colspan="8" class="table-tip">暂无评价数据</td>
              </tr>
              <tr v-else v-for="r in reviewList" :key="r.id">
                <td>{{ r.id }}</td>
                <td>{{ r.goodsEmoji }} {{ r.goodsName }}</td>
                <td>{{ r.username }}</td>
                <td class="stars-cell">{{ '⭐'.repeat(Number(r.rating) || 0) }}</td>
                <td class="desc-cell">{{ r.content }}</td>
                <td>
                  <span class="status-badge" :class="'rv-' + r.status">{{ REVIEW_STATUS_TEXT[r.status] || r.status }}</span>
                </td>
                <td class="time-cell">{{ formatTime(r.createTime) }}</td>
                <td>
                  <button class="btn small" @click="auditReview(r, 'APPROVED')">通过</button>
                  <button class="btn small ghost" @click="auditReview(r, 'REJECTED')">驳回</button>
                  <button class="btn small danger" @click="handleReviewDelete(r)">删除</button>
                </td>
              </tr>
            </tbody>
          </table>
        </main>
      </template>
    </div>

    <!-- 商品 新增 / 编辑弹窗 -->
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
import {
  goodsListApi, goodsAddApi, goodsUpdateApi, goodsDeleteApi,
  orderListApi, orderShipApi, orderCompleteApi, orderRefundApi,
  userListApi,
  reviewListApi, reviewAuditApi, reviewDeleteApi
} from '../api/admin'

const router = useRouter()

const admin = JSON.parse(localStorage.getItem('admin') || '{}')
const adminName = computed(() => admin.username || 'admin')

// ===== 标签页 =====
const tabs = [
  { key: 'goods', label: '📦 商品管理' },
  { key: 'orders', label: '🧾 订单管理' },
  { key: 'users', label: '👤 用户管理' },
  { key: 'reviews', label: '💬 评价管理' }
]
const activeTab = ref('goods')

// 各标签页首次切入时加载一次
const loadedTabs = new Set()
function switchTab(key) {
  activeTab.value = key
  if (key === 'orders' && !loadedTabs.has('orders')) { loadedTabs.add('orders'); loadOrders() }
  if (key === 'users' && !loadedTabs.has('users')) { loadedTabs.add('users'); loadUsers() }
  if (key === 'reviews' && !loadedTabs.has('reviews')) { loadedTabs.add('reviews'); loadReviews() }
}

const ORDER_STATUS_TEXT = {
  PENDING_PAYMENT: '待付款',
  PAID: '待发货',
  SHIPPED: '已发货',
  COMPLETED: '已完成',
  REFUND_REQUESTED: '退款申请中',
  REFUNDED: '已退款'
}
const REVIEW_STATUS_TEXT = {
  PENDING: '待审核',
  APPROVED: '已通过',
  REJECTED: '已驳回'
}

function formatTime(t) {
  if (!t) return '-'
  return String(t).replace('T', ' ').slice(0, 19)
}

// ============ 商品管理 ============
const keyword = ref('')
const activeCategory = ref('全部')
const goodsList = ref([])
const goodsLoading = ref(false)

const dialogVisible = ref(false)
const editing = ref(false)
const saving = ref(false)
const dialogError = ref('')
const emptyForm = { id: null, emoji: '', name: '', category: '', price: null, description: '' }
const form = ref({ ...emptyForm })

const categories = computed(() =>
  [...new Set(goodsList.value.map(i => i.category).filter(Boolean))].sort()
)

async function loadGoods() {
  goodsLoading.value = true
  try {
    const res = await goodsListApi(keyword.value, activeCategory.value)
    goodsList.value = res && res.code === 200 ? (res.data || []) : []
  } catch (e) {
    goodsList.value = []
  } finally {
    goodsLoading.value = false
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

async function handleGoodsDelete(g) {
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

// ============ 订单管理 ============
const orderKeyword = ref('')
const orderStatusFilter = ref('全部')
const orderList = ref([])
const orderLoading = ref(false)

async function loadOrders() {
  orderLoading.value = true
  try {
    const res = await orderListApi(orderKeyword.value, orderStatusFilter.value)
    orderList.value = res && res.code === 200 ? (res.data || []) : []
  } catch (e) {
    orderList.value = []
  } finally {
    orderLoading.value = false
  }
}

function resetOrderFilter() {
  orderKeyword.value = ''
  orderStatusFilter.value = '全部'
  loadOrders()
}

async function shipOrder(o) {
  try {
    const res = await orderShipApi(o.id)
    if (res && res.code === 200) {
      o.status = 'SHIPPED'
    } else {
      window.alert((res && res.msg) || '发货失败')
    }
  } catch (e) {
    window.alert(e.message || '发货失败')
  }
}

async function completeOrder(o) {
  try {
    const res = await orderCompleteApi(o.id)
    if (res && res.code === 200) {
      o.status = 'COMPLETED'
    } else {
      window.alert((res && res.msg) || '操作失败')
    }
  } catch (e) {
    window.alert(e.message || '操作失败')
  }
}

async function handleRefund(o, approve) {
  const ok = window.confirm(approve
    ? `同意订单 ${o.orderNo} 的退款申请？退款金额 ¥${Number(o.totalAmount).toFixed(2)}。`
    : `驳回订单 ${o.orderNo} 的退款申请？`)
  if (!ok) return
  try {
    const res = await orderRefundApi(o.id, approve)
    if (res && res.code === 200) {
      o.status = approve ? 'REFUNDED' : 'PAID'
    } else {
      window.alert((res && res.msg) || '处理失败')
    }
  } catch (e) {
    window.alert(e.message || '处理失败')
  }
}

// ============ 用户管理 ============
const userKeyword = ref('')
const userList = ref([])
const userLoading = ref(false)

async function loadUsers() {
  userLoading.value = true
  try {
    const res = await userListApi(userKeyword.value)
    userList.value = res && res.code === 200 ? (res.data || []) : []
  } catch (e) {
    userList.value = []
  } finally {
    userLoading.value = false
  }
}

// ============ 评价管理 ============
const reviewKeyword = ref('')
const reviewStatusFilter = ref('全部')
const reviewList = ref([])
const reviewLoading = ref(false)

async function loadReviews() {
  reviewLoading.value = true
  try {
    const res = await reviewListApi(reviewKeyword.value, reviewStatusFilter.value)
    reviewList.value = res && res.code === 200 ? (res.data || []) : []
  } catch (e) {
    reviewList.value = []
  } finally {
    reviewLoading.value = false
  }
}

function resetReviewFilter() {
  reviewKeyword.value = ''
  reviewStatusFilter.value = '全部'
  loadReviews()
}

async function auditReview(r, status) {
  try {
    const res = await reviewAuditApi(r.id, status)
    if (res && res.code === 200) {
      r.status = status
    } else {
      window.alert((res && res.msg) || '审核失败')
    }
  } catch (e) {
    window.alert(e.message || '审核失败')
  }
}

async function handleReviewDelete(r) {
  if (!window.confirm('确定删除这条评价吗？删除后不可恢复。')) return
  try {
    const res = await reviewDeleteApi(r.id)
    if (res && res.code === 200) {
      reviewList.value = reviewList.value.filter(i => i.id !== r.id)
    } else {
      window.alert((res && res.msg) || '删除失败')
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
  height: 100vh;
  background: var(--admin-bg);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}
/* ===== 可滚动内容区 ===== */
.admin-scroll {
  flex: 1 1 auto;
  min-height: 0;
  overflow-y: auto;
}
/* ===== 顶部导航 ===== */
.admin-navbar {
  background: var(--admin-nav);
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
  color: var(--admin-nav-text);
  font-size: 17px;
  font-weight: 700;
}
.admin-nav-right {
  display: flex;
  align-items: center;
  gap: 12px;
}
.admin-greet {
  color: var(--admin-nav-muted);
  font-size: 13px;
}
.admin-btn-ghost {
  border: 1px solid var(--admin-nav-border);
  background: transparent;
  color: var(--admin-nav-muted);
  font-size: 13px;
  padding: 6px 14px;
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.18s;
}
.admin-btn-ghost:hover { background: var(--admin-hover); }
.admin-btn-ghost.danger:hover { background: var(--admin-danger-hover); }

/* ===== 标签页 ===== */
.tab-bar {
  max-width: 1200px;
  width: 100%;
  margin: 14px auto 0;
  padding: 0 20px;
  display: flex;
  gap: 10px;
  box-sizing: border-box;
}
.tab-btn {
  border: 1px solid var(--admin-border);
  background: var(--admin-card);
  color: var(--admin-text-2);
  font-size: 14px;
  font-weight: 600;
  padding: 9px 20px;
  border-radius: 10px;
  cursor: pointer;
  transition: background 0.18s, color 0.18s, transform 0.15s;
}
.tab-btn:hover { transform: translateY(-1px); }
.tab-btn.on {
  background: linear-gradient(90deg, var(--admin-accent), var(--admin-accent-2));
  border-color: transparent;
  color: var(--admin-on-accent);
  box-shadow: 0 6px 16px var(--admin-glow);
}

/* ===== 工具栏 ===== */
.toolbar {
  max-width: 1200px;
  width: 100%;
  margin: 16px auto 0;
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
  border: 1px solid var(--admin-border);
  border-radius: 10px;
  padding: 9px 14px;
  font-size: 14px;
  color: var(--admin-text);
  outline: none;
  background: var(--admin-card);
  min-width: 180px;
}
.toolbar-search input:focus { border-color: var(--admin-accent); }

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
  background: linear-gradient(90deg, var(--admin-accent), var(--admin-accent-2));
  color: var(--admin-on-accent);
}
.btn.primary:hover { transform: translateY(-1px); box-shadow: 0 6px 16px var(--admin-glow); }
.btn.ghost {
  background: var(--admin-card);
  border: 1px solid var(--admin-border);
  color: var(--admin-text-2);
}
.btn.ghost:hover { background: var(--admin-bg); }
.btn.danger {
  background: var(--admin-card);
  border: 1px solid var(--admin-danger-border);
  color: var(--admin-danger);
}
.btn.danger:hover { background: var(--admin-danger-soft); }
.btn.small { padding: 5px 12px; font-size: 13px; border-radius: 8px; margin-right: 6px; }
.btn.small.danger { margin-right: 0; }
.btn.small.ghost { margin-right: 6px; }
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
  background: var(--admin-card);
  border-radius: 14px;
  overflow: hidden;
  box-shadow: 0 4px 18px var(--admin-shadow);
}
.goods-table th {
  background: var(--admin-head);
  color: var(--admin-text-2);
  font-size: 13px;
  text-align: left;
  padding: 12px 14px;
  white-space: nowrap;
}
.goods-table td {
  padding: 12px 14px;
  font-size: 14px;
  color: var(--admin-text);
  border-top: 1px solid var(--admin-row-border);
  vertical-align: top;
}
.emoji-cell { font-size: 22px; }
.name-cell { font-weight: 600; }
.desc-cell { color: var(--admin-text-4); font-size: 13px; line-height: 1.5; }
.time-cell { color: var(--admin-text-3); font-size: 12px; white-space: nowrap; }
.price-cell { font-weight: 700; color: var(--admin-danger); white-space: nowrap; }
.mono-cell { font-size: 12px; font-family: Consolas, monospace; color: var(--admin-text-3); }
.muted { color: var(--admin-text-3); font-size: 12px; }
.order-item-line { margin-bottom: 2px; }
.remark-line { margin-top: 6px; color: var(--admin-text-3); font-size: 12px; }
.stars-cell { white-space: nowrap; letter-spacing: 2px; }
.user-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  overflow: hidden;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: var(--admin-head);
  color: var(--admin-accent);
  font-size: 13px;
  font-weight: 700;
}
.user-avatar img { width: 100%; height: 100%; object-fit: cover; }
.tag {
  display: inline-block;
  background: var(--admin-head);
  color: var(--admin-accent-2);
  font-size: 12px;
  padding: 3px 12px;
  border-radius: 999px;
  white-space: nowrap;
}
.table-tip {
  text-align: center;
  color: var(--admin-text-3);
  padding: 40px 0 !important;
}

/* ===== 状态徽章 ===== */
.status-badge {
  display: inline-block;
  font-size: 12px;
  font-weight: 600;
  padding: 3px 12px;
  border-radius: 999px;
  white-space: nowrap;
  background: var(--admin-head);
  color: var(--admin-text-2);
}
.st-PAID { background: rgba(255, 170, 60, 0.15); color: #e8963c; }
.st-SHIPPED { background: rgba(90, 150, 255, 0.15); color: #6a9ee8; }
.st-COMPLETED { background: rgba(110, 200, 120, 0.15); color: #5cb868; }
.st-REFUND_REQUESTED { background: rgba(255, 107, 157, 0.16); color: var(--admin-danger); }
.st-REFUNDED { background: rgba(150, 150, 160, 0.18); color: var(--admin-text-3); }
.rv-PENDING { background: rgba(255, 170, 60, 0.15); color: #e8963c; }
.rv-APPROVED { background: rgba(110, 200, 120, 0.15); color: #5cb868; }
.rv-REJECTED { background: rgba(255, 107, 157, 0.16); color: var(--admin-danger); }

/* ===== 弹窗 ===== */
.modal-mask {
  position: fixed;
  inset: 0;
  background: var(--admin-overlay);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
  padding: 20px;
}
.modal {
  width: 480px;
  max-width: 100%;
  background: var(--admin-card);
  border-radius: 16px;
  padding: 26px 26px 20px;
  box-shadow: 0 20px 50px var(--admin-shadow-strong);
}
.modal-title {
  margin: 0 0 18px;
  font-size: 18px;
  color: var(--admin-text);
}
.modal-body { max-height: 55vh; overflow-y: auto; }
.m-field { margin-bottom: 14px; }
.m-field label {
  display: block;
  font-size: 13px;
  font-weight: 600;
  color: var(--admin-text-2);
  margin-bottom: 6px;
}
.m-field input,
.m-field textarea {
  width: 100%;
  box-sizing: border-box;
  border: 1px solid var(--admin-border);
  border-radius: 10px;
  padding: 9px 12px;
  font-size: 14px;
  color: var(--admin-text);
  outline: none;
  resize: vertical;
}
.m-field input:focus,
.m-field textarea:focus { border-color: var(--admin-accent); }
.m-row { display: flex; gap: 12px; }
.m-row .m-field { flex: 1; }
.modal-error { font-size: 13px; color: var(--admin-danger); margin: 0 0 10px; }
.modal-foot {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 10px;
}
</style>
