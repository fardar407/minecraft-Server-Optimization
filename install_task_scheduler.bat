@echo off
REM Install auto-start using Windows Task Scheduler
setlocal enabledelayedexpansion
set "BASE_DIR=%~dp0"
set "TASK_NAME=MinecraftAutoStart"
set "TASK_CMD=%BASE_DIR%auto_start.bat"
set "DESCRIPTION=Auto start Minecraft server on boot"

echo Installing scheduled task %TASK_NAME% ...
schtasks /Create /SC ONSTART /TN "%TASK_NAME%" /TR "\"%TASK_CMD%\"" /RL HIGHEST /F >nul 2>&1
if %ERRORLEVEL% neq 0 (
  echo Failed to create scheduled task. Try running this script as Administrator.
  exit /b 1
)
echo Scheduled task created.
echo To verify: schtasks /Query /TN "%TASK_NAME%"
endlocal
