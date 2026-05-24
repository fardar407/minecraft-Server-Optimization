@echo off
REM Detect system specs and generate server_settings.env for Windows.
setlocal
set "OUT=server_settings.env"
if exist "%OUT%" del "%OUT%"

echo Detecting system specs...
for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "(Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory"`) do set "TOTAL_RAM_BYTES=%%A"
for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "[Environment]::ProcessorCount"`) do set "CPU_CORES=%%A"

if not defined TOTAL_RAM_BYTES (
  echo ERROR: Unable to detect RAM. Make sure PowerShell is available.
  exit /b 1
)
if not defined CPU_CORES (
  echo ERROR: Unable to detect CPU cores.
  exit /b 1
)

for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "[math]::Floor(%TOTAL_RAM_BYTES% / 1GB)"`) do set "TOTAL_RAM_GB=%%A"
if %TOTAL_RAM_GB% lss 1 set "TOTAL_RAM_GB=1"

if %TOTAL_RAM_GB% leq 16 (
  set "XMS=4G"
  set "XMX=6G"
) else if %TOTAL_RAM_GB% leq 24 (
  set "XMS=6G"
  set "XMX=8G"
) else if %TOTAL_RAM_GB% leq 32 (
  set "XMS=8G"
  set "XMX=10G"
) else (
  set "XMS=10G"
  set "XMX=12G"
)

set /a THREADS=%CPU_CORES% * 75 / 100
if %THREADS% lss 2 set /a THREADS=2
if %THREADS% gtr 8 set /a THREADS=8
set /a CONC_THREADS=%THREADS% / 2
if %CONC_THREADS% lss 2 set /a CONC_THREADS=2
set /a ACTIVE_CPUS=%CPU_CORES%
if %ACTIVE_CPUS% gtr 8 set /a ACTIVE_CPUS=8
if %ACTIVE_CPUS% lss 2 set /a ACTIVE_CPUS=2

echo XMS=%XMS%>"%OUT%"
echo XMX=%XMX%>>"%OUT%"
echo PARALLEL_GC_THREADS=%THREADS%>>"%OUT%"
echo CONCURRENT_GC_THREADS=%CONC_THREADS%>>"%OUT%"
echo ACTIVE_PROCESSORS=%ACTIVE_CPUS%>>"%OUT%"

echo Generated %OUT% with:
echo   Total RAM: %TOTAL_RAM_GB% GB
echo   CPU cores: %CPU_CORES%
echo   XMS=%XMS%
echo   XMX=%XMX%
echo   PARALLEL_GC_THREADS=%THREADS%
echo   CONCURRENT_GC_THREADS=%CONC_THREADS%
echo   ACTIVE_PROCESSORS=%ACTIVE_CPUS%
endlocal
