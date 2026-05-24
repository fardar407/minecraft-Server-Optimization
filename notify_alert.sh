#!/bin/bash
# Send alert notifications via Slack and/or email
set -e
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
SETTINGS_FILE="$BASE_DIR/alert_settings.env"
if [ -f "$SETTINGS_FILE" ]; then
  source "$SETTINGS_FILE"
fi

if [ -z "$SLACK_WEBHOOK_URL" ] && [ -z "$EMAIL_SMTP_SERVER" ]; then
  echo "No alert destination configured. Set SLACK_WEBHOOK_URL or EMAIL_SMTP_SERVER in alert_settings.env."
  exit 0
fi

if [ -z "$EMAIL_SMTP_PORT" ]; then
  EMAIL_SMTP_PORT=587
fi

MESSAGE="$*"
if [ -z "$MESSAGE" ]; then
  echo "No alert message supplied."
  exit 1
fi

send_slack() {
  if [ -n "$SLACK_WEBHOOK_URL" ]; then
    payload=$(printf '{"text": "%s"}' "$(echo "$MESSAGE" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))')")
    curl -s -X POST -H 'Content-type: application/json' --data "$payload" "$SLACK_WEBHOOK_URL" >/dev/null 2>&1 || true
  fi
}

send_email() {
  if [ -n "$EMAIL_SMTP_SERVER" ] && [ -n "$EMAIL_TO" ] && [ -n "$EMAIL_FROM" ]; then
    if command -v python3 >/dev/null 2>&1; then
      python3 - <<PYTHON
import smtplib
import ssl
from email.message import EmailMessage
msg = EmailMessage()
msg['Subject'] = 'Minecraft TPS Alert'
msg['From'] = '$EMAIL_FROM'
msg['To'] = '$EMAIL_TO'
msg.set_content('''$MESSAGE''')
context = ssl.create_default_context()
server = smtplib.SMTP('$EMAIL_SMTP_SERVER', $EMAIL_SMTP_PORT)
server.starttls(context=context)
server.login('$EMAIL_USERNAME', '$EMAIL_PASSWORD')
server.send_message(msg)
server.quit()
PYTHON
    else
      echo "Python3 required for email alert."
    fi
  fi
}

send_slack
send_email
