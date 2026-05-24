#!/bin/bash
# Optimized Paper/Purpur server launcher for Ubuntu/Linux with plugin and high-player support
set -e
JAR="paper.jar"
XMS="8G"
XMX="10G"
PARALLEL_GC_THREADS="8"
CONCURRENT_GC_THREADS="4"
ACTIVE_PROCESSORS="8"

if [ -f server_settings.env ]; then
  source server_settings.env
fi
if [ -n "$SERVER_JAR" ]; then
  JAR="$SERVER_JAR"
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
)
if [ -n "$JAVA_OPTS_EXTRA" ]; then
  read -r -a EXTRA_OPTS <<< "$JAVA_OPTS_EXTRA"
  JVM_OPTS+=( "${EXTRA_OPTS[@]}" )
fi

if [ ! -f "$JAR" ]; then
  echo "ERROR: $JAR not found in this folder."
  echo "Place your Paper or Purpur server jar here and rename it to $JAR or update this script."
  exit 1
fi

echo "Running optimized server with Xms=${XMS} Xmx=${XMX} and ${ACTIVE_PROCESSORS} active processors..."
exec java -Xms${XMS} -Xmx${XMX} "${JVM_OPTS[@]}" -jar "$JAR" nogui
