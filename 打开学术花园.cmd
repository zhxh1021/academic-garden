@echo off
cd /d "%~dp0"
python "%~dp0scripts\open_local.py" --no-browser
if errorlevel 1 (
  pause
  exit /b 1
)
start "" "http://127.0.0.1:4173"
if errorlevel 1 (
  echo Cannot open the browser automatically. Please visit http://127.0.0.1:4173
  pause
)
