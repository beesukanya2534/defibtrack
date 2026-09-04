-- DefibTrack schema
-- Two generic key/JSON tables mirroring the app's document store.

create table if not exists public.months (
  key         text primary key,
  data        jsonb not null default '{}'::jsonb,
  updated_at  timestamptz not null default now()
);

create table if not exists public.config (
  key         text primary key,
  data        jsonb not null default '{}'::jsonb,
  updated_at  timestamptz not null default now()
);

alter table public.months enable row level security;
alter table public.config enable row level security;

-- Open access: anyone with the anon key may read and write.
-- (Internal single-purpose tool; no personal data.)
create policy "public read months"   on public.months for select using (true);
create policy "public insert months" on public.months for insert with check (true);
create policy "public update months" on public.months for update using (true) with check (true);
create policy "public delete months" on public.months for delete using (true);

create policy "public read config"   on public.config for select using (true);
create policy "public insert config" on public.config for insert with check (true);
create policy "public update config" on public.config for update using (true) with check (true);
create policy "public delete config" on public.config for delete using (true);

-- Realtime for the history list sync.
alter publication supabase_realtime add table public.months;
alter publication supabase_realtime add table public.config;
