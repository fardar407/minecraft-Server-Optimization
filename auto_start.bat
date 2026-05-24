@echo off
REM Minecraft auto-start wrapper for Windows
setlocal enabledelayedexpansion
set "BASE_DIR=%~dp0"
cd /d "%BASE_DIR%"

:RESTART
echo Starting Minecraft server at %date% %time%
call "%BASE_DIR%\run_server.bat"
if %ERRORLEVEL% NEQ 0 (
  echo Server stopped with error %ERRORLEVEL%. Restarting in 10 seconds...
) else (
  echo Server stopped normally. Restarting in 10 seconds...
)
timeout /t 10 /nobreak >nul
goto RESTART
endlocal
