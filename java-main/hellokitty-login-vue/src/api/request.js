// 简单的 fetch 封装，统一处理请求和错误
const BASE_URL = '/api'

async function request(url, options = {}) {
  const resp = await fetch(BASE_URL + url, {
    headers: { 'Content-Type': 'application/json' },
    ...options
  })
  if (!resp.ok) {
    throw new Error('网络请求失败（HTTP ' + resp.status + '）')
  }
  return resp.json()
}

export function post(url, data) {
  return request(url, {
    method: 'POST',
    body: JSON.stringify(data)
  })
}
