-- NetFlow ISP: username + password login and secure no-Gmail ISP provisioning.
-- Run AFTER the existing NetFlow/Supabase setup SQL.
-- Passwords are never stored in public tables; Supabase Auth handles them.

alter table public.isp_profiles
  add column if not exists username text;

update public.isp_profiles p
set username = lower(split_part(u.email, '@', 1))
from auth.users u
where u.id = p.user_id
  and (p.username is null or btrim(p.username) = '');

create unique index if not exists isp_profiles_username_lower_uq
  on public.isp_profiles (lower(username))
  where username is not null and btrim(username) <> '';

-- Resolve a username to the internal Auth email. The email is never shown to ISP users.
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

-- Username change for an already logged-in ISP user.
create or replace function public.set_my_username(p_username text)
returns text
language plpgsql
security definer
set search_path = public
as $$
begin
  p_username := lower(trim(p_username));
  if p_username !~ '^[a-z0-9][a-z0-9._-]{2,31}$' then
    raise exception 'Username must be 3-32 characters: letters, numbers, dot, dash or underscore.';
  end if;
  if exists(select 1 from public.isp_profiles where lower(username)=p_username and user_id<>auth.uid()) then
    raise exception 'Username is already in use.';
  end if;
  update public.isp_profiles set username=p_username where user_id=auth.uid();
  return p_username;
end;
$$;

revoke all on function public.set_my_username(text) from public;
grant execute on function public.set_my_username(text) to authenticated;

-- Secure provisioning RPC used immediately after Supabase Auth signup.
-- The browser can call it with the NEW ISP user's token, but it can only
-- provision that token's own user_id. This is why isp_workspaces RLS stays ON.
create or replace function public.provision_my_isp_workspace(
  p_username text,
  p_display_name text default null
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_workspace_id uuid;
  v_name text := nullif(btrim(coalesce(p_display_name,'')), '');
  v_username text := lower(btrim(coalesce(p_username,'')));
begin
  if v_uid is null then
    raise exception 'Authentication required';
  end if;

  if v_username !~ '^[a-z0-9][a-z0-9._-]{2,31}$' then
    raise exception 'Username must be 3-32 characters: letters, numbers, dot, dash or underscore.';
  end if;

  if exists (
    select 1 from public.isp_profiles
    where lower(username)=v_username and user_id<>v_uid
  ) then
    raise exception 'Username is already in use.';
  end if;

  -- Workspace is keyed by the Auth user's UUID in this project schema.
  insert into public.isp_workspaces (user_id, data, updated_at)
  values (
    v_uid,
    jsonb_build_object(
      'companies','[]'::jsonb,
      'customers','[]'::jsonb,
      'packages','[]'::jsonb,
      'invoices','[]'::jsonb,
      'payments','[]'::jsonb,
      'expenses','[]'::jsonb,
      'staff','[]'::jsonb,
      'network','[]'::jsonb,
      'suppliers','[]'::jsonb,
      'olts','[]'::jsonb,
      'mikrotiks','[]'::jsonb
    ),
    now()
  )
  on conflict (user_id) do update
    set updated_at = now()
  returning user_id into v_workspace_id;

  -- Create or repair the profile after the workspace exists.
  insert into public.isp_profiles (
    user_id, workspace_id, username, role, display_name
  )
  values (
    v_uid, v_workspace_id, v_username, 'owner', coalesce(v_name, v_username)
  )
  on conflict (user_id) do update set
    workspace_id = excluded.workspace_id,
    username = excluded.username,
    role = 'owner',
    display_name = excluded.display_name;

  return v_workspace_id;
end;
$$;

revoke all on function public.provision_my_isp_workspace(text,text) from public;
grant execute on function public.provision_my_isp_workspace(text,text) to authenticated;
