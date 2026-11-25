-- Read-only verification for the Phase 2 Supabase Cloud bootstrap.
-- Run after the migration and seed.sql succeed. Every row in `lulus` must be true.

with expected_tables(schema_name, table_name) as (
  values
    ('public', 'profiles'),
    ('public', 'categories'),
    ('public', 'service_requests'),
    ('public', 'service_status_history'),
    ('public', 'tracking_tokens'),
    ('public', 'articles'),
    ('public', 'scholarships'),
    ('public', 'faqs'),
    ('private', 'rate_limit_buckets')
), table_state as (
  select
    e.schema_name,
    e.table_name,
    c.oid is not null as table_exists,
    coalesce(c.relrowsecurity, false) as rls_enabled
  from expected_tables as e
  left join pg_namespace as n on n.nspname = e.schema_name
  left join pg_class as c on c.relnamespace = n.oid
    and c.relname = e.table_name
    and c.relkind in ('r', 'p')
), expected_policies(schema_name, table_name, policy_name) as (
  values
    ('public', 'profiles', 'profiles_read_self'),
    ('public', 'categories', 'categories_read_active'),
    ('public', 'articles', 'articles_read_published'),
    ('public', 'scholarships', 'scholarships_read_published'),
    ('public', 'faqs', 'faqs_read_active')
), policy_state as (
  select
    e.policy_name,
    exists (
      select 1 from pg_policies as p
      where p.schemaname = e.schema_name
        and p.tablename = e.table_name
        and p.policyname = e.policy_name
    ) as policy_exists
  from expected_policies as e
), expected_functions(signature) as (
  values
    ('public.create_demo_service_request(uuid,uuid,public.service_type,text,text,boolean,date,text)'),
    ('public.update_demo_service_status(uuid,uuid,public.service_status,public.service_status,text,text,timestamptz)'),
    ('public.consume_demo_rate_limit(text,text)')
), function_state as (
  select
    e.signature,
    p.oid is not null as function_exists,
    coalesce(p.prosecdef, false) as security_definer,
    coalesce(array_to_string(p.proconfig, ',') like '%search_path=""%', false) as locked_search_path,
    coalesce(has_function_privilege('service_role', p.oid, 'execute'), false) as service_can_execute,
    coalesce(has_function_privilege('anon', p.oid, 'execute'), false) as anon_can_execute,
    coalesce(has_function_privilege('authenticated', p.oid, 'execute'), false) as user_can_execute
  from expected_functions as e
  left join pg_proc as p on p.oid = to_regprocedure(e.signature)
)
select
  'Semua tabel Phase 2 tersedia dan RLS aktif'::text as pemeriksaan,
  bool_and(table_exists and rls_enabled) as lulus,
  coalesce(
    string_agg(schema_name || '.' || table_name, ', ' order by schema_name, table_name)
      filter (where not table_exists or not rls_enabled),
    'Tidak ada'
  ) as perlu_diperiksa
from table_state

union all

select
  'Akses tabel sensitif dibatasi',
  not has_table_privilege('anon', 'public.service_requests', 'select')
    and not has_table_privilege('authenticated', 'public.service_requests', 'select')
    and not has_table_privilege('anon', 'public.service_status_history', 'select')
    and not has_table_privilege('authenticated', 'public.service_status_history', 'select')
    and not has_table_privilege('anon', 'public.tracking_tokens', 'select')
    and not has_table_privilege('authenticated', 'public.tracking_tokens', 'select')
    and not has_table_privilege('anon', 'private.rate_limit_buckets', 'select')
    and not has_table_privilege('authenticated', 'private.rate_limit_buckets', 'select')
    and not has_table_privilege('service_role', 'private.rate_limit_buckets', 'select'),
  'anon/authenticated tidak dapat membaca request, history, token, atau counter; service_role memakai RPC untuk counter'

union all

select
  'Akses baca yang direncanakan tersedia',
  has_table_privilege('anon', 'public.categories', 'select')
    and has_table_privilege('authenticated', 'public.categories', 'select')
    and has_table_privilege('anon', 'public.articles', 'select')
    and has_table_privilege('authenticated', 'public.articles', 'select')
    and has_table_privilege('anon', 'public.scholarships', 'select')
    and has_table_privilege('authenticated', 'public.scholarships', 'select')
    and has_table_privilege('anon', 'public.faqs', 'select')
    and has_table_privilege('authenticated', 'public.faqs', 'select')
    and has_table_privilege('authenticated', 'public.profiles', 'select')
    and has_table_privilege('service_role', 'public.service_requests', 'select')
    and has_table_privilege('service_role', 'public.service_status_history', 'select')
    and has_table_privilege('service_role', 'public.tracking_tokens', 'select'),
  'RLS tetap membatasi kategori/konten aktif dan profile milik sendiri'

union all

select
  'Policy baca yang diharapkan tersedia',
  bool_and(policy_exists),
  coalesce(string_agg(policy_name, ', ' order by policy_name)
    filter (where not policy_exists), 'Tidak ada policy yang hilang')
from policy_state

union all

select
  'RPC sensitif hanya dapat dijalankan service_role',
  bool_and(function_exists and security_definer and locked_search_path
    and service_can_execute and not anon_can_execute and not user_can_execute),
  coalesce(string_agg(signature, ', ' order by signature)
    filter (where not function_exists or not security_definer or not locked_search_path
      or not service_can_execute or anon_can_execute or user_can_execute),
    'Semua RPC tersedia, aman, dan hak eksekusinya terbatas')
from function_state

union all

select
  'Schema private tertutup dari role client',
  not has_schema_privilege('anon', 'private', 'usage')
    and not has_schema_privilege('authenticated', 'private', 'usage')
    and has_schema_privilege('service_role', 'private', 'usage'),
  'Hanya service_role memperoleh USAGE pada schema private'

union all

select
  'Trigger profil Auth terpasang',
  exists (
    select 1 from pg_trigger as t
    where t.tgrelid = 'auth.users'::regclass
      and t.tgname = 'auth_user_profile_provisioning'
      and not t.tgisinternal
  ),
  'auth_user_profile_provisioning pada auth.users'

union all

select
  'Seluruh kategori sintetis tersedia',
  count(c.slug) = 10,
  coalesce(string_agg(e.slug, ', ' order by e.slug)
    filter (where c.slug is null), 'Tidak ada kategori yang hilang')
from (values
  ('kesehatan-umum'),
  ('kesehatan-reproduksi'),
  ('kesehatan-mental'),
  ('tekanan-akademik'),
  ('permasalahan-keluarga'),
  ('perundungan'),
  ('kekerasan-fisik'),
  ('kekerasan-verbal'),
  ('edukasi-remaja'),
  ('beasiswa-pendidikan')
) as e(slug)
left join public.categories as c on c.slug = e.slug;
