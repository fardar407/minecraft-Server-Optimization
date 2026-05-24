#!/bin/bash
# Minecraft auto-start wrapper for Ubuntu/Linux
set -e
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"

while true; do
  echo "Starting Minecraft server at $(date)"
  ./run_server.sh
  RET=$?
  echo "Server exited with code $RET. Restarting in 10 seconds..."
  sleep 10
done
