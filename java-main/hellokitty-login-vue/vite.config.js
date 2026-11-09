import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    host: '0.0.0.0', // 监听所有网卡，局域网内可通过 http://192.168.68.36:5173 访问
    port: 5173,
    open: false,
    proxy: {
      // 前端 /api 请求代理到 Spring Boot 后端（本机 IP 192.168.68.36 的 8081 端口）
      '/api': {
        target: 'http://192.168.68.36:8081',
        changeOrigin: true
      }
    }
  }
})
