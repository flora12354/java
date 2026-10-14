import { post } from './request'

// 首页搜索接口（后端暂未实现，先保留接口约定）
// 约定：POST /api/search
//   请求体: { keyword: string }
//   返回  : { code: 200, msg: string, data: Array<{ name, emoji, tag }> }
// 前端目前使用本地模拟数据兜底，后端接入后自动切换为真实数据。
export function searchApi(keyword) {
  return post('/search', { keyword })
}
