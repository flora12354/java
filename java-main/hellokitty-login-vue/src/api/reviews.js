// 商品评价相关接口（演示项目：本地模拟 + localStorage 持久化）
const KEY = 'kitty_reviews'

const SEED_REVIEWS = [
  { id: 101, goodsId: 1, userId: 0, username: '甜心宝贝', rating: 5, content: '太可爱啦！做工精致，和图片一模一样，发货也快～', createTime: '2026-10-12T10:20:00.000Z', status: 'APPROVED' },
  { id: 102, goodsId: 1, userId: 0, username: '粉色控', rating: 4, content: '颜值很高，摆在家里心情都变好了，推荐入手！', createTime: '2026-10-18T08:05:00.000Z', status: 'APPROVED' },
  { id: 103, goodsId: 2, userId: 0, username: 'Kitty 粉丝', rating: 5, content: '质感超出预期，包装也很用心，喜欢💕', createTime: '2026-11-02T15:40:00.000Z', status: 'APPROVED' }
]

function load() {
  try {
    const raw = localStorage.getItem(KEY)
    if (raw === null) {
      localStorage.setItem(KEY, JSON.stringify(SEED_REVIEWS))
      return SEED_REVIEWS.slice()
    }
    const data = JSON.parse(raw)
    return Array.isArray(data) ? data : []
  } catch (e) {
    return SEED_REVIEWS.slice()
  }
}

function save(list) {
  localStorage.setItem(KEY, JSON.stringify(list))
}

/** 商品评价列表：只返回已通过审核的评价 */
export async function goodsReviewListApi(goodsId) {
  const list = load().filter(
    r => String(r.goodsId) === String(goodsId) && r.status === 'APPROVED'
  )
  return { code: 200, msg: 'ok', data: list }
}

/** 提交评价（演示项目：直接落库并标记已通过，方便立即看到效果） */
export async function createReviewApi(userId, goodsId, rating, content) {
  const list = load()
  const username = (() => {
    try {
      const u = JSON.parse(localStorage.getItem('user') || '{}')
      return u.username || '可爱用户'
    } catch (e) {
      return '可爱用户'
    }
  })()
  const item = {
    id: Date.now(),
    goodsId,
    userId,
    username,
    rating: Number(rating) || 5,
    content,
    createTime: new Date().toISOString(),
    status: 'APPROVED'
  }
  list.unshift(item)
  save(list)
  return { code: 200, msg: '评价已提交', data: item }
}
