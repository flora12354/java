@echo off
setlocal EnableDelayedExpansion
title HelloKitty Start-All
echo ========================================
echo  HelloKitty Start All
echo ========================================
echo.

echo [1/2] Starting backend (Spring Boot)...
start "HelloKitty-Backend" /d "%~dp0springBootTest" mvnw.cmd spring-boot:run

echo Waiting for backend port 8081 (LISTENING), up to 3 minutes...
set /a tries=0
:wait8081
ping -n 3 127.0.0.1 >nul
netstat -ano | findstr ":8081" | findstr "LISTENING" >nul
if errorlevel 1 (
    set /a tries+=1
    if !tries! geq 60 (
        echo Backend not up after 3 minutes. Check Maven download / MySQL.
        goto end
    )
    goto wait8081
)

echo [2/2] Starting frontend (Vite)...
start "HelloKitty-Frontend" /d "%~dp0hellokitty-login-vue" npm run dev
echo.
echo All started.
echo   Frontend: http://localhost:5173
echo   Backend : http://localhost:8081
echo.
:end
pause
