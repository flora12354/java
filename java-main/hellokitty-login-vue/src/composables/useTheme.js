import { ref } from 'vue'

// 支持的主题，顺序即 ThemeSwitcher 的轮播顺序
export const THEMES = [
  { key: 'light', label: '奶油粉', icon: '🌸' },
  { key: 'rose', label: '玫瑰红', icon: '💗' },
  { key: 'night', label: '夜间黑', icon: '🌙' }
]

const STORAGE_KEY = 'hk-theme'
const META_COLORS = { light: '#ffd3e4', rose: '#f79bb8', night: '#1c1020' }

// 全局共享的当前主题（响应式），供主题切换按钮与页面联动
export const currentTheme = ref('light')

function normalize(value) {
  return THEMES.some(t => t.key === value) ? value : 'light'
}

function apply(theme) {
  const key = normalize(theme)
  currentTheme.value = key

  if (typeof document !== 'undefined') {
    const root = document.documentElement
    root.setAttribute('data-theme', key)
    root.style.colorScheme = key === 'night' ? 'dark' : 'light'
    const meta = document.querySelector('meta[name="theme-color"]')
    if (meta) meta.setAttribute('content', META_COLORS[key])
  }
  try {
    localStorage.setItem(STORAGE_KEY, key)
  } catch (e) {
    /* 隐私模式下 localStorage 可能不可用，忽略即可 */
  }
  return key
}

/** 读取本地存储里的主题并应用（在 main.js 启动时调用一次） */
export function initTheme() {
  let saved = 'light'
  try {
    saved = localStorage.getItem(STORAGE_KEY) || 'light'
  } catch (e) {
    saved = 'light'
  }
  return apply(saved)
}

/** 切换到指定主题 */
export function setTheme(theme) {
  return apply(theme)
}

/** 按 THEMES 顺序切换到下一个主题，返回新的主题 key */
export function toggleTheme() {
  const idx = THEMES.findIndex(t => t.key === currentTheme.value)
  const next = THEMES[(idx + 1) % THEMES.length].key
  return apply(next)
}

/** 组合式函数形式，方便组件内使用 */
export function useTheme() {
  return {
    themes: THEMES,
    currentTheme,
    setTheme,
    toggleTheme
  }
}
