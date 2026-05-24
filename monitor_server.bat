@echo off
REM Monitor Minecraft server process and restart if it is not listening on port 25565
setlocal enabledelayedexpansion
set "BASE_DIR=%~dp0"
set "SERVER_PORT=25565"
set "JAR_NAME=paper.jar"
if exist "server_settings.env" (
  for /f "usebackq tokens=1,* delims==" %%A in ("server_settings.env") do (
    if not "%%B"=="" set "%%A=%%B"
  )
)
if defined SERVER_PORT set "SERVER_PORT=%SERVER_PORT%"
if defined JAR_NAME set "JAR_NAME=%JAR_NAME%"

powershell -NoProfile -Command "try { $c = New-Object Net.Sockets.TcpClient('127.0.0.1', %SERVER_PORT%); $c.Close(); exit 0 } catch { exit 1 }"
if %ERRORLEVEL% equ 0 (
  echo Minecraft server is online on port %SERVER_PORT%.
  exit /b 0
)
echo Minecraft server is not listening on port %SERVER_PORT%. Restarting server...
cd /d "%BASE_DIR%"
call auto_start.bat
endlocal
