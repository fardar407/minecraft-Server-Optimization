@echo off
REM Send alert notifications via Slack and/or email on Windows
setlocal enabledelayedexpansion
set "BASE_DIR=%~dp0"
set "SETTINGS=%BASE_DIR%alert_settings.env"
if exist "%SETTINGS%" (
  for /f "usebackq tokens=1,* delims==" %%A in ("%SETTINGS%") do (
    if not "%%B"=="" set "%%A=%%B"
  )
)
set "MESSAGE=%*"
if "%MESSAGE%"=="" (
  echo No alert message supplied.
  exit /b 1
)
if defined SLACK_WEBHOOK_URL (
  powershell -NoProfile -Command "$payload = @{text='%MESSAGE%'} | ConvertTo-Json; Invoke-RestMethod -Uri '%SLACK_WEBHOOK_URL%' -Method Post -ContentType 'application/json' -Body $payload" 2>nul || echo Slack alert failed.
)
if defined EMAIL_SMTP_SERVER (
  if defined EMAIL_TO (
    if defined EMAIL_FROM (
      if not defined EMAIL_SMTP_PORT set "EMAIL_SMTP_PORT=587"
      powershell -NoProfile -Command "$msg = New-Object System.Net.Mail.MailMessage; $msg.From = '%EMAIL_FROM%'; $msg.To.Add('%EMAIL_TO%'); $msg.Subject = 'Minecraft TPS Alert'; $msg.Body = '%MESSAGE%'; $smtp = New-Object System.Net.Mail.SmtpClient('%EMAIL_SMTP_SERVER%', %EMAIL_SMTP_PORT%); $smtp.EnableSsl = $true; $smtp.Credentials = New-Object System.Net.NetworkCredential('%EMAIL_USERNAME%', '%EMAIL_PASSWORD%'); $smtp.Send($msg)" 2>nul || echo Email alert failed.
    )
  )
)
endlocal
