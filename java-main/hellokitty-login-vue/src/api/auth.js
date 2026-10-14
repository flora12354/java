import { post } from './request'

// 登录
export function loginApi(username, password) {
  return post('/auth/login', { username, password })
}

// 注册
export function registerApi(username, password) {
  return post('/auth/register', { username, password })
}
