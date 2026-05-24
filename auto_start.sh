#!/bin/bash
# Minecraft auto-start wrapper for Ubuntu/Linux with safe restart throttling
set -e
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"

RESTART_COUNT=0
MAX_RESTARTS=5
RESTART_WINDOW=600
WINDOW_START=0

while true; do
  NOW=$(date +%s)
  if [ "$WINDOW_START" -eq 0 ]; then
    WINDOW_START=$NOW
  fi

  if [ "$RESTART_COUNT" -ge "$MAX_RESTARTS" ] && [ $((NOW - WINDOW_START)) -lt "$RESTART_WINDOW" ]; then
    echo "Too many restarts in a short period. Sleeping 120 seconds before retrying..."
    sleep 120
    RESTART_COUNT=0
    WINDOW_START=0
  fi

  echo "Starting Minecraft server at $(date)"
  ./run_server.sh
  RET=$?
  echo "Server exited with code $RET. Restarting in 10 seconds..."
  RESTART_COUNT=$((RESTART_COUNT + 1))
  sleep 10

done
