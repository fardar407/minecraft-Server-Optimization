@echo off
REM Minecraft auto-start wrapper for Windows with safe restart throttling
setlocal enabledelayedexpansion
set "BASE_DIR=%~dp0"
cd /d "%BASE_DIR%"
set /a RESTART_COUNT=0
set /a MAX_RESTARTS=5

:RESTART
echo Starting Minecraft server at %date% %time%
call "%BASE_DIR%\run_server.bat"
set /a RESTART_COUNT+=1
if %ERRORLEVEL% NEQ 0 (
  echo Server stopped with error %ERRORLEVEL%. Restarting in 10 seconds...
) else (
  echo Server stopped normally. Restarting in 10 seconds...
)
if %RESTART_COUNT% GEQ %MAX_RESTARTS% (
  echo Too many restarts in a short period. Sleeping 120 seconds before retrying...
  timeout /t 120 /nobreak >nul
  set /a RESTART_COUNT=0
)
timeout /t 10 /nobreak >nul
goto RESTART
endlocal
