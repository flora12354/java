<template>
  <LoginCard @notify="notify" />
</template>

<script setup>
import { inject } from 'vue'
import LoginCard from '../components/LoginCard.vue'

const notify = inject('notify')
</script>
