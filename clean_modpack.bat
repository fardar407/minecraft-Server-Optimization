@echo off
REM Clean modpack folder by moving disabled, duplicate, and client-only mods to ignored.
setlocal enabledelayedexpansion
set "MODDIR=%~1"
if "%MODDIR%"=="" set "MODDIR=%~dp0mods"
if not exist "%MODDIR%\" (
  echo ERROR: folder "%MODDIR%" not found.
  exit /b 1
)
set "IGNORED=%MODDIR%\ignored"
if not exist "%IGNORED%" mkdir "%IGNORED%"
echo Cleaning mod folder: %MODDIR%
for %%F in ("%MODDIR%\*.jar" "%MODDIR%\*.jar.disabled") do (
  if exist "%%~F" (
    set "name=%%~nxF"
    set "moveit=0"
    if not "!name:.disabled=!"=="!name!" set "moveit=1"
    if not "!name:.duplicate=!"=="!name!" set "moveit=1"
    for %%P in (sodium sodiumdynamiclights cloth-config iris optifine canvas) do (
      if not "!name:%%P=!"=="!name!" set "moveit=1"
    )
    if "!moveit!"=="1" (
      echo Moving ignored mod: !name!
      move /Y "%%~F" "%IGNORED%\" >nul
    )
  )
)
echo Clean complete. Moved non-server mods to %IGNORED%.
endlocal
