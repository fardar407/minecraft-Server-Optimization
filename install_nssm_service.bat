@echo off
REM Install Minecraft server as Windows service using NSSM
setlocal enabledelayedexpansion
set "BASE_DIR=%~dp0"
set "NSSM=%BASE_DIR%nssm.exe"
if not exist "%NSSM%" (
  for /f "delims=" %%P in ('where nssm 2^>nul') do set "NSSM=%%P"
)
if not exist "%NSSM%" (
  echo ERROR: nssm.exe not found in current folder or PATH.
  echo Download NSSM from https://nssm.cc/download and place nssm.exe in this folder.
  pause
  exit /b 1
)
set "SERVICE_NAME=MinecraftServer"
set "SERVICE_DISPLAY=Minecraft Server"
set "SERVICE_DIR=%BASE_DIR:~0,-1%"
set "SERVICE_LOG=%SERVICE_DIR%\logs\nssm_service.log"
set "APP=%BASE_DIR%auto_start.bat"

necho Installing NSSM service %SERVICE_NAME% ...
"%NSSM%" install "%SERVICE_NAME%" "%APP%"
"%NSSM%" set "%SERVICE_NAME%" AppDirectory "%BASE_DIR%"
"%NSSM%" set "%SERVICE_NAME%" DisplayName "%SERVICE_DISPLAY%"
"%NSSM%" set "%SERVICE_NAME%" Start SERVICE_AUTO_START
"%NSSM%" set "%SERVICE_NAME%" AppStdout "%SERVICE_DIR%\logs\nssm_stdout.log"
"%NSSM%" set "%SERVICE_NAME%" AppStderr "%SERVICE_DIR%\logs\nssm_stderr.log"
"%NSSM%" set "%SERVICE_NAME%" AppRestartDelay 5000
"%NSSM%" set "%SERVICE_NAME%" AppRotateFiles 1

necho Starting service...
"%NSSM%" start "%SERVICE_NAME%"
echo NSSM service installed and started. Check logs in %SERVICE_DIR%\logs
pause
endlocal
