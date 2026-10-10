@echo off
chcp 936 >nul
title HelloKitty 一键停止
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8081" ^| findstr "LISTENING"') do (
    echo 正在停止后端进程 PID=%%a ...
    taskkill /F /PID %%a >nul
)
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5173" ^| findstr "LISTENING"') do (
    echo 正在停止前端进程 PID=%%a ...
    taskkill /F /PID %%a >nul
)
echo 前后端服务已全部停止
pause
