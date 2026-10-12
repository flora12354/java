@echo off
chcp 936 >nul
title HelloKitty-后端
cd /d "%~dp0"
echo ========================================
echo  HelloKitty 后端 (Spring Boot) 启动中...
echo  环境: dev   端口: 8081
echo  首次运行需下载 Maven 依赖，请耐心等待
echo ========================================
echo.
call mvnw.cmd spring-boot:run
echo.
echo 后端已停止。
pause
