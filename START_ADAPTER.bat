@echo off
setlocal EnableExtensions
cd /d "%~dp0"
set "ROOT=%~dp0"
set "ADAPTER=%ROOT%adapter"
set "REQ=%ADAPTER%\requirements.txt"
set "VENV=%ROOT%.adapter-venv"
set "PY=py -3.13"

rem Always use Python 3.13 for this adapter. If an old venv was made with another
rem Python version, remove it and recreate it with the selected interpreter.

echo ==================================================
echo NetFlow ISP - Monitoring Adapter
echo ==================================================
echo.

echo [1/4] Checking Python...
%PY% --version >nul 2>&1
if errorlevel 1 (
  echo ERROR: Python was not found in PATH.
  echo Install Python 3.13 from https://www.python.org/downloads/windows/
  echo Make sure Python 3.13 is installed.
  pause
  exit /b 1
)
%PY% --version

echo.
echo [2/4] Checking project files...
if not exist "%REQ%" (
  echo ERROR: requirements.txt was not found:
  echo %REQ%
  echo.
  echo Extract the COMPLETE ZIP to a normal Windows folder first.
  echo Do NOT run this file from inside WinRAR.
  pause
  exit /b 1
)
if not exist "%ADAPTER%\app.py" (
  echo ERROR: adapter\app.py was not found.
  pause
  exit /b 1
)

echo requirements.txt: OK
echo adapter\app.py: OK

echo.
echo [3/4] Preparing local Python environment...
if exist "%VENV%\Scripts\python.exe" (
  "%VENV%\Scripts\python.exe" -c "import sys; raise SystemExit(0 if sys.version_info[:2] == (3,13) else 1)" >nul 2>&1
  if errorlevel 1 (
    echo Existing .adapter-venv is not Python 3.13. Recreating it...
    rmdir /s /q "%VENV%"
  )
)
if not exist "%VENV%\Scripts\python.exe" (
  echo Creating .adapter-venv with Python 3.13 ...
  %PY% -m venv "%VENV%"
  if errorlevel 1 (
    echo ERROR: Could not create the Python environment.
    pause
    exit /b 1
  )
)
set "VPY=%VENV%\Scripts\python.exe"

"%VPY%" -m pip install --disable-pip-version-check --upgrade pip
if errorlevel 1 (
  echo WARNING: pip upgrade failed. Continuing with installed pip...
)

"%VPY%" -m pip install --disable-pip-version-check -r "%REQ%"
if errorlevel 1 (
  echo.
  echo ERROR: Could not install adapter packages.
  echo Check your internet connection and try again.
  pause
  exit /b 1
)

echo.
echo [4/4] Starting adapter...
set "PORT=8080"
for /f "tokens=5" %%A in ('netstat -ano ^| findstr /R /C:":8080 .*LISTENING"') do set "PORT=8090"
if "%PORT%"=="8090" echo Port 8080 is busy. Using port 8090 instead.
if "%PORT%"=="8090" echo NOTE: If you opened the dashboard as file://, use the adapter URL shown in the black window (http://127.0.0.1:8090/).

echo.
echo Adapter URL: http://127.0.0.1:%PORT%/
echo Keep this black window OPEN while using live OLT monitoring.
echo.
start "NetFlow Adapter - Browser" "http://127.0.0.1:%PORT%/"
"%VPY%" -m uvicorn adapter.app:app --host 0.0.0.0 --port %PORT%

pause
