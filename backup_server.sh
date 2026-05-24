#!/bin/bash
# Minecraft server backup script for Ubuntu/Linux
set -e
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$BASE_DIR/backups"
WORLD_DIR="$BASE_DIR/world"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TARGET="$BACKUP_DIR/backup_$TIMESTAMP"

mkdir -p "$TARGET"

echo "Backing up world and config to $TARGET ..."
cp -r "$WORLD_DIR" "$TARGET/world"
cp -n "$BASE_DIR/server.properties" "$TARGET/" 2>/dev/null || true
cp -n "$BASE_DIR/paper.yml" "$TARGET/" 2>/dev/null || true
cp -n "$BASE_DIR/spigot.yml" "$TARGET/" 2>/dev/null || true
cp -n "$BASE_DIR/bukkit.yml" "$TARGET/" 2>/dev/null || true
cp -n "$BASE_DIR/server_settings.env" "$TARGET/" 2>/dev/null || true
if [ -d "$BASE_DIR/mods" ]; then
  mkdir -p "$TARGET/mods"
  cp -r "$BASE_DIR/mods"/* "$TARGET/mods/" 2>/dev/null || true
fi
if [ -d "$BASE_DIR/plugins" ]; then
  mkdir -p "$TARGET/plugins"
  cp -r "$BASE_DIR/plugins"/* "$TARGET/plugins/" 2>/dev/null || true
fi

echo "Backup complete. Saved to $TARGET"
