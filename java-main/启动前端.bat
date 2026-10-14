@echo off
title HelloKitty-Frontend
cd /d "%~dp0hellokitty-login-vue"
echo ========================================
echo  HelloKitty Frontend (Vite) starting...
echo  port: 5173
echo ========================================
echo.
call npm run dev
echo.
echo Frontend stopped.
pause
