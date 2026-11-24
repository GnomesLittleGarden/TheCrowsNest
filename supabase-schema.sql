-- Crow Nest shared publishing setup for Supabase.
-- Run this entire file once in Supabase > SQL Editor > New query.
-- Public visitors can read published items. Only user IDs listed in admin_users can write.

create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.grows (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  plant text,
  stage text not null default 'Germination',
  start_date date,
  description text,
  cover_image text,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.field_entries (
  id uuid primary key default gen_random_uuid(),
  grow_id uuid not null references public.grows(id) on delete cascade,
  entry_type text not null check (entry_type in ('watering','feeding','lighting','observation')),
  entry_date date not null default current_date,
  title text not null,
  details text,
  amount text,
  light_distance text,
  light_intensity text,
  photo_url text,
  is_published boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.underground_posts (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text,
  summary text,
  body text,
  cover_image text,
  youtube_url text,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.videos (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  youtube_url text not null,
  description text,
  is_published boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists grows_published_idx on public.grows (is_published, start_date desc);
create index if not exists field_entries_published_idx on public.field_entries (is_published, entry_date desc);
create index if not exists field_entries_grow_idx on public.field_entries (grow_id);
create index if not exists underground_posts_published_idx on public.underground_posts (is_published, created_at desc);
create index if not exists videos_published_idx on public.videos (is_published, created_at desc);

create or replace function public.is_crow_nest_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.admin_users
    where user_id = (select auth.uid())
  );
$$;

grant execute on function public.is_crow_nest_admin() to anon, authenticated;

alter table public.admin_users enable row level security;
alter table public.grows enable row level security;
alter table public.field_entries enable row level security;
alter table public.underground_posts enable row level security;
alter table public.videos enable row level security;

drop policy if exists "Admins can read their own admin record" on public.admin_users;
create policy "Admins can read their own admin record"
on public.admin_users for select to authenticated
using (user_id = (select auth.uid()));

drop policy if exists "Public read published grows" on public.grows;
create policy "Public read published grows"
on public.grows for select to anon, authenticated
using (is_published = true or public.is_crow_nest_admin());
drop policy if exists "Admins insert grows" on public.grows;
create policy "Admins insert grows" on public.grows for insert to authenticated
with check (public.is_crow_nest_admin());
drop policy if exists "Admins update grows" on public.grows;
create policy "Admins update grows" on public.grows for update to authenticated
using (public.is_crow_nest_admin()) with check (public.is_crow_nest_admin());
drop policy if exists "Admins delete grows" on public.grows;
create policy "Admins delete grows" on public.grows for delete to authenticated
using (public.is_crow_nest_admin());

drop policy if exists "Public read published field entries" on public.field_entries;
create policy "Public read published field entries"
on public.field_entries for select to anon, authenticated
using (
  (is_published = true and exists (
    select 1 from public.grows g where g.id = grow_id and g.is_published = true
  )) or public.is_crow_nest_admin()
);
drop policy if exists "Admins insert field entries" on public.field_entries;
create policy "Admins insert field entries" on public.field_entries for insert to authenticated
with check (public.is_crow_nest_admin());
drop policy if exists "Admins update field entries" on public.field_entries;
create policy "Admins update field entries" on public.field_entries for update to authenticated
using (public.is_crow_nest_admin()) with check (public.is_crow_nest_admin());
drop policy if exists "Admins delete field entries" on public.field_entries;
create policy "Admins delete field entries" on public.field_entries for delete to authenticated
using (public.is_crow_nest_admin());

drop policy if exists "Public read published underground posts" on public.underground_posts;
create policy "Public read published underground posts"
on public.underground_posts for select to anon, authenticated
using (is_published = true or public.is_crow_nest_admin());
drop policy if exists "Admins insert underground posts" on public.underground_posts;
create policy "Admins insert underground posts" on public.underground_posts for insert to authenticated
with check (public.is_crow_nest_admin());
drop policy if exists "Admins update underground posts" on public.underground_posts;
create policy "Admins update underground posts" on public.underground_posts for update to authenticated
using (public.is_crow_nest_admin()) with check (public.is_crow_nest_admin());
drop policy if exists "Admins delete underground posts" on public.underground_posts;
create policy "Admins delete underground posts" on public.underground_posts for delete to authenticated
using (public.is_crow_nest_admin());

drop policy if exists "Public read published videos" on public.videos;
create policy "Public read published videos"
on public.videos for select to anon, authenticated
using (is_published = true or public.is_crow_nest_admin());
drop policy if exists "Admins insert videos" on public.videos;
create policy "Admins insert videos" on public.videos for insert to authenticated
with check (public.is_crow_nest_admin());
drop policy if exists "Admins update videos" on public.videos;
create policy "Admins update videos" on public.videos for update to authenticated
using (public.is_crow_nest_admin()) with check (public.is_crow_nest_admin());
drop policy if exists "Admins delete videos" on public.videos;
create policy "Admins delete videos" on public.videos for delete to authenticated
using (public.is_crow_nest_admin());

grant select on public.grows, public.field_entries, public.underground_posts, public.videos to anon, authenticated;
grant all on public.grows, public.field_entries, public.underground_posts, public.videos to authenticated;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('crow-nest-media', 'crow-nest-media', true, 8388608, array['image/jpeg','image/png','image/webp','image/gif'])
on conflict (id) do update set public = true, file_size_limit = 8388608;

drop policy if exists "Public can view Crow Nest images" on storage.objects;
create policy "Public can view Crow Nest images"
on storage.objects for select to anon, authenticated
using (bucket_id = 'crow-nest-media');
drop policy if exists "Crow Nest admins upload images" on storage.objects;
create policy "Crow Nest admins upload images"
on storage.objects for insert to authenticated
with check (bucket_id = 'crow-nest-media' and public.is_crow_nest_admin());
drop policy if exists "Crow Nest admins update images" on storage.objects;
create policy "Crow Nest admins update images"
on storage.objects for update to authenticated
using (bucket_id = 'crow-nest-media' and public.is_crow_nest_admin())
with check (bucket_id = 'crow-nest-media' and public.is_crow_nest_admin());
drop policy if exists "Crow Nest admins delete images" on storage.objects;
create policy "Crow Nest admins delete images"
on storage.objects for delete to authenticated
using (bucket_id = 'crow-nest-media' and public.is_crow_nest_admin());

-- After creating your Supabase Auth user, add it to the admin allow-list.
-- Replace the email in this example with the email used for your admin login:
-- insert into public.admin_users (user_id)
-- select id from auth.users where email = 'you@example.com'
-- on conflict (user_id) do nothing;
