@echo off
REM Backup, compress and rotate Minecraft server backups on Windows
setlocal enabledelayedexpansion
set "BASE_DIR=%~dp0"
set "BACKUP_DIR=%BASE_DIR%backups"
set "TIMESTAMP=%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "TIMESTAMP=%TIMESTAMP: =0%"
set "TARGET=%BACKUP_DIR%\backup_%TIMESTAMP%"
set "ZIPFILE=%BACKUP_DIR%\backup_%TIMESTAMP%.zip"
set "KEEP=5"

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
mkdir "%TARGET%"

echo Backing up world and config to %TARGET% ...
xcopy "%BASE_DIR%world" "%TARGET%\world\" /E /H /C /I /Q
xcopy "%BASE_DIR%server.properties" "%TARGET%\" /Y >nul 2>&1
xcopy "%BASE_DIR%paper.yml" "%TARGET%\" /Y >nul 2>&1
xcopy "%BASE_DIR%spigot.yml" "%TARGET%\" /Y >nul 2>&1
xcopy "%BASE_DIR%bukkit.yml" "%TARGET%\" /Y >nul 2>&1
xcopy "%BASE_DIR%server_settings.env" "%TARGET%\" /Y >nul 2>&1
if exist "%BASE_DIR%mods\" xcopy "%BASE_DIR%mods\*" "%TARGET%\mods\" /E /H /C /I /Q >nul 2>&1
if exist "%BASE_DIR%plugins\" xcopy "%BASE_DIR%plugins\*" "%TARGET%\plugins\" /E /H /C /I /Q >nul 2>&1

echo Compressing backup to %ZIPFILE% ...
powershell -NoProfile -Command "Compress-Archive -Path '%TARGET%\*' -DestinationPath '%ZIPFILE%' -Force"

echo Cleaning temporary backup folder...
rd /s /q "%TARGET%"

echo Rotating old backups, keeping last %KEEP% files...
set /a count=0
for /f "delims=" %%F in ('dir /b /o-d "%BACKUP_DIR%\backup_*.zip"') do (
  set /a count+=1
  if !count! gtr %KEEP% (
    echo Deleting old backup: %%F
    del "%BACKUP_DIR%\%%F"
  )
)

echo Backup complete: %ZIPFILE%
pause
endlocal
