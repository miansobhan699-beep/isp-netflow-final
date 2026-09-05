@echo off
setlocal
cd /d "%~dp0"
set "VENV=%~dp0.adapter-venv"
set "VPY=%VENV%\Scripts\python.exe"
if not exist "%VPY%" (
  echo Adapter environment not found.
  echo Run START_ADAPTER.bat first and keep it open.
  pause
  exit /b 1
)
echo ================================================
echo NetFlow - Public OLT SNMP Test
echo Target: 38.68.84.52:161/UDP
echo Community: public (read-only)
echo ================================================
echo.
"%VPY%" -c "import asyncio,sys; sys.path.insert(0,'.'); from adapter.app import collect_olt; cfg={'id':'main-olt','name':'Main OLT','model':'EPON OLT V1.1.4E / V1.0.2R','host':'38.68.84.52','snmp_port':161,'snmp_version':'2c','community':'public','timeout':3.0,'retries':2}; print(asyncio.run(collect_olt(cfg)))"
echo.
echo If status is ONLINE, NAT is reaching the SNMP endpoint.
pause
