// 收货地址相关接口（演示项目：本地模拟 + localStorage 持久化）
const KEY = 'kitty_addresses'

const DEFAULT_ADDRESSES = [
  {
    id: 1,
    receiver: 'kitty 酱',
    phone: '13800138000',
    province: '上海市',
    city: '上海市',
    district: '徐汇区',
    detail: '甜甜路 168 号粉色公寓 520 室',
    isDefault: true
  },
  {
    id: 2,
    receiver: '小可爱',
    phone: '13900139000',
    province: '广东省',
    city: '广州市',
    district: '天河区',
    detail: '幸福大街 88 号 A 座 1801',
    isDefault: false
  }
]

function load() {
  try {
    const raw = localStorage.getItem(KEY)
    if (raw === null) {
      localStorage.setItem(KEY, JSON.stringify(DEFAULT_ADDRESSES))
      return DEFAULT_ADDRESSES.slice()
    }
    const data = JSON.parse(raw)
    return Array.isArray(data) ? data : []
  } catch (e) {
    return DEFAULT_ADDRESSES.slice()
  }
}

function save(list) {
  localStorage.setItem(KEY, JSON.stringify(list))
}

/** 获取收货地址列表：返回 { ok, code, data } */
export async function listAddresses() {
  return { ok: true, code: 200, msg: 'ok', data: load() }
}

/** 新增收货地址 */
export async function addAddress(address) {
  const list = load()
  const id = Date.now()
  const item = { ...address, id }
  if (item.isDefault) list.forEach(a => (a.isDefault = false))
  list.push(item)
  save(list)
  return { ok: true, code: 200, msg: '添加成功', data: item }
}

/** 修改收货地址 */
export async function updateAddress(address) {
  const list = load()
  const idx = list.findIndex(a => String(a.id) === String(address.id))
  if (idx === -1) return { ok: false, code: 404, msg: '地址不存在', data: null }
  if (address.isDefault) list.forEach(a => (a.isDefault = false))
  list[idx] = { ...list[idx], ...address }
  save(list)
  return { ok: true, code: 200, msg: '修改成功', data: list[idx] }
}

/** 删除收货地址 */
export async function deleteAddress(id) {
  let list = load().filter(a => String(a.id) !== String(id))
  if (list.length && !list.some(a => a.isDefault)) list[0].isDefault = true
  save(list)
  return { ok: true, code: 200, msg: '删除成功', data: list }
}

/** 设为默认地址 */
export async function setDefaultAddress(id) {
  const list = load()
  list.forEach(a => (a.isDefault = String(a.id) === String(id)))
  save(list)
  return { ok: true, code: 200, msg: '已设为默认', data: list }
}
