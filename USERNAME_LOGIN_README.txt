NETFLOW ISP V51

1. Run your existing Supabase SQL setup first.
2. Then run USERNAME_LOGIN_SETUP.sql in Supabase SQL Editor.
3. Existing accounts automatically get a username from the part before @ in their email.
   Example: miansobhan699@gmail.com -> username: miansobhan699
4. Website login now asks only Username + Password.
5. Passwords remain handled by Supabase Auth; they are not stored in the dashboard database.
6. For VSOL OLT monitoring, keep START_ADAPTER.bat running. The dashboard automatically detects adapter port 8080 or 8090.
7. Default OLT: 192.168.8.100, SNMP v2c, UDP 161, community public. Change it if your OLT uses another value.
