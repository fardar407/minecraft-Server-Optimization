#!/bin/bash
# Run the correct server start script based on server_settings.env
set -e
if [ -f server_settings.env ]; then
  source server_settings.env
fi

if [ "${SERVER_TYPE,,}" = "modded" ]; then
  echo "Running modded server..."
  ./modded_start.sh
else
  echo "Running plugin/server jar server..."
  ./start.sh
fi
