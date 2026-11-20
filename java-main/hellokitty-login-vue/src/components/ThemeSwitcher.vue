<template>
  <button
    class="theme-switcher"
    type="button"
    :title="`切换主题（当前：${currentLabel}）`"
    :aria-label="`切换主题，当前 ${currentLabel}`"
    @click="toggleTheme"
  >
    <span class="theme-icon">{{ currentIcon }}</span>
  </button>
</template>

<script setup>
import { computed } from 'vue'
import { THEMES, currentTheme, toggleTheme } from '../composables/useTheme'

const currentIcon = computed(() => {
  const t = THEMES.find(x => x.key === currentTheme.value)
  return t ? t.icon : '🌸'
})
const currentLabel = computed(() => {
  const t = THEMES.find(x => x.key === currentTheme.value)
  return t ? t.label : '奶油粉'
})
</script>

<style scoped>
.theme-switcher {
  position: fixed;
  right: 18px;
  bottom: 18px;
  z-index: 999;
  width: 46px;
  height: 46px;
  border: 2px solid var(--border);
  border-radius: 50%;
  background: var(--card);
  box-shadow: 0 8px 20px var(--shadow-2);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  backdrop-filter: blur(8px);
  transition: transform 0.18s ease, box-shadow 0.18s ease, border-color 0.18s ease;
}
.theme-switcher:hover {
  transform: translateY(-3px) rotate(-10deg);
  box-shadow: 0 12px 26px var(--shadow-3);
  border-color: var(--brand-3);
}
.theme-switcher:active {
  transform: scale(0.92);
}
.theme-icon {
  font-size: 22px;
  line-height: 1;
  user-select: none;
}
</style>
