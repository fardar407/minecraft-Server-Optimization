@echo off
REM Schedule daily backup task in Windows Task Scheduler
setlocal enabledelayedexpansion
set "TASK_NAME=MinecraftBackup"
set "BACKUP_SCRIPT=%~dp0backup_rotate.bat"
set "TIME=03:00"

necho Installing backup task %TASK_NAME% ...
schtasks /Create /SC DAILY /TN "%TASK_NAME%" /TR "\"%BACKUP_SCRIPT%\"" /ST %TIME% /RL HIGHEST /F >nul 2>&1
if %ERRORLEVEL% neq 0 (
  echo Failed to create backup task. Run this script as Administrator.
  exit /b 1
)
echo Backup task installed to run daily at %TIME%.
echo To verify: schtasks /Query /TN "%TASK_NAME%"
pause
endlocal
