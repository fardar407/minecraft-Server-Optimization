#!/bin/bash
# Detect system specs and generate server_settings.env for Ubuntu/Linux.
set -e
MODDIR="$(pwd)"
OUT_FILE="server_settings.env"

if [ -f "$OUT_FILE" ]; then
  rm -f "$OUT_FILE"
fi

if [ -r /proc/meminfo ]; then
  total_kb=$(grep -i '^MemTotal:' /proc/meminfo | awk '{print $2}')
  total_gb=$(( (total_kb + 1024*1024 - 1) / (1024*1024) ))
else
  echo "ERROR: Cannot read /proc/meminfo"
  exit 1
fi

if ! command -v nproc >/dev/null 2>&1; then
  echo "ERROR: nproc command not available"
  exit 1
fi

cpu_cores=$(nproc)
if [ "$total_gb" -le 16 ]; then
  XMS="4G"
  XMX="6G"
elif [ "$total_gb" -le 24 ]; then
  XMS="6G"
  XMX="8G"
elif [ "$total_gb" -le 32 ]; then
  XMS="8G"
  XMX="10G"
else
  XMS="10G"
  XMX="12G"
fi

threads=$(( cpu_cores * 75 / 100 ))
if [ "$threads" -lt 2 ]; then
  threads=2
fi
if [ "$threads" -gt 8 ]; then
  threads=8
fi
conc_threads=$(( threads / 2 ))
if [ "$conc_threads" -lt 2 ]; then
  conc_threads=2
fi
active_processors=$cpu_cores
if [ "$active_processors" -gt 8 ]; then
  active_processors=8
fi
if [ "$active_processors" -lt 2 ]; then
  active_processors=2
fi

cat > "$OUT_FILE" <<EOF
XMS=$XMS
XMX=$XMX
PARALLEL_GC_THREADS=$threads
CONCURRENT_GC_THREADS=$conc_threads
ACTIVE_PROCESSORS=$active_processors
EOF

echo "Generated $OUT_FILE with:"
echo "  Total RAM: ${total_gb} GB"
echo "  CPU cores: ${cpu_cores}"
echo "  XMS=$XMS"
echo "  XMX=$XMX"
echo "  PARALLEL_GC_THREADS=$threads"
echo "  CONCURRENT_GC_THREADS=$conc_threads"
echo "  ACTIVE_PROCESSORS=$active_processors"
