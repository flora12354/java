<template>
  <div class="decorations">
    <div
      v-for="item in items"
      :key="item.id"
      :class="item.type"
      :style="item.style"
    >
      <i v-if="item.type === 'float-bow'"></i>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  count: { type: Number, default: 14 }
})

// 装饰色跟随主题（见 styles/theme.css 中的 --deco-*）
const colors = ['var(--deco-1)', 'var(--deco-2)', 'var(--deco-3)', 'var(--deco-4)']

const items = computed(() =>
  Array.from({ length: props.count }, (_, i) => {
    const isBow = i % 2 === 0
    const size = isBow ? 26 + Math.random() * 26 : 8 + Math.random() * 14
    const color = colors[i % colors.length]
    return {
      id: i,
      type: isBow ? 'float-bow' : 'float-dot',
      style: {
        width: size + 'px',
        height: (isBow ? size * 0.6 : size) + 'px',
        left: Math.random() * 100 + 'vw',
        animationDuration: 9 + Math.random() * 10 + 's',
        animationDelay: -Math.random() * 12 + 's',
        '--c': color,
        ...(isBow ? {} : { background: color })
      }
    }
  })
)
</script>

<style scoped>
.decorations {
  position: absolute;
  inset: 0;
  overflow: hidden;
  pointer-events: none;
}

.float-bow {
  position: absolute;
  opacity: var(--deco-opacity);
  animation: floaty linear infinite;
}
.float-bow::before,
.float-bow::after {
  content: "";
  position: absolute;
  width: 22px;
  height: 18px;
  background: var(--c, var(--brand-3));
  border-radius: 50% 50% 50% 50% / 60% 60% 40% 40%;
}
.float-bow::before { left: 0; transform: rotate(-25deg); }
.float-bow::after { right: 0; transform: rotate(25deg); }
.float-bow i {
  position: absolute;
  left: 50%;
  top: 50%;
  width: 12px;
  height: 12px;
  background: var(--c, var(--brand-3));
  border-radius: 50%;
  transform: translate(-50%, -50%);
  z-index: 1;
}

.float-dot {
  position: absolute;
  border-radius: 50%;
  background: var(--deco-2);
  opacity: calc(var(--deco-opacity) * 0.9);
  animation: floaty linear infinite;
}

@keyframes floaty {
  from { transform: translateY(110vh) rotate(0deg); }
  to { transform: translateY(-15vh) rotate(360deg); }
}
</style>
