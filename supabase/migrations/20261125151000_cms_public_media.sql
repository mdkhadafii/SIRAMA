-- Public media is limited to admin-uploaded educational illustrations and editorial images.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('sirama-content', 'sirama-content', true, 5242880, array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists sirama_content_public_read on storage.objects;
create policy sirama_content_public_read on storage.objects
  for select to anon, authenticated using (bucket_id = 'sirama-content');

drop policy if exists sirama_content_admin_insert on storage.objects;
create policy sirama_content_admin_insert on storage.objects
  for insert to authenticated with check (bucket_id = 'sirama-content' and private.is_sirama_admin());

drop policy if exists sirama_content_admin_delete on storage.objects;
create policy sirama_content_admin_delete on storage.objects
  for delete to authenticated using (bucket_id = 'sirama-content' and private.is_sirama_admin());
