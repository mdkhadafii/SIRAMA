create type public.user_role as enum ('user', 'admin');
create type public.service_type as enum ('health', 'counseling', 'report');
create type public.service_status as enum (
  'submitted',
  'under_review',
  'in_progress',
  'referred',
  'completed'
);
create type public.category_type as enum (
  'health',
  'counseling',
  'report',
  'article',
  'scholarship'
);
create type public.publication_status as enum ('draft', 'published', 'archived');

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;
grant usage on schema private to service_role;

alter default privileges for role postgres
  revoke all on tables from public, anon, authenticated, service_role;
alter default privileges for role postgres
  revoke all on functions from public, anon, authenticated, service_role;

create table public.profiles (
  id uuid primary key references auth.users (id) on delete restrict,
  display_name text not null default 'Pengguna Demo'
    check (char_length(btrim(display_name)) between 1 and 80),
  role public.user_role not null default 'user',
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.categories (
  id uuid primary key default gen_random_uuid(),
  name varchar(100) not null check (char_length(btrim(name)) between 1 and 100),
  slug varchar(120) not null unique check (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  type public.category_type not null,
  description text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.service_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles (id) on delete restrict,
  category_id uuid not null references public.categories (id) on delete restrict,
  service_type public.service_type not null,
  title varchar(150) not null check (char_length(btrim(title)) between 1 and 150),
  description text not null check (char_length(btrim(description)) between 1 and 3000),
  is_anonymous boolean not null default false,
  preferred_date date,
  scheduled_at timestamptz,
  status public.service_status not null default 'submitted',
  assigned_admin_id uuid references public.profiles (id) on delete restrict,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  completed_at timestamptz,
  constraint service_request_owner_mode_check check (
    (service_type = 'report' and is_anonymous and user_id is null)
    or (not is_anonymous and user_id is not null)
  ),
  constraint service_request_counseling_dates_check check (
    service_type = 'counseling'
    or (preferred_date is null and scheduled_at is null)
  ),
  constraint service_request_completed_at_check check (
    (status = 'completed' and completed_at is not null)
    or (status <> 'completed' and completed_at is null)
  )
);

create table public.service_status_history (
  id uuid primary key default gen_random_uuid(),
  request_id uuid not null references public.service_requests (id) on delete restrict,
  changed_by uuid references public.profiles (id) on delete restrict,
  old_status public.service_status,
  new_status public.service_status not null,
  internal_note text check (internal_note is null or char_length(internal_note) <= 2000),
  user_note text check (user_note is null or char_length(user_note) <= 2000),
  created_at timestamptz not null default now(),
  constraint service_status_history_initial_check check (
    (old_status is null and new_status = 'submitted' and changed_by is null)
    or (old_status is not null and changed_by is not null)
  )
);

create table public.tracking_tokens (
  id uuid primary key default gen_random_uuid(),
  request_id uuid not null unique references public.service_requests (id) on delete restrict,
  token_hash text not null unique check (token_hash ~ '^[a-f0-9]{64}$'),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  expires_at timestamptz
);

create table public.articles (
  id uuid primary key default gen_random_uuid(),
  category_id uuid not null references public.categories (id) on delete restrict,
  author_id uuid not null references public.profiles (id) on delete restrict,
  title varchar(200) not null check (char_length(btrim(title)) between 1 and 200),
  slug varchar(220) not null unique check (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  excerpt text not null,
  content text not null,
  thumbnail_url text,
  source_url text,
  status public.publication_status not null default 'draft',
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.scholarships (
  id uuid primary key default gen_random_uuid(),
  category_id uuid not null references public.categories (id) on delete restrict,
  created_by uuid not null references public.profiles (id) on delete restrict,
  title varchar(200) not null check (char_length(btrim(title)) between 1 and 200),
  slug varchar(220) not null unique check (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  provider varchar(150) not null check (char_length(btrim(provider)) between 1 and 150),
  description text not null,
  requirements text,
  benefits text,
  education_level varchar(50),
  deadline date,
  official_url text,
  thumbnail_url text,
  status public.publication_status not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.faqs (
  id uuid primary key default gen_random_uuid(),
  question text not null check (char_length(btrim(question)) between 1 and 500),
  answer text not null check (char_length(btrim(answer)) between 1 and 5000),
  display_order integer not null default 0 check (display_order >= 0),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table private.rate_limit_buckets (
  scope text not null check (scope in ('demo_access', 'auth', 'tracking', 'submission')),
  rate_key_hash text not null check (rate_key_hash ~ '^[a-f0-9]{64}$'),
  window_started_at timestamptz not null,
  attempts integer not null check (attempts > 0),
  primary key (scope, rate_key_hash)
);

create index service_requests_user_created_idx
  on public.service_requests (user_id, created_at desc);
create index service_requests_queue_idx
  on public.service_requests (service_type, status, created_at desc);
create index service_requests_assigned_admin_idx
  on public.service_requests (assigned_admin_id);
create index service_requests_category_idx
  on public.service_requests (category_id);
create index service_status_history_timeline_idx
  on public.service_status_history (request_id, created_at);
create index articles_publication_idx
  on public.articles (status, published_at desc, category_id);
create index scholarships_publication_idx
  on public.scholarships (status, deadline, category_id);
create index faqs_active_order_idx
  on public.faqs (is_active, display_order, id);
create index rate_limit_buckets_window_idx
  on private.rate_limit_buckets (window_started_at);

create function private.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := pg_catalog.now();
  return new;
end;
$$;

create function private.provision_profile()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name, role)
  values (new.id, 'Pengguna Demo', 'user')
  on conflict (id) do nothing;
  return new;
end;
$$;

create function private.validate_service_request_category()
returns trigger
language plpgsql
set search_path = ''
as $$
declare
  v_category_type public.category_type;
  v_is_active boolean;
  v_assigned_role public.user_role;
begin
  if tg_op = 'INSERT' then
    select c.type, c.is_active
      into v_category_type, v_is_active
      from public.categories as c
      where c.id = new.category_id
      for share;

    if not found or not v_is_active or v_category_type::text <> new.service_type::text then
      raise exception using errcode = '23514', message = 'Kategori layanan tidak valid.';
    end if;
  elsif new.category_id is distinct from old.category_id
    or new.service_type is distinct from old.service_type then
    select c.type, c.is_active
      into v_category_type, v_is_active
      from public.categories as c
      where c.id = new.category_id
      for share;

    if not found or not v_is_active or v_category_type::text <> new.service_type::text then
      raise exception using errcode = '23514', message = 'Kategori layanan tidak valid.';
    end if;
  end if;

  if new.assigned_admin_id is not null then
    select p.role into v_assigned_role
      from public.profiles as p where p.id = new.assigned_admin_id;
    if not found or v_assigned_role <> 'admin' then
      raise exception using errcode = '23514', message = 'Petugas yang ditugaskan tidak valid.';
    end if;
  end if;

  return new;
end;
$$;

create function private.prevent_category_type_change()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if old.type is distinct from new.type and (
    exists (select 1 from public.service_requests as r where r.category_id = old.id)
    or exists (select 1 from public.articles as a where a.category_id = old.id)
    or exists (select 1 from public.scholarships as s where s.category_id = old.id)
  ) then
    raise exception using errcode = '23514', message = 'Tipe kategori yang sudah digunakan tidak dapat diubah.';
  end if;

  return new;
end;
$$;

create function private.validate_content_category()
returns trigger
language plpgsql
set search_path = ''
as $$
declare
  v_expected_category public.category_type;
  v_category_type public.category_type;
  v_author_id uuid;
  v_author_role public.user_role;
begin
  if tg_table_name = 'articles' then
    v_expected_category := 'article';
    v_author_id := new.author_id;
  else
    v_expected_category := 'scholarship';
    v_author_id := new.created_by;
  end if;

  select c.type into v_category_type
    from public.categories as c where c.id = new.category_id;
  if not found or v_category_type <> v_expected_category then
    raise exception using errcode = '23514', message = 'Kategori konten tidak valid.';
  end if;

  select p.role into v_author_role
    from public.profiles as p where p.id = v_author_id;
  if not found or v_author_role <> 'admin' then
    raise exception using errcode = '42501', message = 'Penulis konten tidak berwenang.';
  end if;

  return new;
end;
$$;

create trigger auth_user_profile_provisioning
  after insert on auth.users
  for each row execute function private.provision_profile();

create trigger profiles_set_updated_at
  before update on public.profiles
  for each row execute function private.set_updated_at();
create trigger service_requests_set_updated_at
  before update on public.service_requests
  for each row execute function private.set_updated_at();
create trigger articles_set_updated_at
  before update on public.articles
  for each row execute function private.set_updated_at();
create trigger scholarships_set_updated_at
  before update on public.scholarships
  for each row execute function private.set_updated_at();
create trigger faqs_set_updated_at
  before update on public.faqs
  for each row execute function private.set_updated_at();
create trigger categories_preserve_used_type
  before update of type on public.categories
  for each row execute function private.prevent_category_type_change();

create trigger service_requests_validate_category
  before insert or update of category_id, service_type, assigned_admin_id on public.service_requests
  for each row execute function private.validate_service_request_category();
create trigger articles_validate_category_and_author
  before insert or update of category_id, author_id on public.articles
  for each row execute function private.validate_content_category();
create trigger scholarships_validate_category_and_author
  before insert or update of category_id, created_by on public.scholarships
  for each row execute function private.validate_content_category();

create function public.create_demo_service_request(
  p_user_id uuid,
  p_category_id uuid,
  p_service_type public.service_type,
  p_title text,
  p_description text,
  p_is_anonymous boolean default false,
  p_preferred_date date default null,
  p_tracking_token_hash text default null
)
returns table (request_id uuid, request_status public.service_status, request_created_at timestamptz)
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_request_id uuid;
  v_created_at timestamptz;
  v_profile_role public.user_role;
begin
  if p_is_anonymous then
    if p_service_type <> 'report' or p_user_id is not null
      or p_tracking_token_hash is null
      or p_tracking_token_hash !~ '^[a-f0-9]{64}$' then
      raise exception using errcode = '23514', message = 'Mode pengajuan anonim tidak valid.';
    end if;
  else
    if p_user_id is null or p_tracking_token_hash is not null then
      raise exception using errcode = '23514', message = 'Pemilik pengajuan tidak valid.';
    end if;

    select p.role into v_profile_role
      from public.profiles as p where p.id = p_user_id;
    if not found or v_profile_role <> 'user' then
      raise exception using errcode = '42501', message = 'Akun pengguna tidak berwenang.';
    end if;
  end if;

  if p_service_type <> 'counseling' and p_preferred_date is not null then
    raise exception using errcode = '23514', message = 'Tanggal pilihan hanya berlaku untuk konseling.';
  end if;

  if p_title is null or char_length(btrim(p_title)) not between 1 and 150
    or p_description is null or char_length(btrim(p_description)) not between 1 and 3000 then
    raise exception using errcode = '23514', message = 'Skenario pengajuan tidak valid.';
  end if;

  insert into public.service_requests (
    user_id, category_id, service_type, title, description,
    is_anonymous, preferred_date, status
  ) values (
    p_user_id, p_category_id, p_service_type, btrim(p_title), btrim(p_description),
    p_is_anonymous, p_preferred_date, 'submitted'
  ) returning id, created_at into v_request_id, v_created_at;

  insert into public.service_status_history (
    request_id, changed_by, old_status, new_status
  ) values (v_request_id, null, null, 'submitted');

  if p_is_anonymous then
    insert into public.tracking_tokens (request_id, token_hash)
    values (v_request_id, p_tracking_token_hash);
  end if;

  return query select v_request_id, 'submitted'::public.service_status, v_created_at;
end;
$$;

create function public.update_demo_service_status(
  p_request_id uuid,
  p_changed_by uuid,
  p_expected_status public.service_status,
  p_new_status public.service_status,
  p_user_note text default null,
  p_internal_note text default null,
  p_scheduled_at timestamptz default null
)
returns table (updated boolean, observed_status public.service_status, status_updated_at timestamptz)
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_request public.service_requests%rowtype;
  v_admin_role public.user_role;
  v_now timestamptz;
  v_valid_transition boolean := false;
begin
  if p_expected_status is null or p_new_status is null then
    raise exception using errcode = '22023', message = 'Status pengajuan wajib diisi.';
  end if;

  select p.role into v_admin_role
    from public.profiles as p where p.id = p_changed_by;
  if not found or v_admin_role <> 'admin' then
    raise exception using errcode = '42501', message = 'Akun petugas tidak berwenang.';
  end if;

  if p_user_note is not null and char_length(p_user_note) > 2000
    or p_internal_note is not null and char_length(p_internal_note) > 2000 then
    raise exception using errcode = '23514', message = 'Catatan melebihi batas yang diizinkan.';
  end if;

  select r.* into v_request
    from public.service_requests as r
    where r.id = p_request_id
    for update;
  if not found then
    return query select false, null::public.service_status, null::timestamptz;
    return;
  end if;

  if v_request.status <> p_expected_status then
    return query select false, v_request.status, v_request.updated_at;
    return;
  end if;

  v_valid_transition :=
    (v_request.status = 'submitted' and p_new_status = 'under_review')
    or (v_request.status = 'under_review' and p_new_status = 'in_progress')
    or (v_request.status = 'in_progress' and p_new_status in ('referred', 'completed'))
    or (v_request.status = 'referred' and p_new_status = 'completed');

  if not v_valid_transition then
    raise exception using errcode = '23514', message = 'Perubahan status tidak valid.';
  end if;

  if p_scheduled_at is not null and v_request.service_type <> 'counseling' then
    raise exception using errcode = '23514', message = 'Jadwal hanya berlaku untuk konseling.';
  end if;

  if p_new_status in ('referred', 'completed') and nullif(btrim(p_user_note), '') is null then
    raise exception using errcode = '23514', message = 'Catatan publik diperlukan untuk status ini.';
  end if;

  v_now := pg_catalog.now();
  update public.service_requests as r
    set status = p_new_status,
        scheduled_at = case
          when r.service_type = 'counseling' then coalesce(p_scheduled_at, r.scheduled_at)
          else null
        end,
        completed_at = case when p_new_status = 'completed' then v_now else null end,
        updated_at = v_now
    where r.id = p_request_id;

  insert into public.service_status_history (
    request_id, changed_by, old_status, new_status, internal_note, user_note
  ) values (
    p_request_id, p_changed_by, v_request.status, p_new_status,
    nullif(btrim(p_internal_note), ''), nullif(btrim(p_user_note), '')
  );

  return query select true, p_new_status, v_now;
end;
$$;

create function public.consume_demo_rate_limit(p_scope text, p_key_hash text)
returns table (allowed boolean, retry_after_seconds integer)
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_limit integer;
  v_window_seconds integer;
  v_started_at timestamptz;
  v_attempts integer;
  v_now timestamptz := pg_catalog.clock_timestamp();
begin
  if p_scope is null or p_scope not in ('demo_access', 'auth', 'tracking', 'submission')
    or p_key_hash is null or p_key_hash !~ '^[a-f0-9]{64}$' then
    raise exception using errcode = '22023', message = 'Parameter pembatasan laju tidak valid.';
  end if;

  case p_scope
    when 'demo_access' then v_limit := 10; v_window_seconds := 900;
    when 'auth' then v_limit := 10; v_window_seconds := 900;
    when 'tracking' then v_limit := 5; v_window_seconds := 60;
    when 'submission' then v_limit := 10; v_window_seconds := 60;
  end case;

  delete from private.rate_limit_buckets as b
    where b.window_started_at < v_now - interval '1 day';

  insert into private.rate_limit_buckets as current_bucket
    (scope, rate_key_hash, window_started_at, attempts)
  values (p_scope, p_key_hash, v_now, 1)
  on conflict (scope, rate_key_hash) do update
    set window_started_at = case
          when current_bucket.window_started_at
            + pg_catalog.make_interval(secs => v_window_seconds) <= v_now
            then v_now
          else current_bucket.window_started_at
        end,
        attempts = case
          when current_bucket.window_started_at
            + pg_catalog.make_interval(secs => v_window_seconds) <= v_now
            then 1
          else current_bucket.attempts + 1
        end
  returning current_bucket.window_started_at, current_bucket.attempts
    into v_started_at, v_attempts;

  return query select
    v_attempts <= v_limit,
    case when v_attempts <= v_limit then 0 else greatest(
      1,
      ceil(extract(epoch from v_started_at
        + pg_catalog.make_interval(secs => v_window_seconds) - v_now))::integer
    ) end;
end;
$$;

alter table public.profiles enable row level security;
alter table public.categories enable row level security;
alter table public.service_requests enable row level security;
alter table public.service_status_history enable row level security;
alter table public.tracking_tokens enable row level security;
alter table public.articles enable row level security;
alter table public.scholarships enable row level security;
alter table public.faqs enable row level security;
alter table private.rate_limit_buckets enable row level security;

revoke all on table public.profiles, public.categories, public.service_requests,
  public.service_status_history, public.tracking_tokens, public.articles,
  public.scholarships, public.faqs from public, anon, authenticated, service_role;
revoke all on table private.rate_limit_buckets from public, anon, authenticated, service_role;

grant select on public.profiles to authenticated;
grant select on public.profiles to service_role;
grant select on public.categories to anon, authenticated, service_role;
grant select on public.service_requests, public.service_status_history,
  public.tracking_tokens to service_role;
grant select on public.articles, public.scholarships, public.faqs
  to anon, authenticated, service_role;

create policy profiles_read_self on public.profiles
  for select to authenticated using (id = (select auth.uid()));
create policy categories_read_active on public.categories
  for select to anon, authenticated using (is_active);
create policy articles_read_published on public.articles
  for select to anon, authenticated
  using (status = 'published' and published_at is not null and published_at <= now());
create policy scholarships_read_published on public.scholarships
  for select to anon, authenticated using (status = 'published');
create policy faqs_read_active on public.faqs
  for select to anon, authenticated using (is_active);

revoke all on function private.set_updated_at() from public, anon, authenticated, service_role;
revoke all on function private.provision_profile() from public, anon, authenticated, service_role;
revoke all on function private.validate_service_request_category() from public, anon, authenticated, service_role;
revoke all on function private.validate_content_category() from public, anon, authenticated, service_role;
revoke all on function private.prevent_category_type_change() from public, anon, authenticated, service_role;
revoke all on function public.create_demo_service_request(
  uuid, uuid, public.service_type, text, text, boolean, date, text
) from public, anon, authenticated, service_role;
revoke all on function public.update_demo_service_status(
  uuid, uuid, public.service_status, public.service_status, text, text, timestamptz
) from public, anon, authenticated, service_role;
revoke all on function public.consume_demo_rate_limit(text, text)
  from public, anon, authenticated, service_role;

grant execute on function public.create_demo_service_request(
  uuid, uuid, public.service_type, text, text, boolean, date, text
) to service_role;
grant execute on function public.update_demo_service_status(
  uuid, uuid, public.service_status, public.service_status, text, text, timestamptz
) to service_role;
grant execute on function public.consume_demo_rate_limit(text, text)
  to service_role;

comment on schema private is 'Schema internal; tidak diekspos oleh Supabase Data API.';
comment on table public.service_requests is 'Data request demo sintetis; hanya dapat dibaca server terotorisasi.';
comment on table public.service_status_history is 'History append-only; catatan internal tidak pernah tersedia ke client.';
comment on table public.tracking_tokens is 'Hash token pelacakan anonim; akses hanya melalui server.';
comment on table private.rate_limit_buckets is 'Counter rate limit; hanya hash identitas, tidak menyimpan alamat IP mentah.';
comment on function public.create_demo_service_request(
  uuid, uuid, public.service_type, text, text, boolean, date, text
) is 'Transaksi request + history + token opsional. Server wajib memvalidasi sesi, gate, dan skenario sintetis.';
comment on function public.update_demo_service_status(
  uuid, uuid, public.service_status, public.service_status, text, text, timestamptz
) is 'Transaksi update status + history dengan expected status. Server wajib memeriksa sesi demo sebelum memanggil.';
