@echo off
REM Optimized Paper/Purpur server launcher for Windows with plugin and high-player support
setlocal enabledelayedexpansion
set "JAR=paper.jar"
set "XMS=8G"
set "XMX=10G"
set "PARALLEL_GC_THREADS=8"
set "CONCURRENT_GC_THREADS=4"
set "ACTIVE_PROCESSORS=8"

if exist "server_settings.env" (
  for /f "usebackq tokens=1,* delims==" %%A in ("server_settings.env") do (
    if not "%%B"=="" set "%%A=%%B"
  )
)
if defined SERVER_JAR set "JAR=%SERVER_JAR%"

set JVM_OPTS=-XX:+UseG1GC -XX:MaxGCPauseMillis=40 -XX:+ParallelRefProcEnabled -XX:+ParallelGCThreads=%PARALLEL_GC_THREADS% -XX:ConcGCThreads=%CONCURRENT_GC_THREADS% -XX:ActiveProcessorCount=%ACTIVE_PROCESSORS% -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=14 -XX:G1MixedGCCountTarget=4 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:+UseStringDeduplication -XX:+OptimizeStringConcat -XX:+UseCompressedOops -XX:+UseFastAccessorMethods
if defined JAVA_OPTS_EXTRA set "JVM_OPTS=%JVM_OPTS% %JAVA_OPTS_EXTRA%"

if not exist "%JAR%" (
  echo ERROR: %JAR% not found in this folder.
  echo Place your Paper or Purpur server jar here and rename it to %JAR% or update this script.
  pause
  exit /b 1
)
echo Running optimized server with Xms=%XMS% Xmx=%XMX% and %ACTIVE_PROCESSORS% active processors...
java -Xms%XMS% -Xmx%XMX% %JVM_OPTS% -jar %JAR% nogui
echo Server stopped.
pause
endlocal
