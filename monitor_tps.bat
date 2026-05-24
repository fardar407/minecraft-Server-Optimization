@echo off
REM Monitor TPS via log parsing on Windows and write alerts to tps_alerts.log
setlocal enabledelayedexpansion
set "BASE_DIR=%~dp0"
set "LOG_FILE=%BASE_DIR%logs\latest.log"
set "ALERT_LOG=%BASE_DIR%monitor\tps_alerts.log"
set "TIMESTAMP=%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "TIMESTAMP=%TIMESTAMP: =0%"
if not exist "%BASE_DIR%monitor" mkdir "%BASE_DIR%monitor"

echo [%TIMESTAMP%] Checking TPS alerts... >> "%ALERT_LOG%"
set "ALERT_FOUND=0"
for /f "delims=" %%L in ('powershell -NoProfile -Command "Get-Content -Path '%LOG_FILE%' -Tail 200 | Select-String -Pattern 'Can''t keep up|ms or .* ticks behind|TPS|mean tick time'"') do (
  set "ALERT_FOUND=1"
  echo [%TIMESTAMP%] %%L >> "%ALERT_LOG%"
)
if "%ALERT_FOUND%"=="1" (
  call "%BASE_DIR%\notify_alert.bat" "Minecraft TPS/lag alert detected at %TIMESTAMP%. See %ALERT_LOG% for details."
)
call "%BASE_DIR%\tps_report.bat" >nul 2>nul

echo Done. See %ALERT_LOG% for details.
endlocal
