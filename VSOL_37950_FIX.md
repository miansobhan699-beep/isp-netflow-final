# VSOL 37950 SNMP fix

This build detects VSOL firmware using enterprise 37950 and reads the VSOL/BDCOM enterprise ONU/PON tables. It keeps the generic 3320 reader as fallback.

Configured test OLT: 192.168.8.100 / UDP 161 / SNMP v2c / public.

Use `START_ADAPTER.bat`, then open `http://127.0.0.1:8080/`.

## V49.1 discovery update

The adapter now tries the newer `37950.1.1.6` ONU branch first and falls back to the documented V1600D authorization table at `37950.1.1.5.12.1.25.1`, whose row index is `{PON, ONU}`. It also reads the legacy per-PON registered/online counters under `37950.1.1.5.12.1.27.1.2` and `.1.3` when exposed. Optical power values returned as OCTET STRING are parsed as decimal dBm instead of being discarded.

The SNMP Diagnostic endpoint additionally reports a discovery summary and sample ONU rows.
