import { post, get, put, del } from './request'

// ===== 后台管理系统接口 =====

// 管理员登录：POST /api/admin/login
export function adminLoginApi(username, password) {
  return post('/admin/login', { username, password })
}

// 商品列表（支持关键字 + 分类筛选）：GET /api/goods
export function goodsListApi(keyword = '', category = '') {
  const qs = new URLSearchParams()
  if (keyword) qs.append('keyword', keyword)
  if (category && category !== '全部') qs.append('category', category)
  const q = qs.toString()
  return get('/goods' + (q ? '?' + q : ''))
}

// 新增商品：POST /api/goods
export function goodsAddApi(goods) {
  return post('/goods', goods)
}

// 修改商品：PUT /api/goods
export function goodsUpdateApi(goods) {
  return put('/goods', goods)
}

// 删除商品：DELETE /api/goods/{id}
export function goodsDeleteApi(id) {
  return del(`/goods/${id}`)
}

// ===== 订单管理 =====

// 订单列表：GET /api/admin/orders?keyword=xxx&status=PAID
export function orderListApi(keyword = '', status = '') {
  const qs = new URLSearchParams()
  if (keyword) qs.append('keyword', keyword)
  if (status && status !== '全部') qs.append('status', status)
  const q = qs.toString()
  return get('/admin/orders' + (q ? '?' + q : ''))
}

// 发货：PUT /api/admin/order/status（PAID → SHIPPED）
export function orderShipApi(id) {
  return put('/admin/order/status', { id, status: 'SHIPPED' })
}

// 确认完成：PUT /api/admin/order/status（SHIPPED → COMPLETED）
export function orderCompleteApi(id) {
  return put('/admin/order/status', { id, status: 'COMPLETED' })
}

// 处理退款：PUT /api/admin/order/refund（approve=true 通过退款，false 驳回）
export function orderRefundApi(id, approve) {
  return put('/admin/order/refund', { id, approve })
}

// ===== 用户管理 =====

// 注册用户列表：GET /api/admin/users?keyword=xxx
export function userListApi(keyword = '') {
  const q = keyword ? '?keyword=' + encodeURIComponent(keyword) : ''
  return get('/admin/users' + q)
}

// ===== 评价管理 =====

// 评价列表：GET /api/admin/reviews?keyword=xxx&status=PENDING
export function reviewListApi(keyword = '', status = '') {
  const qs = new URLSearchParams()
  if (keyword) qs.append('keyword', keyword)
  if (status && status !== '全部') qs.append('status', status)
  const q = qs.toString()
  return get('/admin/reviews' + (q ? '?' + q : ''))
}

// 评价审核：PUT /api/admin/review/status（APPROVED 通过 / REJECTED 驳回）
export function reviewAuditApi(id, status) {
  return put('/admin/review/status', { id, status })
}

// 删除评价：DELETE /api/admin/review/{id}
export function reviewDeleteApi(id) {
  return del(`/admin/review/${id}`)
}
