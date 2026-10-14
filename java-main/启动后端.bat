@echo off
title HelloKitty-Backend
cd /d "%~dp0springBootTest"
echo ========================================
echo  HelloKitty Backend (Spring Boot) starting...
echo  env: dev    port: 8081
echo  First run downloads Maven deps, please wait
echo ========================================
echo.
call mvnw.cmd spring-boot:run
echo.
echo Backend stopped.
pause
