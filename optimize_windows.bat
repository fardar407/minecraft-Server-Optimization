@echo off
REM Windows optimizations for Minecraft server host
setlocal enabledelayedexpansion
echo Applying Windows performance settings...
powercfg /setactive SCHEME_MIN
powershell -NoProfile -Command "Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' | Select-Object PagingFiles"
echo If you want to tune pagefile settings, configure Windows Virtual Memory manually.
echo Done. Please reboot if required.
endlocal
