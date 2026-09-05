-- NetFlow Customer App secure integration
-- Run this AFTER the existing ISP Supabase setup SQL.

create table if not exists public.customer_app_accounts (
  id uuid primary key default gen_random_uuid(),
  workspace_id uuid not null,
  customer_id text not null,
  auth_user_id uuid not null unique references auth.users(id) on delete cascade,
  username text not null,
  app_enabled boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(workspace_id, customer_id),
  unique(workspace_id, username)
);

create index if not exists customer_app_accounts_workspace_idx
  on public.customer_app_accounts(workspace_id);

create index if not exists customer_app_accounts_username_idx
  on public.customer_app_accounts(lower(username));

alter table public.customer_app_accounts enable row level security;

-- ISP staff do not get direct table access from the browser; provisioning is done
-- by the server-side Edge Function using the service-role key.
-- Customer data is returned only by the security-definer RPC below.

create or replace function public.customer_get_portal_data()
returns jsonb
language plpgsql
security definer
stable
set search_path = public
as $$
declare
  a public.customer_app_accounts;
  w jsonb;
  c jsonb;
  p jsonb;
  co jsonb;
  inv jsonb;
  pays jsonb;
  msgs jsonb;
  expiry_date text;
begin
  select * into a
  from public.customer_app_accounts
  where auth_user_id = auth.uid()
  limit 1;

  if a.id is null or not a.app_enabled then
    raise exception 'Customer app account is disabled';
  end if;

  select data into w
  from public.isp_workspaces
  where user_id = a.workspace_id;

  if w is null then raise exception 'ISP workspace not found'; end if;

  select value into c
  from jsonb_array_elements(coalesce(w->'customers','[]'::jsonb)) value
  where value->>'id' = a.customer_id
  limit 1;

  if c is null then raise exception 'Customer record not found'; end if;

  select value into p
  from jsonb_array_elements(coalesce(w->'packages','[]'::jsonb)) value
  where value->>'id' = c->>'packageId'
  limit 1;

  select value into co
  from jsonb_array_elements(coalesce(w->'companies','[]'::jsonb)) value
  where value->>'id' = c->>'companyId'
  limit 1;

  select coalesce(jsonb_agg(value order by coalesce(value->>'dueDate','') desc),'[]'::jsonb)
    into inv
  from jsonb_array_elements(coalesce(w->'invoices','[]'::jsonb)) value
  where value->>'customerId' = a.customer_id;

  select coalesce(jsonb_agg(value order by coalesce(value->>'date','') desc),'[]'::jsonb)
    into pays
  from jsonb_array_elements(coalesce(w->'payments','[]'::jsonb)) value
  where value->>'customerId' = a.customer_id;

  select coalesce(jsonb_agg(value order by coalesce(value->>'createdAt','') desc),'[]'::jsonb)
    into msgs
  from jsonb_array_elements(coalesce(w->'customerMessages','[]'::jsonb)) value
  where coalesce((value->>'active')::boolean,true)
    and (value->>'audience' = 'all' or value->>'customerId' = a.customer_id);

  expiry_date := nullif(c->>'expiryDate','');
  if expiry_date is null then
    select value->>'dueDate' into expiry_date
    from jsonb_array_elements(coalesce(w->'invoices','[]'::jsonb)) value
    where value->>'customerId' = a.customer_id
    order by coalesce(value->>'dueDate','') desc
    limit 1;
  end if;

  if nullif(c->>'appMessage','') is not null then
    msgs := msgs || jsonb_build_array(jsonb_build_object(
      'id','customer-profile-message',
      'title','ISP Message',
      'body',c->>'appMessage',
      'audience','customer',
      'customerId',a.customer_id,
      'createdAt',now()
    ));
  end if;

  return jsonb_build_object(
    'account', jsonb_build_object(
      'username', a.username,
      'app_enabled', a.app_enabled
    ),
    'customer', c,
    'company', coalesce(co,'{}'::jsonb),
    'package', coalesce(p,'{}'::jsonb),
    'invoices', inv,
    'payments', pays,
    'messages', msgs,
    'expiryDate', expiry_date
  );
end;
$$;

revoke all on function public.customer_get_portal_data() from public;
grant execute on function public.customer_get_portal_data() to authenticated;

-- Keep timestamp current when the server changes an account mapping.
create or replace function public.set_customer_app_account_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_customer_app_account_updated_at on public.customer_app_accounts;
create trigger trg_customer_app_account_updated_at
before update on public.customer_app_accounts
for each row execute function public.set_customer_app_account_updated_at();
