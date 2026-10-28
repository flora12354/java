// 本地演示商品数据（与后端 goods 表字段保持一致）
// 后端 /api/search 接入后，可由接口返回真实数据替换
export const mockGoods = [
  { id: 1, name: 'Hello Kitty 公仔', emoji: '🧸', tag: '周边', price: 89.00, description: '超柔软的Hello Kitty经典款公仔，30cm高，抱着睡觉刚刚好，粉丝必入款～' },
  { id: 2, name: '草莓发卡', emoji: '🎀', tag: '配饰', price: 12.50, description: '粉嫩草莓造型发卡，弹簧夹设计不夹头发，日常搭配约会都能戴。' },
  { id: 3, name: '粉色笔记本', emoji: '📒', tag: '文具', price: 25.00, description: 'A5横线内页，粉色磨砂封面，附赠Hello Kitty贴纸一版，上课记笔记超有动力。' },
  { id: 4, name: '猫咪抱枕', emoji: '🐱', tag: '家居', price: 69.00, description: '45cm大号猫咪抱枕，填充饱满有弹性，靠在沙发上看剧必备。' },
  { id: 5, name: '樱花水杯', emoji: '🥤', tag: '生活', price: 45.00, description: '500ml樱花渐变保温杯，316不锈钢内胆，保冷保温12小时。' },
  { id: 6, name: '奶油蛋糕', emoji: '🍰', tag: '美食', price: 39.90, description: '草莓奶油切块蛋糕，动物奶油不腻口，下午茶配一杯红茶刚刚好。' },
  { id: 7, name: '毛绒拖鞋', emoji: '🥿', tag: '家居', price: 29.00, description: '冬季加厚毛绒居家拖鞋，防滑软底，踩上去像踩在云朵上。' },
  { id: 8, name: '星星发夹', emoji: '⭐', tag: '配饰', price: 9.90, description: '镀金星星小发夹，一套5只装，碎发神器，怎么夹都好看。' },
  { id: 9, name: '云朵台灯', emoji: '💡', tag: '家居', price: 99.00, description: '云朵造型小夜灯，三档调光，触控开关，放在床头治愈感拉满。' },
  { id: 10, name: '爱心信封', emoji: '💌', tag: '文具', price: 6.00, description: '粉色爱心信封+信纸套装，写给朋友的一封信，仪式感满满。' }
]

// 根据名称或分类过滤
export function filterGoods(kw) {
  if (!kw) return mockGoods
  return mockGoods.filter(i => i.name.includes(kw) || i.tag.includes(kw))
}

// 根据 id 查找商品
export function findGoodsById(id) {
  return mockGoods.find(i => String(i.id) === String(id))
}
