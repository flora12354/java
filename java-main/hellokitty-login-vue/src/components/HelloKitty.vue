<template>
  <div class="kitty">
    <div class="ear left"></div>
    <div class="ear right"></div>
    <div class="bow"><i></i></div>
    <div class="face">
      <div class="eye left"></div>
      <div class="eye right"></div>
      <div class="nose"></div>
      <div
        v-for="w in whiskers"
        :key="w"
        class="whisker"
        :class="w"
      ></div>
    </div>
  </div>
</template>

<script setup>
const whiskers = ['l1', 'l2', 'l3', 'r1', 'r2', 'r3']
</script>

<style scoped>
.kitty {
  position: absolute;
  top: -78px;
  left: 50%;
  transform: translateX(-50%);
  width: 150px;
  height: 118px;
}
.ear {
  position: absolute;
  top: 2px;
  width: 42px;
  height: 46px;
  background: #fff;
  border: 3px solid #f3c1d4;
}
.ear.left {
  left: 8px;
  border-radius: 8px 90% 8px 8px;
  transform: rotate(-18deg);
}
.ear.right {
  right: 8px;
  border-radius: 90% 8px 8px 8px;
  transform: rotate(18deg);
}
.face {
  position: absolute;
  top: 16px;
  left: 0;
  width: 150px;
  height: 102px;
  background: #fff;
  border: 3px solid #f3c1d4;
  border-radius: 48% 48% 46% 46% / 60% 60% 42% 42%;
  box-shadow: 0 8px 20px rgba(255, 105, 155, 0.18);
}
.eye {
  position: absolute;
  top: 46px;
  width: 11px;
  height: 14px;
  background: #3a2e33;
  border-radius: 50%;
}
.eye.left { left: 36px; }
.eye.right { right: 36px; }
.nose {
  position: absolute;
  top: 62px;
  left: 50%;
  transform: translateX(-50%);
  width: 14px;
  height: 10px;
  background: #ffcf40;
  border-radius: 50%;
  border: 1.5px solid #e8b52e;
}
.whisker {
  position: absolute;
  width: 26px;
  height: 2.5px;
  background: #c9b7bd;
  border-radius: 2px;
}
.whisker.l1 { left: -6px; top: 52px; transform: rotate(8deg); }
.whisker.l2 { left: -8px; top: 64px; }
.whisker.l3 { left: -6px; top: 76px; transform: rotate(-8deg); }
.whisker.r1 { right: -6px; top: 52px; transform: rotate(-8deg); }
.whisker.r2 { right: -8px; top: 64px; }
.whisker.r3 { right: -6px; top: 76px; transform: rotate(8deg); }

.bow {
  position: absolute;
  top: 6px;
  left: 0;
  width: 52px;
  height: 34px;
  z-index: 3;
}
.bow::before,
.bow::after {
  content: "";
  position: absolute;
  width: 24px;
  height: 20px;
  background: #ff5c8a;
  border-radius: 50% 50% 50% 50% / 55% 55% 45% 45%;
}
.bow::before { left: 2px; transform: rotate(-28deg); }
.bow::after { right: 2px; transform: rotate(28deg); }
.bow i {
  position: absolute;
  left: 50%;
  top: 50%;
  width: 14px;
  height: 14px;
  background: #ff5c8a;
  border-radius: 50%;
  transform: translate(-50%, -50%);
  z-index: 1;
}
</style>
