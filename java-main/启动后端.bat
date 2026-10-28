@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title HelloKitty-Backend
cd /d "%~dp0springBootTest"

rem JAVA_HOME 末尾带反斜杠时容错处理
if "%JAVA_HOME:~-1%"=="\" set "JAVA_HOME=%JAVA_HOME:~0,-1%"

if not exist "%JAVA_HOME%\bin\java.exe" (
    echo [ERROR] JAVA_HOME not valid: %JAVA_HOME%
    pause
    exit /b 1
)

rem 查找本机已有的 Maven（~/.m2/wrapper/dists 下最新一个）
set "MVN_CMD="
for /f "delims=" %%F in ('dir /b /s /o-n "%USERPROFILE%\.m2\wrapper\dists\apache-maven-*\bin\mvn.cmd" 2^>nul') do (
    if not defined MVN_CMD set "MVN_CMD=%%F"
)

echo ========================================
echo  HelloKitty Backend (Spring Boot) starting...
echo  env: dev    port: 8081
echo  First run downloads Maven deps, please wait
echo ========================================
echo.

if defined MVN_CMD (
    echo Using local Maven: !MVN_CMD!
    call "!MVN_CMD!" spring-boot:run
) else (
    echo Using Maven wrapper...
    call mvnw.cmd spring-boot:run
    if errorlevel 1 (
        echo [ERROR] mvnw.cmd failed. Check .mvn/wrapper/maven-wrapper.properties
    )
)

echo.
echo Backend stopped.
pause
