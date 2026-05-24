#!/bin/bash
# Monitor TPS via log parsing on Ubuntu/Linux and write alerts to monitor/tps_alerts.log
set -e
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="$BASE_DIR/logs/latest.log"
ALERT_DIR="$BASE_DIR/monitor"
ALERT_LOG="$ALERT_DIR/tps_alerts.log"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mkdir -p "$ALERT_DIR"

echo "[$TIMESTAMP] Checking TPS alerts..." >> "$ALERT_LOG"
if [ -f "$LOG_FILE" ]; then
  ALERT_LINES=$(grep -E "Can't keep up|ms or .* ticks behind|TPS|mean tick time" "$LOG_FILE" | tail -n 200 || true)
  if [ -n "$ALERT_LINES" ]; then
    while read -r line; do
      echo "[$TIMESTAMP] $line" >> "$ALERT_LOG"
    done <<< "$ALERT_LINES"
    "$BASE_DIR/notify_alert.sh" "Minecraft TPS/lag alert detected at $TIMESTAMP. See $ALERT_LOG for details."
  fi
  "$BASE_DIR/tps_report.sh" >/dev/null 2>&1 || true
else
  echo "[$TIMESTAMP] ERROR: log file not found: $LOG_FILE" >> "$ALERT_LOG"
fi

echo "Done. See $ALERT_LOG for details."
