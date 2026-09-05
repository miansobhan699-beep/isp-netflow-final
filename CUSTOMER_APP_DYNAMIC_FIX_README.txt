NETFLOW CUSTOMER APP - DYNAMIC USER FIX
========================================

This patch fixes the customer-app provisioning flow so it is NOT tied to
rehan/xyz/testuser2/testuser3 or any single customer.

WHAT WAS FIXED
1. ISP Web now waits for the customer workspace to sync to Supabase before
   calling customer-provision.
2. customer-provision first uses the exact customer ID; if that ID is stale,
   it automatically finds the customer by username.
3. Old customer_app_accounts mappings are repaired to the real customer ID.
4. Existing Auth users are reused instead of creating duplicate customer logins.
5. The customer portal RPC also falls back to username when an old mapping has
   a stale customer ID.
6. The same logic works for future customers created from the ISP Web.

SUPABASE STEPS
--------------
A) SQL Editor:
   Run ISP/CUSTOMER_APP_DYNAMIC_FIX.sql once.

B) Edge Function:
   Deploy/redeploy:
   ISP/supabase/functions/customer-provision/index.ts
   as the existing function named "customer-provision".

C) ISP Web:
   Replace the old ISP/index.html with the patched ISP/index.html from this ZIP.
   If you deploy the whole ISP folder to your web host/GitHub, use the patched
   folder from this ZIP.

D) Test:
   1. Login to ISP Web.
   2. Add a NEW customer with a unique username and an app password.
   3. Save Customer.
   4. Wait for "Customer app login created/updated.".
   5. Open Customer Web and login with that username + password.

IMPORTANT
---------
The password is never stored in the ISP browser database. It is sent to the
server-side Edge Function, which manages the Supabase Auth password.

If a customer already has an old/stale mapping, simply edit/save that customer
once after deploying this patch; provisioning will repair the mapping.
