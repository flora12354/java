<template>
  <div class="sky">
    <div class="stars"></div>
    <div class="stars2"></div>
    <div class="stars3"></div>
    <div class="meteor"></div>
    <div class="meteor"></div>
    <div class="meteor"></div>

    <router-view />
  </div>
</template>

<script setup>
</script>

<style scoped>
.sky {
  position: relative;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: radial-gradient(
    ellipse at 50% -10%,
    #1d1b4e 0%,
    var(--bg-mid) 45%,
    var(--bg-deep) 100%
  );
}

/* 星空层 */
.stars,
.stars2,
.stars3 {
  position: fixed;
  inset: 0;
  pointer-events: none;
}
.stars {
  background: transparent
    url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='200' height='200'><circle cx='20' cy='30' r='1.1' fill='white' opacity='0.9'/><circle cx='120' cy='80' r='0.8' fill='white' opacity='0.6'/><circle cx='170' cy='150' r='1.2' fill='white' opacity='0.8'/><circle cx='60' cy='150' r='0.7' fill='white' opacity='0.5'/><circle cx='90' cy='10' r='0.9' fill='white' opacity='0.7'/></svg>")
    repeat;
}
.stars2 {
  background: transparent
    url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='300' height='300'><circle cx='40' cy='60' r='0.9' fill='%234ad9ff' opacity='0.7'/><circle cx='220' cy='120' r='1' fill='%239b6cff' opacity='0.6'/><circle cx='150' cy='240' r='0.8' fill='white' opacity='0.6'/></svg>")
    repeat;
  animation: drift 90s linear infinite;
}
.stars3 {
  background: transparent
    url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='400' height='400'><circle cx='80' cy='90' r='1.3' fill='%23ff7bd5' opacity='0.5'/><circle cx='300' cy='200' r='1' fill='white' opacity='0.5'/><circle cx='200' cy='340' r='1.1' fill='%234ad9ff' opacity='0.5'/></svg>")
    repeat;
  animation: drift 150s linear infinite;
}

@keyframes drift {
  from {
    transform: translateY(0);
  }
  to {
    transform: translateY(-400px);
  }
}

/* 流星 */
.meteor {
  position: fixed;
  top: -50px;
  width: 2px;
  height: 120px;
  background: linear-gradient(to bottom, rgba(255, 255, 255, 0), #fff);
  opacity: 0;
  transform: rotate(25deg);
  animation: fall 7s linear infinite;
}
.meteor:nth-child(4) {
  left: 20%;
  animation-delay: 2s;
}
.meteor:nth-child(5) {
  left: 55%;
  animation-delay: 4.5s;
}
.meteor:nth-child(6) {
  left: 80%;
  animation-delay: 6s;
}
@keyframes fall {
  0% {
    opacity: 0;
    transform: translate(0, 0) rotate(25deg);
  }
  10% {
    opacity: 1;
  }
  100% {
    opacity: 0;
    transform: translate(-260px, 760px) rotate(25deg);
  }
}
</style>
