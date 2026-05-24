@echo off
REM Run the correct server start script based on server_settings.env
setlocal enabledelayedexpansion
if exist "server_settings.env" (
  for /f "usebackq tokens=1,* delims==" %%A in ("server_settings.env") do (
    if not "%%B"=="" set "%%A=%%B"
  )
)

if /i "%SERVER_TYPE%"=="modded" (
  echo Running modded server...
  call modded_start.bat
) else (
  echo Running plugin/server jar server...
  call start.bat
)
endlocal
