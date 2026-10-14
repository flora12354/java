<template>
  <div class="page">
    <FloatingDecorations :count="14" />
    <router-view />
    <ToastMessage :message="toast.message" :visible="toast.visible" />
  </div>
</template>

<script setup>
import { reactive, provide } from 'vue'
import FloatingDecorations from './components/FloatingDecorations.vue'
import ToastMessage from './components/ToastMessage.vue'

const toast = reactive({ message: '', visible: false })
let timer = null

function showToast(message) {
  toast.message = message
  toast.visible = true
  clearTimeout(timer)
  timer = setTimeout(() => {
    toast.visible = false
  }, 2200)
}

provide('notify', showToast)
</script>
