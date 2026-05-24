#!/bin/bash
# Generate CSV and HTML TPS report from Minecraft latest.log
set -e
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="$BASE_DIR/logs/latest.log"
REPORT_DIR="$BASE_DIR/monitor"
CSV_FILE="$REPORT_DIR/tps_report.csv"
HTML_FILE="$REPORT_DIR/tps_report.html"

mkdir -p "$REPORT_DIR"

echo "timestamp,type,message" > "$CSV_FILE"

if [ ! -f "$LOG_FILE" ]; then
  echo "Log file not found: $LOG_FILE"
  exit 1
fi

grep -E "Can't keep up|ms or .* ticks behind|TPS|mean tick time" "$LOG_FILE" | tail -n 500 | while IFS= read -r line; do
  time=$(echo "$line" | sed -n 's/^\[\([0-9:]*\)\].*/\1/p')
  if [[ -z "$time" ]]; then
    time="$(date +%H:%M:%S)"
  fi
  if [[ "$line" == *"Can't keep up"* ]]; then
    type="cant_keep_up"
  elif [[ "$line" == *"ms or"*"ticks behind"* ]]; then
    type="lag_tick_behind"
  elif [[ "$line" == *"mean tick time"* ]]; then
    type="mean_tick_time"
  elif [[ "$line" == *"TPS"* ]]; then
    type="tps"
  else
    type="other"
  fi
  message=$(echo "$line" | sed 's/"/""/g')
  printf '%s,%s,"%s"\n' "$time" "$type" "$message" >> "$CSV_FILE"
done

cat > "$HTML_FILE" <<EOF
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Minecraft TPS Report</title>
<style>body{font-family:Arial,sans-serif;}table{border-collapse:collapse;width:100%;}th,td{border:1px solid #ccc;padding:8px;text-align:left;}th{background:#f4f4f4;}</style>
</head>
<body>
<h1>Minecraft TPS Report</h1>
<p>Generated: $(date)</p>
<table>
<tr><th>Time</th><th>Type</th><th>Message</th></tr>
EOF

while IFS=, read -r timestamp type message; do
  if [ "$timestamp" = "timestamp" ]; then continue; fi
  printf '<tr><td>%s</td><td>%s</td><td>%s</td></tr>\n' "$timestamp" "$type" "$message" >> "$HTML_FILE"
done < "$CSV_FILE"

echo "</table></body></html>" >> "$HTML_FILE"

echo "TPS report generated: $CSV_FILE and $HTML_FILE"
