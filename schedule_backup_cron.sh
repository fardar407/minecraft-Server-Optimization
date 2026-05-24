#!/bin/bash
# Setup cron job for daily Minecraft backup on Ubuntu/Linux
set -e
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
CRON_CMD="$BASE_DIR/backup_rotate.sh"
CRON_SCHEDULE="0 3 * * *"
LINE="$CRON_SCHEDULE $CRON_CMD >> $BASE_DIR/cron_backup.log 2>&1"

(crontab -l 2>/dev/null | grep -v -F "$CRON_CMD" || true; echo "$LINE") | crontab -

echo "Backup cron job installed: $LINE"
