@echo off
chcp 65001 >nul
title HelloKitty-Frontend
cd /d "%~dp0hellokitty-login-vue"

echo ========================================
echo  HelloKitty Frontend (Vite) starting...
echo  port: 5173
echo ========================================
echo.

where npm >nul 2>nul
if errorlevel 1 (
    echo [ERROR] npm not found. Please install Node.js first.
    pause
    exit /b 1
)

if not exist "node_modules" (
    echo node_modules not found, running npm install ...
    call npm install
    if errorlevel 1 (
        echo [ERROR] npm install failed.
        pause
        exit /b 1
    )
)

call npm run dev

echo.
echo Frontend stopped.
pause
