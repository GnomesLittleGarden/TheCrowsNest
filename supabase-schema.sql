-- Crow Nest production database foundation for Supabase/PostgreSQL.
-- Review before applying. Admin write policies are intentionally not enabled yet.
create extension if not exists pgcrypto;
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
create table if not exists public.videos (
 id uuid primary key default gen_random_uuid(),
 title text not null,
 youtube_url text not null,
 description text,
 is_published boolean not null default false,
 created_at timestamptz not null default now()
);
alter table public.grows enable row level security;
alter table public.field_entries enable row level security;
alter table public.videos enable row level security;
create policy "Public read published grows" on public.grows for select using (is_published = true);
create policy "Public read published entries" on public.field_entries for select using (is_published = true);
create policy "Public read published videos" on public.videos for select using (is_published = true);
-- Add admin write policies only after provisioning a dedicated authenticated admin role.
