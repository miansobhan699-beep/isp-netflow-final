# WhatsApp → Pay Now → Auto-Paid

The dashboard now supports a payment-link flow:

1. Create an invoice.
2. Open **WhatsApp / SMS**.
3. Select the invoice and click **WhatsApp + Pay Link**.
4. The customer receives a unique Pay Now URL.
5. Configure a merchant checkout URL under **API Integrations**. Supported placeholders:
   - `{{invoice_id}}`
   - `{{invoice_no}}`
   - `{{amount}}`
   - `{{currency}}`
   - `{{customer_name}}`
   - `{{return_url}}`
6. The gateway sends a server-side webhook when payment succeeds.
7. The included Supabase Edge Function updates the central workspace and marks the invoice paid.

## Important

The included browser UI cannot securely hold a WhatsApp Business access token or a payment-gateway secret. For production, keep those credentials in a server/edge function.

The **Demo Payment** button is only for testing and does not charge money.

## Deploy the webhook

Install/use the Supabase CLI and deploy:

```bash
supabase functions deploy payment-webhook
```

The resulting webhook URL is:

`https://YOUR_PROJECT.supabase.co/functions/v1/payment-webhook`

Put that URL in **API Integrations → Webhook URL** and give the same URL to your payment gateway.

For production, add the gateway's signature verification inside `supabase/functions/payment-webhook/index.ts` before trusting the request.

## WhatsApp automation

The current dashboard opens a pre-filled WhatsApp chat via `wa.me`. Fully automatic outbound WhatsApp messages require the Meta WhatsApp Business Platform and a server-side access token. Configure that API in **API Integrations**, then move the actual send call into a server/edge function.
