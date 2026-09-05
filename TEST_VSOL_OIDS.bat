@echo off
setlocal
set OLT_IP=192.168.8.100
set ADAPTER=http://127.0.0.1:8080

echo ================================================
echo NetFlow ISP - VSOL SNMP OID Diagnostic
echo OLT: %OLT_IP%
echo Adapter: %ADAPTER%
echo ================================================
echo.
echo This test is read-only. It does not change OLT settings.
echo.
curl -s "%ADAPTER%/api/health"
echo.
echo.
echo Now run the adapter page and open:
echo %ADAPTER%/api/olts/main-olt/snmp-debug
echo.
echo If your OLT id is different, replace main-olt with that id.
pause
