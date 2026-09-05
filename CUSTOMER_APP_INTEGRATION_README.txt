NETFLOW CUSTOMER APP — WEB CONNECTION

This update connects the Android Customer App to the existing NetFlow ISP web dashboard.

FLOW:
ISP Web Dashboard -> Supabase -> Android Customer App

1) SUPABASE SQL
Open Supabase Dashboard -> SQL Editor.
Run the existing ISP SQL setup first (if not already done), then run:
CUSTOMER_APP_SETUP.sql

2) DEPLOY EDGE FUNCTION
The folder is:
supabase/functions/customer-provision/

Deploy it as:
customer-provision

The function needs the normal Supabase project secrets available to Edge Functions, especially SUPABASE_SERVICE_ROLE_KEY. Never put that service-role key in the website or Android app.

3) CREATE CUSTOMER APP LOGIN FROM ISP WEB
Login to the ISP dashboard using an Owner/Admin/Manager/Billing account.
Open Customers -> Add/Edit Customer.
Fill:
- Username / ID
- App Password
- Service Expiry Date (optional but recommended)
- Customer App Message (optional)
Save.

The browser sends the password only to the server-side Edge Function. The password is not stored in the ISP browser database.

4) CUSTOMER APP LOGIN
Build/install the updated Android APK.
Use the same Username and App Password assigned in the ISP dashboard.

5) CUSTOMER APP DATA
The app reads the customer's own:
- name
- ISP/company
- username
- package
- speed/bandwidth
- monthly fee
- current bill
- due date
- expiry date
- payment history
- ISP messages

6) CUSTOMER APP MESSAGES
ISP dashboard -> Communications -> Customer App Messages.
Choose All Customers or one customer, write a message, and send it.
The app loads those messages after login/refresh.

SECURITY
- Customer passwords are managed by Supabase Auth through the server-side provisioning function.
- Customer app data is returned through a security-definer RPC and is scoped to the logged-in customer mapping.
- The Android app contains only the public/publishable Supabase key. Never put the service-role key in the Android app.
