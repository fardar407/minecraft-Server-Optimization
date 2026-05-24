@echo off
REM Minecraft Modded Server launcher for Windows with optimized JVM flags
setlocal enabledelayedexpansion
set JAR=modded.jar
set XMS=8G
set XMX=10G
set PARALLEL_GC_THREADS=8
set CONCURRENT_GC_THREADS=4
set ACTIVE_PROCESSORS=8

if exist "server_settings.env" (
  for /f "usebackq tokens=1,* delims==" %%A in ("server_settings.env") do (
    if not "%%B"=="" set "%%A=%%B"
  )
)
set JVM_OPTS=-XX:+UseG1GC -XX:MaxGCPauseMillis=40 -XX:+ParallelRefProcEnabled -XX:+ParallelGCThreads=%PARALLEL_GC_THREADS% -XX:ConcGCThreads=%CONCURRENT_GC_THREADS% -XX:ActiveProcessorCount=%ACTIVE_PROCESSORS% -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=14 -XX:G1MixedGCCountTarget=4 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:+UseStringDeduplication -XX:+OptimizeStringConcat -XX:+UseCompressedOops -XX:+UseFastAccessorMethods -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=heapdump.hprof

if not exist "%JAR%" (
  echo ERROR: %JAR% not found in this folder.
  echo Please place your modded server jar file here and update the file name if needed.
  pause
  exit /b 1
)
echo Starting modded Minecraft server with Xms=%XMS% Xmx=%XMX% and %ACTIVE_PROCESSORS% active processors...
java -Xms%XMS% -Xmx%XMX% %JVM_OPTS% -jar %JAR% nogui
echo Server stopped.
pause
endlocal
