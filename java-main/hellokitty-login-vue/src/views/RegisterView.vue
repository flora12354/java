<template>
  <RegisterCard @notify="notify" />
</template>

<script setup>
import { inject } from 'vue'
import RegisterCard from '../components/RegisterCard.vue'

const notify = inject('notify')
</script>
