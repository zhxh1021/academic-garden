@echo off
rem DEPRECATED WEB RUNTIME: historical browser launcher only.
rem Active product work has moved to godot-prototype.
cd /d "%~dp0"
where py >nul 2>nul
if %errorlevel%==0 (
  py -3 "%~dp0scripts\open_local.py"
) else (
  python "%~dp0scripts\open_local.py"
)
if errorlevel 1 (
  pause
  exit /b 1
)
