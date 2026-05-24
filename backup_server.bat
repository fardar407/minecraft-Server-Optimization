@echo off
REM Minecraft server backup script for Windows
setlocal enabledelayedexpansion
set "BASE_DIR=%~dp0"
set "BACKUP_DIR=%BASE_DIR%backups"
set "WORLD_DIR=%BASE_DIR%world"
set "TIMESTAMP=%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "TIMESTAMP=%TIMESTAMP: =0%"

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
set "TARGET=%BACKUP_DIR%\backup_%TIMESTAMP%"
mkdir "%TARGET%"

echo Backing up world and config to %TARGET% ...
xcopy "%WORLD_DIR%" "%TARGET%\world\" /E /H /C /I /Q
xcopy "%BASE_DIR%server.properties" "%TARGET%\" /Y >nul 2>&1
xcopy "%BASE_DIR%paper.yml" "%TARGET%\" /Y >nul 2>&1
xcopy "%BASE_DIR%spigot.yml" "%TARGET%\" /Y >nul 2>&1
xcopy "%BASE_DIR%bukkit.yml" "%TARGET%\" /Y >nul 2>&1
xcopy "%BASE_DIR%server_settings.env" "%TARGET%\" /Y >nul 2>&1
xcopy "%BASE_DIR%mods\*" "%TARGET%\mods\" /E /H /C /I /Q >nul 2>&1
xcopy "%BASE_DIR%plugins\*" "%TARGET%\plugins\" /E /H /C /I /Q >nul 2>&1

echo Backup complete.
echo Saved to %TARGET%
pause
endlocal
