// 订单相关接口（演示项目：本地模拟 + localStorage 持久化）
import { listAddresses } from './user'

const KEY = 'kitty_orders'

function load() {
  try {
    return JSON.parse(localStorage.getItem(KEY) || '[]') || []
  } catch (e) {
    return []
  }
}

function save(list) {
  localStorage.setItem(KEY, JSON.stringify(list))
}

function genOrderNo() {
  const d = new Date()
  const pad = n => String(n).padStart(2, '0')
  const stamp = `${d.getFullYear()}${pad(d.getMonth() + 1)}${pad(d.getDate())}${pad(d.getHours())}${pad(d.getMinutes())}${pad(d.getSeconds())}`
  return `KT${stamp}${Math.floor(Math.random() * 900 + 100)}`
}

/** 解析订单里的收货地址（下单时可能用地址 id 或直接填写） */
async function resolveAddress(payload) {
  if (payload.addressId) {
    const res = await listAddresses()
    const list = (res && res.data) || []
    const a = list.find(x => String(x.id) === String(payload.addressId))
    if (a) {
      return {
        receiver: a.receiver,
        phone: a.phone,
        address: [a.province, a.city, a.district, a.detail].filter(Boolean).join(' ')
      }
    }
  }
  return {
    receiver: payload.receiver || '-',
    phone: payload.phone || '-',
    address: payload.address || '-'
  }
}

/**
 * 创建订单：POST（本地模拟）
 * payload = { userId, items, addressId? | receiver?, phone?, address? }
 * 返回 { code: 200, data: { orderNo, ... }, msg }
 */
export async function createOrderApi(payload) {
  const items = Array.isArray(payload.items) ? payload.items : []
  const total = items.reduce((s, i) => s + Number(i.price || 0) * (i.qty || 1), 0)
  const count = items.reduce((s, i) => s + (i.qty || 1), 0)
  const addr = await resolveAddress(payload)

  const order = {
    id: Date.now(),
    orderNo: genOrderNo(),
    userId: payload.userId || null,
    items: items.map(i => ({
      goodsId: i.goodsId,
      goodsName: i.goodsName || i.name,
      emoji: i.emoji || '',
      price: Number(i.price) || 0,
      qty: i.qty || 1
    })),
    total: Number(total.toFixed(2)),
    count,
    ...addr,
    status: 'PAID',
    createTime: new Date().toISOString()
  }
  const list = load()
  list.unshift(order)
  save(list)
  return { code: 200, msg: '下单成功', data: order }
}

/** 获取当前用户的订单列表（按创建时间倒序） */
export async function listOrders(userId) {
  let list = load()
  if (userId) list = list.filter(o => String(o.userId) === String(userId))
  return { code: 200, msg: 'ok', data: list }
}

/** 根据订单号查询订单 */
export async function getOrderByNo(orderNo) {
  const order = load().find(o => String(o.orderNo) === String(orderNo))
  return { code: order ? 200 : 404, msg: order ? 'ok' : '订单不存在', data: order || null }
}
