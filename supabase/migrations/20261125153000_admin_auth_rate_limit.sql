-- Keep the existing rate-limit storage intact while narrowing the application RPC to admin authentication.
create function public.consume_auth_rate_limit(p_scope text, p_key_hash text)
returns table (allowed boolean, retry_after_seconds integer)
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_window_seconds integer := 900;
  v_started_at timestamptz;
  v_attempts integer;
  v_now timestamptz := pg_catalog.clock_timestamp();
begin
  if p_scope is distinct from 'auth'
    or p_key_hash is null
    or p_key_hash !~ '^[a-f0-9]{64}$' then
    raise exception using errcode = '22023', message = 'Parameter pembatasan laju tidak valid.';
  end if;

  delete from private.rate_limit_buckets as bucket
    where bucket.window_started_at < v_now - interval '1 day';

  insert into private.rate_limit_buckets as current_bucket
    (scope, rate_key_hash, window_started_at, attempts)
  values ('auth', p_key_hash, v_now, 1)
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
    v_attempts <= 10,
    case when v_attempts <= 10 then 0 else greatest(
      1,
      ceil(extract(epoch from v_started_at
        + pg_catalog.make_interval(secs => v_window_seconds) - v_now))::integer
    ) end;
end;
$$;

revoke all on function public.consume_auth_rate_limit(text, text)
  from public, anon, authenticated;
grant execute on function public.consume_auth_rate_limit(text, text)
  to service_role;

comment on function public.consume_auth_rate_limit(text, text) is
  'Rate limit server-only untuk login admin; scope lama tidak dipakai oleh aplikasi.';
