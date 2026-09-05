@echo off
setlocal
cd /d "%~dp0"
echo ================================================
echo NetFlow ISP - VSOL LAN/SNMP Test
echo ================================================
echo OLT: 192.168.8.100

echo.
echo [1] Testing OLT web reachability...
ping -n 1 192.168.8.100

echo.
echo [2] Testing local monitoring adapter on 8080/8090...
for %%P in (8080 8090) do (
  powershell -NoProfile -Command "$u='http://127.0.0.1:%%P/api/health'; try { $r=Invoke-WebRequest -UseBasicParsing -TimeoutSec 3 $u; Write-Host 'Adapter %%P:' $r.StatusCode } catch { Write-Host 'Adapter %%P: not reachable' }"
)

echo.
echo [3] If the adapter is online, testing real OLT telemetry...
for %%P in (8080 8090) do (
  powershell -NoProfile -Command "$u='http://127.0.0.1:%%P/api/olts/main-olt/live?refresh=true'; try { $r=Invoke-WebRequest -UseBasicParsing -TimeoutSec 15 $u; Write-Host 'Adapter %%P response:'; Write-Host $r.Content } catch { Write-Host 'Adapter %%P telemetry test failed:' $_.Exception.Message }"
)
echo.
echo If telemetry says OFFLINE/timeout, verify OLT SNMP V2c is enabled, community is public, and UDP/161 is reachable from this laptop.
pause
