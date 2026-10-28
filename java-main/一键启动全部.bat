@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title HelloKitty Start-All

rem JAVA_HOME 末尾带反斜杠时容错处理
if "%JAVA_HOME:~-1%"=="\" set "JAVA_HOME=%JAVA_HOME:~0,-1%"

if not exist "%JAVA_HOME%\bin\java.exe" (
    echo [ERROR] JAVA_HOME not valid: %JAVA_HOME%
    pause
    exit /b 1
)

where npm >nul 2>nul
if errorlevel 1 (
    echo [ERROR] npm not found. Please install Node.js first.
    pause
    exit /b 1
)

echo ========================================
echo  HelloKitty Start All
echo ========================================
echo.

echo [1/3] Starting backend (Spring Boot)...

rem 查找本机已有的 Maven（~/.m2/wrapper/dists 下最新一个）
set "MVN_CMD="
for /f "delims=" %%F in ('dir /b /s /o-n "%USERPROFILE%\.m2\wrapper\dists\apache-maven-*\bin\mvn.cmd" 2^>nul') do (
    if not defined MVN_CMD set "MVN_CMD=%%F"
)
if defined MVN_CMD (
    echo Using local Maven: !MVN_CMD!
    start "HelloKitty-Backend" /d "%~dp0springBootTest" cmd /k "title HelloKitty-Backend && call "!MVN_CMD!" spring-boot:run"
) else (
    start "HelloKitty-Backend" /d "%~dp0springBootTest" cmd /k "title HelloKitty-Backend && mvnw.cmd spring-boot:run"
)

echo [2/3] Preparing frontend dependencies...
if not exist "%~dp0hellokitty-login-vue\node_modules" (
    pushd "%~dp0hellokitty-login-vue"
    echo node_modules not found, running npm install ...
    call npm install
    if errorlevel 1 (
        echo [ERROR] npm install failed.
        popd
        pause
        exit /b 1
    )
    popd
)

echo Waiting for backend port 8081 (LISTENING), up to 3 minutes...
set /a tries=0
:wait8081
ping -n 3 127.0.0.1 >nul
netstat -ano | findstr /r /c:":8081 .*LISTENING" >nul
if errorlevel 1 (
    set /a tries+=1
    if !tries! geq 60 (
        echo Backend not up after 3 minutes. Check the backend window for errors.
        goto start_frontend
    )
    goto wait8081
)
echo Backend is up.

:start_frontend
echo [3/3] Starting frontend (Vite)...
start "HelloKitty-Frontend" /d "%~dp0hellokitty-login-vue" cmd /k "npm run dev"

echo.
echo All started.
echo   Frontend: http://localhost:5173
echo   Backend : http://localhost:8081
echo.
pause
