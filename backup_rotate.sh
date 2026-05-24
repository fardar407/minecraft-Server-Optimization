#!/bin/bash
# Backup, compress and rotate Minecraft server backups on Ubuntu/Linux
set -e
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$BASE_DIR/backups"
WORLD_DIR="$BASE_DIR/world"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ZIPFILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"
KEEP=5

mkdir -p "$BACKUP_DIR"

echo "Backing up world and config to temporary folder..."
TMPDIR=$(mktemp -d)
cp -r "$WORLD_DIR" "$TMPDIR/world"
cp -n "$BASE_DIR/server.properties" "$TMPDIR/" 2>/dev/null || true
cp -n "$BASE_DIR/paper.yml" "$TMPDIR/" 2>/dev/null || true
cp -n "$BASE_DIR/spigot.yml" "$TMPDIR/" 2>/dev/null || true
cp -n "$BASE_DIR/bukkit.yml" "$TMPDIR/" 2>/dev/null || true
cp -n "$BASE_DIR/server_settings.env" "$TMPDIR/" 2>/dev/null || true
if [ -d "$BASE_DIR/mods" ]; then
  cp -r "$BASE_DIR/mods" "$TMPDIR/" 2>/dev/null || true
fi
if [ -d "$BASE_DIR/plugins" ]; then
  cp -r "$BASE_DIR/plugins" "$TMPDIR/" 2>/dev/null || true
fi

echo "Compressing backup to $ZIPFILE ..."
tar -czf "$ZIPFILE" -C "$TMPDIR" .
rm -rf "$TMPDIR"

echo "Rotating old backups (keep $KEEP)..."
find "$BACKUP_DIR" -maxdepth 1 -name 'backup_*.tar.gz' -type f | sort -r | tail -n +$((KEEP + 1)) | xargs -r rm -f

echo "Backup complete: $ZIPFILE"
