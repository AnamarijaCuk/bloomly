-- Tablica za ograničavanje broja AI zahtjeva po korisniku.
-- Pokreni u Supabase SQL Editoru.

create table if not exists public.ai_zahtjevi (
  id          bigserial primary key,
  user_id     uuid not null references auth.users (id) on delete cascade,
  created_at  timestamptz not null default now()
);

create index if not exists ai_zahtjevi_user_vrijeme
  on public.ai_zahtjevi (user_id, created_at desc);

alter table public.ai_zahtjevi enable row level security;

-- Korisnik vidi i upisuje isključivo vlastite zapise.
create policy "vlastiti zahtjevi - citanje"
  on public.ai_zahtjevi for select
  using (auth.uid() = user_id);

create policy "vlastiti zahtjevi - upis"
  on public.ai_zahtjevi for insert
  with check (auth.uid() = user_id);