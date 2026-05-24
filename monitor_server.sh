#!/bin/bash
# Monitor Minecraft server and restart if the configured port is closed
set -e
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"
SERVER_PORT=25565
JAR_NAME="paper.jar"
if [ -f server_settings.env ]; then
  source server_settings.env
fi
if [ -n "$SERVER_PORT" ]; then
  :
fi
if [ -n "$SERVER_JAR" ]; then
  JAR_NAME="$SERVER_JAR"
fi
if bash -c "</dev/tcp/127.0.0.1/$SERVER_PORT" >/dev/null 2>&1; then
  echo "Minecraft server is online on port $SERVER_PORT."
  exit 0
fi

echo "Minecraft server is not listening on port $SERVER_PORT. Restarting server..."
./auto_start.sh
