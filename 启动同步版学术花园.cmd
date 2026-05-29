@echo off
cd /d "%~dp0"
echo Starting Academic Garden sync server...
echo.
echo First time setup:
echo 1. Copy .env.example to .env
echo 2. Change ACADEMIC_GARDEN_PASSWORD in .env
echo.
echo After the server starts, open:
echo http://127.0.0.1:8787
echo.
echo Keep this window open while using the sync version.
echo Press Ctrl+C in this window to stop it.
echo.
node server\server.mjs
if errorlevel 1 pause
