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
