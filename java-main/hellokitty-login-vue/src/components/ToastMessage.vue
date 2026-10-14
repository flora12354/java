<template>
  <div class="toast" :class="{ show: visible }">{{ message }}</div>
</template>

<script setup>
defineProps({
  message: { type: String, default: '' },
  visible: { type: Boolean, default: false }
})
</script>

<style scoped>
.toast {
  position: fixed;
  top: 28px;
  left: 50%;
  transform: translate(-50%, -80px);
  background: #ff5c8a;
  color: #fff;
  padding: 12px 26px;
  border-radius: 30px;
  font-size: 14px;
  box-shadow: 0 10px 30px rgba(255, 92, 138, 0.4);
  transition: transform 0.35s ease;
  z-index: 99;
}
.toast.show { transform: translate(-50%, 0); }
</style>
