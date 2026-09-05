-- NetFlow ISP Username Login FIX
-- Run this ONCE in the SAME Supabase project used by the Master/Franchise/Dealer/ISP web.
-- This adds the missing username -> internal Auth email resolver.

create or replace function public.resolve_login_email(p_username text)
returns text
language sql
security definer
stable
set search_path = public
as $$
  select u.email
  from auth.users u
  join public.isp_profiles p on p.user_id = u.id
  where lower(p.username) = lower(trim(p_username))
    and p.username is not null
  limit 1;
$$;

revoke all on function public.resolve_login_email(text) from public;
grant execute on function public.resolve_login_email(text) to anon, authenticated;

-- Make sure the username column/index exist.
alter table public.isp_profiles add column if not exists username text;
create unique index if not exists isp_profiles_username_lower_uq
  on public.isp_profiles (lower(username))
  where username is not null and btrim(username) <> '';

-- Verify the function exists.
select routine_name
from information_schema.routines
where routine_schema='public'
  and routine_name='resolve_login_email';
