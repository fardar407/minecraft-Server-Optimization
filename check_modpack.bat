@echo off
REM Check a modpack folder for compatibility issues, duplicates, and heavy mods.
setlocal enabledelayedexpansion
set "MODDIR=%~1"
if "%MODDIR%"=="" set "MODDIR=mods"
if not exist "%MODDIR%\" (
  echo ERROR: folder "%MODDIR%" not found.
  echo Usage: check_modpack.bat mods
  exit /b 1
)

echo Checking modpack in "%MODDIR%" ...
set /a total=0
set /a disabled=0
set /a duplicates=0
set /a heavy=0
set /a perf=0
set /a fabric=0
set /a forge=0
set /a client_only=0
set "warnings="

for %%F in ("%MODDIR%\*.jar" "%MODDIR%\*.jar.disabled") do (
  if exist "%%~F" (
    set "name=%%~nxF"
    set /a total+=1
    if not "!name:.disabled=!"=="!name!" set /a disabled+=1
    if not "!name:.duplicate=!"=="!name!" (
      set /a duplicates+=1
      echo WARNING: duplicate file detected: !name!
    )
    if not "!name:fabric=!"=="!name!" set /a fabric=1
    if not "!name:forge=!"=="!name!" set /a forge=1
    if not "!name:oak=!"=="!name!" (
      rem placeholder
    )
    for %%P in (sodium sodiumdynamiclights iris fabric-api cloth-config optifine canvas) do (
      if not "!name:%%P=!"=="!name!" (
        set /a client_only+=1
        echo WARNING: client-only or renderer mod found: !name!
      )
    )
    for %%H in (CustomNPCs Immersive Vehicles Epic Fight Waystones Blood N' Particles) do (
      if not "!name:%%H=!"=="!name!" (
        set /a heavy+=1
        echo INFO: heavy mod candidate: !name!
      )
    )
    for %%M in (ferritecore spark Chunky entityculling phosphor Phosphor) do (
      if not "!name:%%M=!"=="!name!" set /a perf=1
    )
  )
)

echo.
echo Total mod files found: %total%
echo Disabled mods: %disabled%
echo Duplicate marker files: %duplicates%
if %fabric% equ 1 echo WARNING: Fabric mod files detected.
if %forge% equ 1 echo WARNING: Forge mod files detected.
if %fabric% equ 1 if %forge% equ 1 echo WARNING: mixed Fabric and Forge files may not work together.
if %client_only% gtr 0 echo WARNING: %client_only% candidate client-only mods detected.
if %heavy% gtr 0 echo INFO: %heavy% heavy mod candidates detected.
if %perf% equ 1 (
  echo INFO: performance mods found (good).
) else (
  echo WARNING: no core performance mods detected. Add FerriteCore, Phosphor, Chunky, or Spark.
)
echo.
echo Recommendations:
echo - Remove disabled and duplicate files before deploying.
echo - Use only the correct loader: Forge or Fabric, not both.
echo - Keep server install clean: server-side mods only.
echo - Run this check again after cleaning.
endlocal
