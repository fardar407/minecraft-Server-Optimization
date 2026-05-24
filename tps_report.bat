@echo off
REM Generate TPS report CSV and HTML from Minecraft latest.log on Windows
setlocal enabledelayedexpansion
set "BASE_DIR=%~dp0"
set "LOG_FILE=%BASE_DIR%logs\latest.log"
set "REPORT_DIR=%BASE_DIR%monitor"
set "CSV_FILE=%REPORT_DIR%\tps_report.csv"
set "HTML_FILE=%REPORT_DIR%\tps_report.html"
if not exist "%REPORT_DIR%" mkdir "%REPORT_DIR%"
if not exist "%LOG_FILE%" (
  echo Log file not found: %LOG_FILE%
  exit /b 1
)
echo timestamp,type,message>"%CSV_FILE%"
for /f "usebackq delims=" %%L in (`powershell -NoProfile -Command "Get-Content -Path '%LOG_FILE%' -Tail 500 | Select-String -Pattern 'Can''t keep up|ms or .* ticks behind|TPS|mean tick time'"`) do (
  set "line=%%L"
  for /f "tokens=1 delims=[]" %%A in ("%%L") do set "ts=%%A"
  if "!line!"=="" set "ts=%time%"
  set "type=other"
  echo !line! | findstr /c:"Can't keep up" >nul && set "type=cant_keep_up"
  echo !line! | findstr /c:"ms or" >nul && set "type=lag_tick_behind"
  echo !line! | findstr /i /c:"mean tick time" >nul && set "type=mean_tick_time"
  echo !line! | findstr /i /c:"TPS" >nul && set "type=tps"
  set "msg=!line:"=""!"
  echo !ts!,!type!,"!msg!">>"%CSV_FILE%"
)
(
  echo ^<!DOCTYPE html^>
  echo ^<html lang="en"^>
  echo ^<head^>^<meta charset="UTF-8"^>^<title^>Minecraft TPS Report^</title^>
  echo ^<style^>body{font-family:Arial,sans-serif;}table{border-collapse:collapse;width:100%;}th,td{border:1px solid #ccc;padding:8px;text-align:left;}th{background:#f4f4f4;}^</style^>
  echo ^</head^>
  echo ^<body^>
  echo ^<h1^>Minecraft TPS Report^</h1^>
  echo ^<p^>Generated: %DATE% %TIME%^</p^>
  echo ^<table^>
  echo ^<tr^>^<th^>Time^</th^>^<th^>Type^</th^>^<th^>Message^</th^>^</tr^>
) > "%HTML_FILE%"
for /f "usebackq tokens=1,2* delims=," %%A in ("%CSV_FILE%") do (
  if "%%A"=="timestamp" goto :skip
  echo ^<tr^>^<td^>%%A^</td^>^<td^>%%B^</td^>^<td^>%%C^</td^>^</tr^> >> "%HTML_FILE%"
  :skip
)
(
  echo ^</table^>
  echo ^</body^>
  echo ^</html^>
) >> "%HTML_FILE%"
echo TPS report generated: %CSV_FILE% and %HTML_FILE%
endlocal
