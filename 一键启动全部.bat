@echo off
chcp 936 >nul
title HelloKitty 一键启动
echo ========================================
echo    HelloKitty 登录系统 一键启动
echo ========================================
echo.
echo [1/2] 正在启动后端（新窗口）...
start "HelloKitty-后端" "D:\workSpace\springBootTest\启动后端.bat"

echo 等待后端 8081 端口就绪（首次构建需几分钟，请耐心等待）...
:wait8081
ping -n 3 127.0.0.1 >nul
netstat -ano | findstr ":8081" | findstr "LISTENING" >nul
if errorlevel 1 goto wait8081

echo [2/2] 后端已就绪，正在启动前端（新窗口）...
start "HelloKitty-前端" "%~dp0hellokitty-login-vue\启动前端.bat"
echo.
echo 全部启动完成！浏览器访问 http://localhost:5173
echo 需要停止服务时，双击 一键停止全部.bat
pause
