<template>
  <div class="about">
    <!-- 顶部导航栏 -->
    <header class="navbar">
      <div class="nav-inner">
        <div class="nav-left">
          <div class="brand">
            <span class="brand-badge"><i></i></span>
            <span class="brand-name">Hello Kitty</span>
          </div>
          <nav class="nav-menu">
            <button class="nav-item" @click="goHome">首页</button>
            <button class="nav-item active">介绍</button>
          </nav>
        </div>
        <div class="nav-right">
          <span class="greet">Hi，{{ username }} <span class="cat">🐱</span></span>
          <button class="logout-btn" @click="handleLogout">退出</button>
        </div>
      </div>
    </header>

    <main class="page">
      <div class="page-inner">
        <!-- 项目简介 -->
        <section class="card hero-card">
          <div class="hero-emoji">🎀</div>
          <h1>Hello Kitty 登录 · 商城系统</h1>
          <p class="hero-desc">
            一个基于 Spring Boot + Vue 3 的全栈练习项目：粉色系 Hello Kitty 主题商城，
            支持用户注册 / 登录（MD5 加密）、商品搜索与展示，前后端分离架构。
          </p>
          <div class="chips">
            <span class="chip">Vue 3</span>
            <span class="chip">Vite 5</span>
            <span class="chip">Vue Router 4</span>
            <span class="chip">Spring Boot 3.4.5</span>
            <span class="chip">MyBatis-Plus 3.5.9</span>
            <span class="chip">MySQL 8.0</span>
          </div>
        </section>

        <!-- 功能模块 -->
        <section class="card">
          <h2>🧩 功能模块</h2>
          <ul class="feature-list">
            <li><b>用户系统</b>：注册、登录，密码 MD5 加密存储，登录状态本地保持</li>
            <li><b>商品展示</b>：首页推荐 10 件 Hello Kitty 主题好物（公仔、配饰、文具、家居等）</li>
            <li><b>商品搜索</b>：调用后端 /api/search 接口按关键词检索，后端未启动时自动回退本地数据</li>
            <li><b>介绍资料</b>：本页面，随时了解项目结构与使用方式</li>
          </ul>
        </section>

        <!-- 项目结构 -->
        <section class="card">
          <h2>📁 项目结构</h2>
          <div class="cols">
            <div>
              <h3>后端 springBootTest</h3>
              <pre>├─ src/main/java        Java 源码
├─ src/main/resources   配置文件（dev: 8081）
├─ sql/hellokitty_login.sql  建库建表脚本
└─ mvnw.cmd             Maven Wrapper</pre>
            </div>
            <div>
              <h3>前端 hellokitty-login-vue</h3>
              <pre>├─ src/views/           页面（登录/注册/首页/介绍）
├─ src/components/      组件（登录卡片等）
├─ src/router/          路由（含登录守卫）
└─ src/api/             接口封装（axios）</pre>
            </div>
          </div>
        </section>

        <!-- 数据库 -->
        <section class="card">
          <h2>🗄️ 数据库设计（hellokitty_login）</h2>
          <table>
            <thead>
              <tr><th>表名</th><th>说明</th><th>关键字段</th></tr>
            </thead>
            <tbody>
              <tr><td>user</td><td>用户表</td><td>id · username(唯一) · password(MD5) · create_time</td></tr>
              <tr><td>goods</td><td>商品表</td><td>id · name · emoji · category · price · description</td></tr>
            </tbody>
          </table>
          <p class="tip">测试账号：<b>admin / 123456</b>（也可自行注册新账号）</p>
        </section>

        <!-- 启动方式 -->
        <section class="card">
          <h2>🚀 启动方式</h2>
          <ol class="steps">
            <li>双击 <code>一键启动全部.bat</code>：自动启动后端（8081）并等待端口就绪，再启动前端（5173）</li>
            <li>或分别运行 <code>启动后端.bat</code> 与 <code>启动前端.bat</code></li>
            <li>浏览器访问 <code>http://localhost:5173</code>（本机）或 <code>http://192.168.68.5:5173</code>（局域网其他设备），登录后即可进入首页</li>
          </ol>
        </section>

        <p class="footer">🎀 用爱发电 · Hello Kitty 主题练习项目</p>
      </div>
    </main>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const user = JSON.parse(localStorage.getItem('user') || '{}')
const username = computed(() => user.username || '可爱用户')

function goHome() {
  router.push('/home')
}

function handleLogout() {
  localStorage.removeItem('user')
  router.push('/login')
}
</script>

<style scoped>
.about {
  position: relative;
  z-index: 2;
  width: 100%;
  height: 100vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

/* ===== 顶部导航栏（与首页一致） ===== */
.navbar { flex: none; padding: 14px 20px; }
.nav-inner {
  max-width: 1080px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  background: rgba(255, 255, 255, 0.82);
  backdrop-filter: blur(8px);
  border: 2px solid #ffd9e6;
  border-radius: 22px;
  box-shadow: 0 12px 30px rgba(255, 105, 155, 0.18);
  padding: 10px 20px;
}
.nav-left { display: flex; align-items: center; gap: 22px; }
.brand { display: flex; align-items: center; gap: 10px; }
.brand-badge {
  position: relative;
  width: 34px; height: 34px;
  border-radius: 50%;
  background: linear-gradient(135deg, #ff7aa8, #ff5c8a);
  box-shadow: 0 4px 12px rgba(255, 92, 138, 0.35);
  flex: none;
}
.brand-badge::before,
.brand-badge::after {
  content: "";
  position: absolute;
  top: 8px;
  width: 14px; height: 11px;
  background: #fff;
  border-radius: 50% 50% 50% 50% / 60% 60% 40% 40%;
}
.brand-badge::before { left: 4px; transform: rotate(-25deg); }
.brand-badge::after { right: 4px; transform: rotate(25deg); }
.brand-badge i {
  position: absolute;
  left: 50%; top: 50%;
  width: 9px; height: 9px;
  background: #fff;
  border-radius: 50%;
  transform: translate(-50%, -50%);
}
.brand-name { font-size: 18px; font-weight: 700; color: #ff5c8a; letter-spacing: 0.5px; }
.nav-menu { display: flex; gap: 6px; }
.nav-item {
  border: none;
  background: transparent;
  color: #a96f88;
  font-size: 15px;
  font-weight: 600;
  padding: 8px 14px;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.18s, color 0.18s;
}
.nav-item:hover { background: #fff0f6; color: #ff5c8a; }
.nav-item.active {
  background: linear-gradient(90deg, #ff7aa8, #ff5c8a);
  color: #fff;
  box-shadow: 0 6px 16px rgba(255, 92, 138, 0.3);
}
.nav-right { display: flex; align-items: center; gap: 14px; }
.greet { font-size: 14px; color: #5d3a47; font-weight: 600; }
.cat { font-size: 16px; }
.logout-btn {
  border: 2px solid #ffd9e6;
  background: #fff8fb;
  color: #ff5c8a;
  font-size: 13px;
  font-weight: 600;
  padding: 7px 16px;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.18s, transform 0.15s;
}
.logout-btn:hover { background: #ffe3ee; transform: translateY(-1px); }

/* ===== 内容 ===== */
.page { flex: 1 1 auto; overflow-y: auto; padding: 6px 20px 30px; }
.page-inner { max-width: 860px; margin: 0 auto; }
.card {
  background: #ffffff;
  border: 2px solid #ffd9e6;
  border-radius: 20px;
  box-shadow: 0 10px 26px rgba(255, 105, 155, 0.14);
  padding: 26px 30px;
  margin-bottom: 20px;
}
.hero-card { text-align: center; }
.hero-emoji { font-size: 52px; margin-bottom: 8px; }
.hero-card h1 { font-size: 24px; color: #ff5c8a; margin-bottom: 10px; }
.hero-desc { font-size: 14.5px; color: #5d3a47; line-height: 1.8; margin-bottom: 16px; }
.chips { display: flex; flex-wrap: wrap; gap: 8px; justify-content: center; }
.chip {
  font-size: 12.5px;
  font-weight: 600;
  color: #ff5c8a;
  background: #fff0f6;
  border: 1px solid #ffd9e6;
  border-radius: 999px;
  padding: 4px 14px;
}
.card h2 { font-size: 17px; color: #5d3a47; margin-bottom: 14px; }
.feature-list { padding-left: 4px; list-style: none; }
.feature-list li {
  font-size: 14px;
  color: #5d3a47;
  line-height: 1.9;
  padding-left: 22px;
  position: relative;
}
.feature-list li::before { content: "🐾"; position: absolute; left: 0; font-size: 13px; }
.cols { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
.cols h3 { font-size: 14px; color: #ff5c8a; margin-bottom: 8px; }
pre {
  background: #fff7fa;
  border: 1px solid #ffe0ec;
  border-radius: 12px;
  padding: 12px 14px;
  font-size: 12.5px;
  color: #7a5563;
  line-height: 1.7;
  overflow-x: auto;
}
table { width: 100%; border-collapse: collapse; font-size: 13.5px; }
th, td {
  border: 1px solid #ffe0ec;
  padding: 9px 12px;
  text-align: left;
  color: #5d3a47;
}
th { background: #fff0f6; color: #ff5c8a; font-weight: 700; }
.tip { margin-top: 12px; font-size: 13.5px; color: #c48ba2; }
.tip b { color: #ff5c8a; }
.steps { padding-left: 22px; }
.steps li { font-size: 14px; color: #5d3a47; line-height: 2; }
code {
  background: #fff0f6;
  border-radius: 6px;
  padding: 2px 8px;
  font-size: 13px;
  color: #ff5c8a;
  font-weight: 600;
}
.footer { text-align: center; font-size: 13px; color: #c48ba2; padding: 8px 0 16px; }

@media (max-width: 720px) {
  .nav-menu { display: none; }
  .cols { grid-template-columns: 1fr; }
  .card { padding: 20px 18px; }
}
</style>
