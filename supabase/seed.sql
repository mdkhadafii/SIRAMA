insert into public.categories (name, slug, type, description)
values
  ('Kesehatan Umum', 'kesehatan-umum', 'health', 'Kategori demo sintetis.'),
  ('Kesehatan Reproduksi', 'kesehatan-reproduksi', 'health', 'Kategori demo sintetis.'),
  ('Kesehatan Mental', 'kesehatan-mental', 'counseling', 'Kategori demo sintetis.'),
  ('Tekanan Akademik', 'tekanan-akademik', 'counseling', 'Kategori demo sintetis.'),
  ('Permasalahan Keluarga', 'permasalahan-keluarga', 'counseling', 'Kategori demo sintetis.'),
  ('Perundungan', 'perundungan', 'report', 'Kategori demo sintetis.'),
  ('Kekerasan Fisik', 'kekerasan-fisik', 'report', 'Kategori demo sintetis.'),
  ('Kekerasan Verbal', 'kekerasan-verbal', 'report', 'Kategori demo sintetis.'),
  ('Edukasi Remaja', 'edukasi-remaja', 'article', 'Kategori konten demo.'),
  ('Beasiswa Pendidikan', 'beasiswa-pendidikan', 'scholarship', 'Kategori informasi demo.')
on conflict (slug) do nothing;
