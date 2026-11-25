-- SIRAMA information platform and CMS.
-- Additive migration: legacy request/history/tracking tables are intentionally preserved.

create or replace function private.is_sirama_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = (select auth.uid()) and p.role = 'admin'
  );
$$;

grant usage on schema private to authenticated;
revoke all on function private.is_sirama_admin() from public, anon, service_role;
grant execute on function private.is_sirama_admin() to authenticated;

alter table public.articles
  add column if not exists content_type text not null default 'general',
  add column if not exists reviewed_at date,
  add column if not exists image_alt text;
alter table public.articles
  drop constraint if exists articles_content_type_check;
alter table public.articles
  add constraint articles_content_type_check
  check (content_type in ('general', 'health', 'mental_health', 'education', 'safety'));
alter table public.articles alter column author_id drop not null;

alter table public.scholarships
  add column if not exists application_period text,
  add column if not exists application_steps text,
  add column if not exists faq jsonb not null default '[]'::jsonb,
  add column if not exists reviewed_at date,
  add column if not exists image_alt text;
alter table public.scholarships alter column created_by drop not null;

alter table public.faqs
  add column if not exists article_id uuid references public.articles(id) on delete set null,
  add column if not exists scholarship_id uuid references public.scholarships(id) on delete set null,
  add column if not exists status public.publication_status not null default 'draft';
alter table public.faqs drop constraint if exists faqs_single_context_check;
alter table public.faqs add constraint faqs_single_context_check
  check (article_id is null or scholarship_id is null);
update public.faqs set status = case when is_active then 'published'::public.publication_status else 'archived'::public.publication_status end;

create table if not exists public.article_sources (
  id uuid primary key default gen_random_uuid(),
  article_id uuid not null references public.articles(id) on delete cascade,
  title text not null check (char_length(btrim(title)) between 1 and 250),
  url text not null check (url ~ '^https://'),
  reviewed_at date,
  created_at timestamptz not null default now()
);
create index if not exists article_sources_article_idx on public.article_sources(article_id);

create table if not exists public.site_settings (
  key text primary key check (key ~ '^[a-z][a-z0-9_]{1,79}$'),
  value jsonb not null default 'null'::jsonb,
  is_public boolean not null default false,
  updated_at timestamptz not null default now(),
  updated_by uuid references public.profiles(id) on delete set null
);

alter table public.article_sources enable row level security;
alter table public.site_settings enable row level security;

revoke all on table public.categories, public.articles, public.scholarships, public.faqs,
  public.article_sources, public.site_settings from public, anon, authenticated, service_role;

grant select on public.categories to anon, authenticated, service_role;
grant select on public.articles, public.scholarships, public.faqs, public.article_sources, public.site_settings to anon, authenticated, service_role;
grant insert, update, delete on public.categories, public.articles, public.scholarships, public.faqs,
  public.article_sources, public.site_settings to authenticated;

create policy categories_admin_read_all on public.categories
  for select to authenticated using (private.is_sirama_admin());
create policy categories_admin_insert on public.categories
  for insert to authenticated with check (private.is_sirama_admin());
create policy categories_admin_update on public.categories
  for update to authenticated using (private.is_sirama_admin()) with check (private.is_sirama_admin());
create policy categories_admin_delete on public.categories
  for delete to authenticated using (private.is_sirama_admin());

create policy articles_admin_read_all on public.articles
  for select to authenticated using (private.is_sirama_admin());
create policy articles_admin_insert on public.articles
  for insert to authenticated with check (private.is_sirama_admin());
create policy articles_admin_update on public.articles
  for update to authenticated using (private.is_sirama_admin()) with check (private.is_sirama_admin());
create policy articles_admin_delete on public.articles
  for delete to authenticated using (private.is_sirama_admin());

create policy scholarships_admin_read_all on public.scholarships
  for select to authenticated using (private.is_sirama_admin());
create policy scholarships_admin_insert on public.scholarships
  for insert to authenticated with check (private.is_sirama_admin());
create policy scholarships_admin_update on public.scholarships
  for update to authenticated using (private.is_sirama_admin()) with check (private.is_sirama_admin());
create policy scholarships_admin_delete on public.scholarships
  for delete to authenticated using (private.is_sirama_admin());

drop policy faqs_read_active on public.faqs;
create policy faqs_read_published on public.faqs
  for select to anon, authenticated using (is_active and status = 'published');
create policy faqs_admin_read_all on public.faqs
  for select to authenticated using (private.is_sirama_admin());
create policy faqs_admin_insert on public.faqs
  for insert to authenticated with check (private.is_sirama_admin());
create policy faqs_admin_update on public.faqs
  for update to authenticated using (private.is_sirama_admin()) with check (private.is_sirama_admin());
create policy faqs_admin_delete on public.faqs
  for delete to authenticated using (private.is_sirama_admin());

create policy article_sources_read_published on public.article_sources
  for select to anon, authenticated using (
    exists (select 1 from public.articles a where a.id = article_id and a.status = 'published' and a.published_at is not null and a.published_at <= now())
  );
create policy article_sources_admin_read_all on public.article_sources
  for select to authenticated using (private.is_sirama_admin());
create policy article_sources_admin_insert on public.article_sources
  for insert to authenticated with check (private.is_sirama_admin());
create policy article_sources_admin_update on public.article_sources
  for update to authenticated using (private.is_sirama_admin()) with check (private.is_sirama_admin());
create policy article_sources_admin_delete on public.article_sources
  for delete to authenticated using (private.is_sirama_admin());

create policy site_settings_read_public on public.site_settings
  for select to anon, authenticated using (is_public);
create policy site_settings_admin_read_all on public.site_settings
  for select to authenticated using (private.is_sirama_admin());
create policy site_settings_admin_insert on public.site_settings
  for insert to authenticated with check (private.is_sirama_admin());
create policy site_settings_admin_update on public.site_settings
  for update to authenticated using (private.is_sirama_admin()) with check (private.is_sirama_admin());
create policy site_settings_admin_delete on public.site_settings
  for delete to authenticated using (private.is_sirama_admin());

create or replace function private.set_site_settings_updated_at()
returns trigger language plpgsql set search_path = '' as $$
begin
  new.updated_at = now();
  new.updated_by = (select auth.uid());
  return new;
end;
$$;
create trigger site_settings_set_updated_at before update on public.site_settings
  for each row execute function private.set_site_settings_updated_at();
revoke all on function private.set_site_settings_updated_at() from public, anon, authenticated, service_role;

comment on table public.article_sources is 'Sumber artikel CMS yang dapat diperiksa pengunjung.';
comment on table public.site_settings is 'Pengaturan situs; hanya nilai berlabel publik yang dapat dibaca pengunjung.';
comment on table public.service_requests is 'Tabel legacy; aplikasi baru tidak membuat atau menampilkan permintaan layanan.';
comment on table public.service_status_history is 'Tabel legacy; dipertahankan tanpa akses aplikasi baru.';
comment on table public.tracking_tokens is 'Tabel legacy; dipertahankan tanpa akses aplikasi baru.';
