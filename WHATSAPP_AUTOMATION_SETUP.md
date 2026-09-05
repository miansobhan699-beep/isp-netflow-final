# Automatic WhatsApp + EasyPaisa + JazzCash setup

## 1. WhatsApp automatic mass sending

The dashboard now has **WhatsApp / SMS -> Mass Automatic WhatsApp**.
It sends one approved WhatsApp template per outstanding invoice through the included Supabase Edge Function.

Deploy:

```bash
supabase functions deploy whatsapp-send
```

Set secrets in Supabase:

```bash
supabase secrets set WHATSAPP_ACCESS_TOKEN=YOUR_META_TOKEN
supabase secrets set WHATSAPP_PHONE_NUMBER_ID=YOUR_PHONE_NUMBER_ID
supabase secrets set WHATSAPP_API_BASE=https://graph.facebook.com/v23.0
```

Create an approved WhatsApp template with 4 body variables:

1. customer name
2. invoice number
3. amount
4. payment link

Example body:

`Assalam-o-Alaikum {{1}}, your ISP invoice {{2}} of PKR {{3}} is due. Pay securely: {{4}}`

Then put the template name/language and the Edge Function URL in **API Integrations -> WhatsApp Business API**.

The access token is intentionally NOT stored in the browser.

## 2. EasyPaisa

The dashboard has an EasyPaisa merchant section. Enter the live checkout/API endpoint and merchant values issued to your business after onboarding.

Official merchant onboarding and integration guides:
https://registerbusiness.easypaisa.com.pk/
https://easypay.easypaisa.com.pk/easypay-merchant/faces/pg/site/IntegrationGuides.jsf

The customer payment page can show an **EasyPaisa** button once enabled and a checkout URL is configured.

## 3. JazzCash

The dashboard has a JazzCash merchant section with Merchant ID, Password, Integrity Salt, checkout URL and webhook URL.

Official gateway documentation:
https://www.jazzcash.com.pk/accept-payments/payment-gateway
https://payments.jazzcash.com.pk/SandboxDocumentation/Content/documentation/Payment%20Gateway%20Integration%20Guide%20for%20Merchants-v4.2.pdf

JazzCash secure-hash/integrity values must remain server-side for a production implementation.

## 4. Auto-paid webhook

Use the existing Supabase payment webhook:

```bash
supabase functions deploy payment-webhook
```

The live gateway must call it only after verifying the provider's signed callback. Do not mark an invoice paid from an unverified browser request.

## 5. Recommended production flow

Invoice -> Supabase public payment record -> WhatsApp approved template -> customer clicks Pay Now -> EasyPaisa/JazzCash checkout -> signed webhook -> invoice marked PAID -> receipt/confirmation WhatsApp template.
