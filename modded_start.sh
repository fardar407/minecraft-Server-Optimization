#!/bin/bash
# Minecraft Modded Server launcher for Ubuntu/Linux with optimized JVM flags
set -e
JAR="modded.jar"
XMS="8G"
XMX="10G"
PARALLEL_GC_THREADS="8"
CONCURRENT_GC_THREADS="4"
ACTIVE_PROCESSORS="8"

if [ -f server_settings.env ]; then
  source server_settings.env
fi

JVM_OPTS=(
  -XX:+UseG1GC
  -XX:MaxGCPauseMillis=40
  -XX:+ParallelRefProcEnabled
  -XX:+ParallelGCThreads=${PARALLEL_GC_THREADS}
  -XX:ConcGCThreads=${CONCURRENT_GC_THREADS}
  -XX:ActiveProcessorCount=${ACTIVE_PROCESSORS}
  -XX:+UnlockExperimentalVMOptions
  -XX:+DisableExplicitGC
  -XX:+AlwaysPreTouch
  -XX:G1NewSizePercent=30
  -XX:G1MaxNewSizePercent=40
  -XX:G1HeapRegionSize=8M
  -XX:G1ReservePercent=20
  -XX:InitiatingHeapOccupancyPercent=14
  -XX:G1MixedGCCountTarget=4
  -XX:SurvivorRatio=32
  -XX:+PerfDisableSharedMem
  -XX:+UseStringDeduplication
  -XX:+OptimizeStringConcat
  -XX:+UseCompressedOops
  -XX:+UseFastAccessorMethods
  -XX:+HeapDumpOnOutOfMemoryError
  -XX:+HeapDumpPath=heapdump.hprof
)

if [ ! -f "$JAR" ]; then
  echo "ERROR: $JAR not found in this folder."
  echo "Place your modded server jar here and update the file name if needed."
  exit 1
fi

echo "Starting modded Minecraft server with Xms=${XMS} Xmx=${XMX} and ${ACTIVE_PROCESSORS} active processors..."
exec java -Xms${XMS} -Xmx${XMX} "${JVM_OPTS[@]}" -jar "${JAR}" nogui
