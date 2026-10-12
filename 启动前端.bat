@echo off
chcp 936 >nul
title HelloKitty-前端
cd /d "%~dp0"
echo ========================================
echo  HelloKitty 前端 (Vite) 启动中...
echo  端口: 5173
echo ========================================
echo.
call npm run dev
echo.
echo 前端已停止。
pause
