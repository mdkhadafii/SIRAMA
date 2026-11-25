-- Seed editorial SIRAMA; aman dijalankan ulang dan tidak menimpa perubahan admin.
-- Jalankan setelah 20261125150000_public_information_cms.sql.

insert into public.categories (name, slug, type, description) values
  ('Kesehatan Remaja', 'sirama-kesehatan-remaja', 'health', 'Informasi kesehatan remaja.'),
  ('Kesehatan Mental', 'sirama-kesehatan-mental', 'counseling', 'Informasi psikologis dan kesehatan mental.'),
  ('Keselamatan Remaja', 'sirama-keselamatan-remaja', 'report', 'Informasi kekerasan, perundungan, dan perlindungan.'),
  ('Pendidikan Remaja', 'sirama-pendidikan', 'article', 'Informasi pendidikan dan pengembangan diri.'),
  ('Beasiswa', 'sirama-beasiswa', 'scholarship', 'Informasi program beasiswa resmi.')
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kemendikdasmen: Kapan Siswa Perlu Cerita kepada Guru Bimbingan dan Konseling?',
  'https://ditsmp.kemendikdasmen.go.id/berita/kapan-siswa-perlu-cerita-kepada-guru-bimbingan-dan-konseling-bk',
  '2026-11-25'
from public.articles a
where a.slug in ('keterampilan-remaja', 'perencanaan-karier', 'potensi-diri')
and not exists (
  select 1 from public.article_sources existing
  where existing.article_id = a.id
    and existing.url = 'https://ditsmp.kemendikdasmen.go.id/berita/kapan-siswa-perlu-cerita-kepada-guru-bimbingan-dan-konseling-bk'
);

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, seed.question, seed.answer, seed.display_order, true, 'published'
from (values
  ('persiapan-melanjutkan-pendidikan', 'Kapan sebaiknya mulai menyiapkan pilihan setelah lulus?', 'Mulai bertahap dengan mencari informasi jenjang, biaya, minat, dan jadwal resmi. Guru BK atau orang dewasa tepercaya dapat membantu membandingkan pilihan.', 1),
  ('persiapan-melanjutkan-pendidikan', 'Bagaimana jika biaya menjadi kendala?', 'Periksa bantuan pendidikan pada situs resmi pemerintah atau kampus dan pastikan syarat serta periode masih berlaku.', 2),
  ('keterampilan-remaja', 'Keterampilan apa yang perlu saya pelajari?', 'Mulai dari hal yang ingin dicoba dan kebutuhan belajar atau kegiatanmu. Tidak ada satu daftar yang wajib untuk semua orang.', 1),
  ('keterampilan-remaja', 'Apakah harus membeli kursus berbayar?', 'Tidak. Kamu bisa mulai lewat proyek sederhana, perpustakaan, kegiatan sekolah, atau sumber belajar gratis yang penyelenggarannya jelas.', 2),
  ('perencanaan-karier', 'Apakah saya harus menentukan karier sekarang?', 'Tidak. Kamu dapat mengeksplorasi minat dan informasi, lalu meninjau pilihan seiring pengalaman dan tahap pendidikan.', 1),
  ('perencanaan-karier', 'Siapa yang bisa membantu merencanakan karier?', 'Guru BK, keluarga yang aman, alumni, dan sumber resmi pendidikan dapat membantu menjelaskan pilihan tanpa memaksa satu keputusan.', 2),
  ('potensi-diri', 'Bagaimana jika saya belum tahu potensi saya?', 'Tidak apa-apa. Coba kegiatan baru secara bertahap, perhatikan hal yang membuatmu tertarik, dan mintalah umpan balik yang membangun.', 1),
  ('potensi-diri', 'Apakah potensi harus selalu berupa prestasi akademik?', 'Tidak. Minat, kepedulian, kreativitas, ketekunan, dan kemampuan bekerja sama juga dapat menjadi kekuatan yang berkembang.', 2),
  ('memeriksa-informasi-program', 'Bagaimana memastikan beasiswa masih dibuka?', 'Periksa tanggal terbaru di situs resmi penyelenggara. Jangan mengandalkan poster atau ringkasan lama.', 1),
  ('memeriksa-informasi-program', 'Apakah SIRAMA meminta data untuk pendaftaran?', 'Tidak. Proses pendaftaran hanya dilakukan melalui kanal resmi penyelenggara; SIRAMA tidak meminta dokumen atau kata sandi.', 2)
) as seed(slug, question, answer, display_order)
join public.articles a on a.slug = seed.slug
where not exists (
  select 1 from public.faqs existing
  where existing.article_id = a.id and existing.question = seed.question
);

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Kesehatan reproduksi remaja', 'kesehatan-reproduksi', 'Memahami tubuh, relasi yang saling menghormati, dan cara menjaga kesehatan reproduksi.', '## Memahami topik

Kesehatan reproduksi mencakup keadaan fisik, mental, dan sosial yang berkaitan dengan sistem serta fungsi reproduksi. Memahami informasi yang tepat membantu remaja menjaga diri dan mengetahui kapan perlu bertanya kepada tenaga kesehatan.

## Faktor yang dapat berperan

- Perubahan pubertas dan informasi yang belum dipahami
- Tekanan teman sebaya atau informasi daring yang tidak terverifikasi
- Kesulitan mengakses orang dewasa atau tenaga kesehatan tepercaya

## Tanda yang dapat diperhatikan

- Pertanyaan tentang perubahan tubuh, batas pribadi, atau relasi
- Kebingungan setelah membaca informasi yang berbeda-beda
- Rasa tidak nyaman atau keluhan pada tubuh yang menetap

## Dampak yang mungkin dirasakan

Informasi yang tidak tepat dapat membuat seseorang menunda perawatan atau merasa takut bertanya. Setiap orang berhak memperoleh informasi kesehatan yang sesuai usia dan menghormati martabatnya.

## Langkah pencegahan

- Gunakan sumber kesehatan resmi dan tenaga kesehatan berkompeten
- Kenali batas tubuh dan hormati persetujuan serta batas orang lain
- Bicarakan pertanyaan dengan orang dewasa yang aman atau petugas kesehatan

## Yang dapat dilakukan sekarang

- Tuliskan pertanyaan umum untuk dibawa saat konsultasi; jangan kirim identitas melalui situs ini
- Hindari mencoba obat atau tindakan berdasarkan unggahan media sosial
- Cari layanan kesehatan yang jelas kewenangan dan privasinya

## Kapan mencari bantuan

Cari bantuan tenaga kesehatan bila ada keluhan fisik, kekhawatiran, atau pengalaman yang membuatmu tidak aman. Untuk kekerasan, utamakan tempat aman dan hubungi orang dewasa tepercaya atau SAPA 129.', 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025', 'published', now(), 'health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'JDIH Kementerian Kesehatan: Permenkes No. 2 Tahun 2025 tentang Penyelenggaraan Upaya Kesehatan Reproduksi', 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025', '2026-11-25' from public.articles a where a.slug = 'kesehatan-reproduksi'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian Kesehatan: Menjaga Kesehatan Remaja di Tengah Perubahan Fisik', 'https://upk.kemkes.go.id/new/menjaga-kesehatan-remaja-di-tengah-perubahan-fisik-tekanan-sosial-dan-gaya-hidup', '2026-11-25' from public.articles a where a.slug = 'kesehatan-reproduksi'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://upk.kemkes.go.id/new/menjaga-kesehatan-remaja-di-tengah-perubahan-fisik-tekanan-sosial-dan-gaya-hidup');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah wajar merasa malu bertanya?', 'Ya, banyak orang merasa sungkan. Kamu boleh menyiapkan pertanyaan tertulis dan meminta penjelasan dengan bahasa yang mudah dipahami.', 1, true, 'published' from public.articles a where a.slug = 'kesehatan-reproduksi'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah wajar merasa malu bertanya?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah SIRAMA dapat memberi diagnosis?', 'Tidak. Halaman ini untuk edukasi umum dan tidak menggantikan pemeriksaan atau nasihat tenaga kesehatan.', 2, true, 'published' from public.articles a where a.slug = 'kesehatan-reproduksi'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah SIRAMA dapat memberi diagnosis?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Ke mana bertanya tentang kesehatan reproduksi?', 'Kamu dapat bertanya kepada tenaga kesehatan di fasilitas yang berwenang. Pastikan informasi layanan dan privasinya terlebih dahulu.', 3, true, 'published' from public.articles a where a.slug = 'kesehatan-reproduksi'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Ke mana bertanya tentang kesehatan reproduksi?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Pubertas dan perubahan fisik', 'pubertas', 'Mengenali perubahan pubertas tanpa membandingkan tubuhmu dengan orang lain.', '## Memahami topik

Pubertas adalah masa ketika tubuh berkembang menuju kematangan reproduksi. Waktu mulai dan urutan perubahan bisa berbeda pada tiap orang; perbedaan itu tidak otomatis berarti ada masalah.

## Faktor yang dapat berperan

- Faktor keturunan dan perkembangan individu
- Kondisi kesehatan dan gizi dapat berpengaruh terhadap perkembangan
- Membandingkan diri dengan teman atau konten daring

## Tanda yang dapat diperhatikan

- Pertumbuhan tinggi dan perubahan bentuk tubuh
- Perubahan suara, kulit, rambut tubuh, atau menstruasi
- Perubahan emosi dan kebutuhan akan ruang pribadi

## Dampak yang mungkin dirasakan

Perubahan yang tidak dipahami dapat menimbulkan cemas atau rasa tidak percaya diri. Informasi yang tenang dan terpercaya membantu remaja mengenali tubuh tanpa stigma.

## Langkah pencegahan

- Pahami bahwa ritme perkembangan setiap orang berbeda
- Jaga kebersihan diri dan kebiasaan hidup sehat
- Bicarakan kekhawatiran dengan orang dewasa aman atau tenaga kesehatan

## Yang dapat dilakukan sekarang

- Cari informasi dari sumber kesehatan resmi
- Catat perubahan atau keluhan yang ingin ditanyakan
- Jangan mencoba suplemen atau obat untuk mengubah pubertas tanpa arahan tenaga kesehatan

## Kapan mencari bantuan

Konsultasikan dengan tenaga kesehatan jika perubahan tubuh atau keluhan membuatmu khawatir, terasa mengganggu, atau membutuhkan pemeriksaan.', 'https://upk.kemkes.go.id/new/menjaga-kesehatan-remaja-di-tengah-perubahan-fisik-tekanan-sosial-dan-gaya-hidup', 'published', now(), 'health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian Kesehatan: Menjaga Kesehatan Remaja di Tengah Perubahan Fisik', 'https://upk.kemkes.go.id/new/menjaga-kesehatan-remaja-di-tengah-perubahan-fisik-tekanan-sosial-dan-gaya-hidup', '2026-11-25' from public.articles a where a.slug = 'pubertas'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://upk.kemkes.go.id/new/menjaga-kesehatan-remaja-di-tengah-perubahan-fisik-tekanan-sosial-dan-gaya-hidup');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'JDIH Kementerian Kesehatan: Permenkes No. 2 Tahun 2025 tentang Penyelenggaraan Upaya Kesehatan Reproduksi', 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025', '2026-11-25' from public.articles a where a.slug = 'pubertas'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah semua remaja mengalami pubertas pada waktu yang sama?', 'Tidak. Waktu dan urutan perubahan berbeda. Tenaga kesehatan dapat membantu menilai kekhawatiran berdasarkan kondisi masing-masing.', 1, true, 'published' from public.articles a where a.slug = 'pubertas'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah semua remaja mengalami pubertas pada waktu yang sama?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah perubahan emosi saat pubertas selalu berarti gangguan?', 'Tidak. Emosi dapat berubah karena banyak hal. Jika perubahan terasa berat atau mengganggu keseharian, bicarakan dengan orang tepercaya atau profesional.', 2, true, 'published' from public.articles a where a.slug = 'pubertas'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah perubahan emosi saat pubertas selalu berarti gangguan?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bolehkah memakai obat untuk mempercepat atau menunda pubertas?', 'Jangan memakai obat atau hormon tanpa pemeriksaan dan arahan tenaga kesehatan.', 3, true, 'published' from public.articles a where a.slug = 'pubertas'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bolehkah memakai obat untuk mempercepat atau menunda pubertas?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Kebersihan diri dan organ reproduksi', 'kebersihan-diri', 'Kebiasaan sederhana untuk menjaga kenyamanan dan kebersihan tubuh.', '## Memahami topik

Kebersihan diri merupakan bagian dari perawatan kesehatan sehari-hari. Saat pubertas, perubahan keringat dan tubuh dapat membuat rutinitas kebersihan terasa berbeda.

## Faktor yang dapat berperan

- Kebiasaan perawatan diri yang belum terbentuk
- Keterbatasan akses terhadap air bersih atau perlengkapan kebersihan
- Informasi yang menyarankan produk berpewangi atau tindakan yang tidak diperlukan

## Tanda yang dapat diperhatikan

- Bau badan atau rasa tidak nyaman setelah aktivitas
- Iritasi atau keluhan yang berulang
- Kebingungan memilih cara merawat organ reproduksi

## Dampak yang mungkin dirasakan

Mengabaikan kebersihan atau menggunakan produk yang mengiritasi dapat membuat tubuh tidak nyaman. Keluhan berulang sebaiknya dibicarakan dengan tenaga kesehatan.

## Langkah pencegahan

- Mandi dan ganti pakaian dalam secara teratur sesuai kebutuhan
- Bersihkan area luar tubuh dengan lembut; hindari pewangi dan pembersih keras
- Gunakan pakaian bersih dan kering serta jangan berbagi barang pribadi

## Yang dapat dilakukan sekarang

- Hentikan produk yang terasa menyebabkan iritasi
- Jaga area tetap bersih dan kering
- Tanyakan kepada tenaga kesehatan sebelum memakai obat atau produk khusus

## Kapan mencari bantuan

Mintalah pemeriksaan tenaga kesehatan bila ada nyeri, luka, gatal berat, cairan yang tidak biasa, atau keluhan yang berulang.', 'https://ayosehat.kemkes.go.id/pentingnya-menjaga-kebersihan-alat-reproduksi-pada-remaja-pria-dan-wanita', 'published', now(), 'health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian Kesehatan: Menjaga Kebersihan Alat Reproduksi pada Remaja', 'https://ayosehat.kemkes.go.id/pentingnya-menjaga-kebersihan-alat-reproduksi-pada-remaja-pria-dan-wanita', '2026-11-25' from public.articles a where a.slug = 'kebersihan-diri'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://ayosehat.kemkes.go.id/pentingnya-menjaga-kebersihan-alat-reproduksi-pada-remaja-pria-dan-wanita');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'JDIH Kementerian Kesehatan: Permenkes No. 2 Tahun 2025 tentang Penyelenggaraan Upaya Kesehatan Reproduksi', 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025', '2026-11-25' from public.articles a where a.slug = 'kebersihan-diri'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah perlu memakai sabun berpewangi di area intim?', 'Tidak perlu menggunakan pewangi atau pembersih keras. Ikuti anjuran tenaga kesehatan bila ada keluhan.', 1, true, 'published' from public.articles a where a.slug = 'kebersihan-diri'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah perlu memakai sabun berpewangi di area intim?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah keluhan gatal pasti infeksi?', 'Tidak dapat dipastikan dari satu gejala. Penyebabnya beragam dan perlu dinilai tenaga kesehatan bila menetap.', 2, true, 'published' from public.articles a where a.slug = 'kebersihan-diri'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah keluhan gatal pasti infeksi?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa yang dilakukan bila suatu produk menimbulkan iritasi?', 'Hentikan pemakaian produk tersebut dan cari saran tenaga kesehatan jika iritasi berlanjut.', 3, true, 'published' from public.articles a where a.slug = 'kebersihan-diri'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa yang dilakukan bila suatu produk menimbulkan iritasi?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Menstruasi', 'menstruasi', 'Informasi dasar tentang siklus menstruasi, kebersihan, dan kapan perlu memeriksakan diri.', '## Memahami topik

Menstruasi merupakan bagian dari siklus reproduksi. Pola dapat berbeda pada masa awal menstruasi, tetapi keluhan yang berat atau mengganggu tetap layak dibicarakan dengan tenaga kesehatan.

## Faktor yang dapat berperan

- Perubahan hormon dan tahap perkembangan
- Stres, kondisi kesehatan, dan perubahan rutinitas dapat berpengaruh pada siklus
- Informasi keliru atau rasa malu untuk meminta perlengkapan

## Tanda yang dapat diperhatikan

- Perdarahan berkala dan kram pada sebagian orang
- Perubahan suasana hati atau energi yang bervariasi
- Perubahan pola yang terasa berbeda dari biasanya

## Dampak yang mungkin dirasakan

Kurangnya informasi atau akses perlengkapan dapat mengganggu kegiatan sekolah dan rasa nyaman. Menstruasi bukan sesuatu yang perlu dipermalukan.

## Langkah pencegahan

- Catat tanggal dan keluhan bila itu membantu memahami pola
- Ganti pembalut secara berkala sesuai kebutuhan dan cuci tangan
- Siapkan perlengkapan menstruasi dan minta bantuan bila akses terbatas

## Yang dapat dilakukan sekarang

- Beristirahat dan minum cukup sesuai kebutuhan
- Gunakan cara nyaman yang aman; jangan minum obat tanpa membaca petunjuk atau saran tenaga kesehatan
- Bicarakan keluhan dengan orang dewasa tepercaya atau tenaga kesehatan

## Kapan mencari bantuan

Segera cari bantuan medis bila perdarahan sangat banyak, nyeri berat, pingsan, atau ada kondisi yang terasa darurat. Untuk pola yang terus mengganggu, jadwalkan konsultasi tenaga kesehatan.', 'https://ayosehat.kemkes.go.id/pentingnya-menjaga-kebersihan-alat-reproduksi-pada-remaja-pria-dan-wanita', 'published', now(), 'health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian Kesehatan: Menjaga Kebersihan Alat Reproduksi pada Remaja', 'https://ayosehat.kemkes.go.id/pentingnya-menjaga-kebersihan-alat-reproduksi-pada-remaja-pria-dan-wanita', '2026-11-25' from public.articles a where a.slug = 'menstruasi'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://ayosehat.kemkes.go.id/pentingnya-menjaga-kebersihan-alat-reproduksi-pada-remaja-pria-dan-wanita');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'JDIH Kementerian Kesehatan: Permenkes No. 2 Tahun 2025 tentang Penyelenggaraan Upaya Kesehatan Reproduksi', 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025', '2026-11-25' from public.articles a where a.slug = 'menstruasi'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah siklus yang belum teratur selalu berbahaya?', 'Tidak selalu, terutama pada masa awal. Namun perubahan menetap atau keluhan yang mengganggu sebaiknya dinilai tenaga kesehatan.', 1, true, 'published' from public.articles a where a.slug = 'menstruasi'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah siklus yang belum teratur selalu berbahaya?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana menjaga kebersihan saat menstruasi?', 'Ganti pembalut sesuai kebutuhan, cuci tangan sebelum dan sesudah, dan buang pembalut dengan cara yang menjaga kebersihan.', 2, true, 'published' from public.articles a where a.slug = 'menstruasi'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana menjaga kebersihan saat menstruasi?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Kapan nyeri menstruasi perlu dibicarakan dengan petugas?', 'Jika nyeri berat, mengganggu sekolah atau kegiatan, atau disertai keluhan lain, mintalah pemeriksaan.', 3, true, 'published' from public.articles a where a.slug = 'menstruasi'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Kapan nyeri menstruasi perlu dibicarakan dengan petugas?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Pola makan dan gizi seimbang', 'gizi-seimbang', 'Membangun kebiasaan makan beragam tanpa diet ekstrem atau rasa bersalah terhadap makanan.', '## Memahami topik

Masa remaja melibatkan pertumbuhan dan kebutuhan gizi. Pedoman Isi Piringku Kementerian Kesehatan mendorong variasi makanan dan keseimbangan porsi, bukan satu jenis makanan yang dianggap ajaib.

## Faktor yang dapat berperan

- Jadwal sekolah dan aktivitas yang padat
- Akses dan kebiasaan keluarga
- Tekanan citra tubuh dan informasi diet dari media sosial

## Tanda yang dapat diperhatikan

- Melewatkan makan karena jadwal atau aturan diet
- Kebingungan memilih makanan karena banyak saran yang bertentangan
- Perubahan energi atau kebugaran yang perlu dinilai secara menyeluruh

## Dampak yang mungkin dirasakan

Pola makan yang terlalu membatasi dapat menyulitkan pemenuhan kebutuhan tubuh. Perubahan energi tidak cukup untuk menyimpulkan kondisi gizi atau penyakit.

## Langkah pencegahan

- Usahakan makanan beragam sesuai akses dan kebiasaan keluarga
- Ikuti pedoman gizi seimbang, minum air, dan bergerak sesuai kemampuan
- Hindari diet ekstrem, produk pelangsing, atau suplemen tanpa arahan ahli

## Yang dapat dilakukan sekarang

- Mulai dengan satu kebiasaan yang realistis, misalnya sarapan atau menambah variasi
- Jika ada kesulitan makan, bicarakan dengan orang dewasa aman atau tenaga kesehatan
- Jangan gunakan informasi ini untuk mendiagnosis kekurangan gizi

## Kapan mencari bantuan

Bicarakan dengan tenaga kesehatan atau ahli gizi bila perubahan makan, berat badan, atau energi mengganggu kesehatan atau kegiatan sehari-hari.', 'https://ayosehat.kemkes.go.id/isi-piringku-kebutuhan-gizi-harian-seimbang', 'published', now(), 'health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian Kesehatan: Isi Piringku', 'https://ayosehat.kemkes.go.id/isi-piringku-kebutuhan-gizi-harian-seimbang', '2026-11-25' from public.articles a where a.slug = 'gizi-seimbang'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://ayosehat.kemkes.go.id/isi-piringku-kebutuhan-gizi-harian-seimbang');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'JDIH Kementerian Kesehatan: Permenkes No. 2 Tahun 2025 tentang Penyelenggaraan Upaya Kesehatan Reproduksi', 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025', '2026-11-25' from public.articles a where a.slug = 'gizi-seimbang'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah ada satu menu yang cocok untuk semua remaja?', 'Tidak. Kebutuhan dan akses berbeda. Pedoman umum membantu, tetapi tenaga kesehatan dapat memberi saran yang sesuai kondisi seseorang.', 1, true, 'published' from public.articles a where a.slug = 'gizi-seimbang'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah ada satu menu yang cocok untuk semua remaja?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah saya perlu menghindari semua makanan tertentu?', 'Tidak ada larangan umum yang berlaku untuk semua orang. Hindari aturan ekstrem dan tanyakan kepada tenaga kesehatan bila ada kondisi khusus.', 2, true, 'published' from public.articles a where a.slug = 'gizi-seimbang'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah saya perlu menghindari semua makanan tertentu?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah suplemen selalu diperlukan?', 'Tidak. Suplemen perlu digunakan sesuai kebutuhan dan arahan tenaga kesehatan.', 3, true, 'published' from public.articles a where a.slug = 'gizi-seimbang'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah suplemen selalu diperlukan?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Anemia pada remaja', 'anemia', 'Mengenali kemungkinan tanda anemia dan pentingnya pemeriksaan, bukan menebak diagnosis sendiri.', '## Memahami topik

Anemia adalah kondisi yang perlu dinilai melalui pemeriksaan. Kementerian Kesehatan menyebut rasa lelah, lemah, pucat, pusing, atau sulit berkonsentrasi sebagai gejala yang dapat muncul; tanda tersebut juga dapat memiliki penyebab lain.

## Faktor yang dapat berperan

- Kebutuhan zat besi meningkat selama pertumbuhan
- Asupan zat besi yang tidak mencukupi
- Menstruasi dapat menjadi salah satu faktor yang perlu dinilai tenaga kesehatan

## Tanda yang dapat diperhatikan

- Lelah atau lemah
- Pucat, pusing, atau sulit berkonsentrasi
- Keluhan lain yang menetap atau mengganggu aktivitas

## Dampak yang mungkin dirasakan

Bila tidak dikenali, keluhan anemia dapat memengaruhi kebugaran dan kegiatan harian. Gejala saja tidak cukup untuk memastikan anemia.

## Langkah pencegahan

- Konsumsi makanan beragam sesuai pedoman gizi seimbang
- Ikuti program skrining dan suplementasi dari tenaga kesehatan atau sekolah
- Jangan mengonsumsi tablet tambah darah sebagai pengganti pemeriksaan bila ada keluhan

## Yang dapat dilakukan sekarang

- Ceritakan keluhan kepada orang dewasa tepercaya
- Minta penilaian di fasilitas kesehatan, terutama jika keluhan berulang
- Gunakan suplemen hanya sesuai petunjuk tenaga kesehatan atau program resmi

## Kapan mencari bantuan

Cari penilaian tenaga kesehatan jika lelah, pucat, pusing, atau sulit berkonsentrasi berlangsung atau mengganggu kegiatan. Kondisi berat atau pingsan perlu pertolongan segera.', 'https://ayosehat.kemkes.go.id/topik-penyakit/defisiensi-nutrisi/anemia', 'published', now(), 'health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian Kesehatan: Anemia', 'https://ayosehat.kemkes.go.id/topik-penyakit/defisiensi-nutrisi/anemia', '2026-11-25' from public.articles a where a.slug = 'anemia'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://ayosehat.kemkes.go.id/topik-penyakit/defisiensi-nutrisi/anemia');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'JDIH Kementerian Kesehatan: Permenkes No. 2 Tahun 2025 tentang Penyelenggaraan Upaya Kesehatan Reproduksi', 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025', '2026-11-25' from public.articles a where a.slug = 'anemia'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah lelah berarti saya anemia?', 'Belum tentu. Lelah punya banyak penyebab dan anemia perlu dipastikan melalui penilaian atau pemeriksaan.', 1, true, 'published' from public.articles a where a.slug = 'anemia'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah lelah berarti saya anemia?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bolehkah minum tablet tambah darah sendiri?', 'Ikuti petunjuk tenaga kesehatan atau program resmi. Jangan menggandakan dosis atau memakai suplemen tanpa arahan.', 2, true, 'published' from public.articles a where a.slug = 'anemia'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bolehkah minum tablet tambah darah sendiri?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Ke mana saya bisa melakukan skrining?', 'Tanyakan fasilitas kesehatan atau petugas kesehatan sekolah yang berwenang tentang layanan skrining yang tersedia.', 3, true, 'published' from public.articles a where a.slug = 'anemia'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Ke mana saya bisa melakukan skrining?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Kesehatan seksual dan reproduksi', 'kesehatan-seksual-reproduksi', 'Belajar tentang batas diri, relasi sehat, dan informasi reproduksi yang sesuai usia.', '## Memahami topik

Informasi kesehatan seksual dan reproduksi yang sesuai usia membantu remaja memahami tubuh, risiko, perlindungan diri, serta hak untuk mendapat layanan yang menghormati martabat.

## Faktor yang dapat berperan

- Informasi yang tidak sesuai atau tidak dapat diverifikasi
- Tekanan relasi, teman sebaya, atau media
- Sulit berbicara dengan orang dewasa atau tenaga kesehatan tepercaya

## Tanda yang dapat diperhatikan

- Pertanyaan tentang persetujuan, batas pribadi, atau kesehatan tubuh
- Kekhawatiran setelah mengalami tekanan atau sentuhan yang tidak diinginkan
- Keluhan fisik yang membuat tidak nyaman

## Dampak yang mungkin dirasakan

Informasi yang keliru dapat meningkatkan risiko kesehatan dan membuat seseorang sulit mencari pertolongan. Tidak ada seorang pun yang berhak memaksa atau menyentuh tubuhmu tanpa persetujuan.

## Langkah pencegahan

- Pelajari tubuh dan perlindungan diri dari sumber kesehatan resmi
- Bangun relasi yang menghormati batas, persetujuan, dan keselamatan
- Cari layanan kesehatan yang sesuai dan berkompeten bila ada pertanyaan

## Yang dapat dilakukan sekarang

- Jika merasa ditekan atau tidak aman, pindah ke tempat yang aman dan hubungi orang dewasa tepercaya
- Jangan menghadapi orang yang membuatmu takut sendirian jika ada risiko
- Untuk kekerasan pada anak/perempuan, kanal resmi SAPA 129 tersedia

## Kapan mencari bantuan

Untuk keluhan kesehatan, cari tenaga kesehatan. Jika ada pemaksaan, pelecehan, atau kekerasan, utamakan keselamatan dan hubungi orang dewasa aman atau SAPA 129.', 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025', 'published', now(), 'health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'JDIH Kementerian Kesehatan: Permenkes No. 2 Tahun 2025 tentang Penyelenggaraan Upaya Kesehatan Reproduksi', 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025', '2026-11-25' from public.articles a where a.slug = 'kesehatan-seksual-reproduksi'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian PPPA: SAPA 129', 'https://laporsapa129.kemenpppa.go.id/', '2026-11-25' from public.articles a where a.slug = 'kesehatan-seksual-reproduksi'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://laporsapa129.kemenpppa.go.id/');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa yang dimaksud persetujuan?', 'Persetujuan harus diberikan secara bebas, tanpa tekanan, dan dapat ditarik. Jika kamu merasa dipaksa atau takut, cari bantuan orang dewasa aman.', 1, true, 'published' from public.articles a where a.slug = 'kesehatan-seksual-reproduksi'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa yang dimaksud persetujuan?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah SIRAMA memberi nasihat klinis?', 'Tidak. SIRAMA menyediakan edukasi umum dan tautan ke sumber resmi.', 2, true, 'published' from public.articles a where a.slug = 'kesehatan-seksual-reproduksi'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah SIRAMA memberi nasihat klinis?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa yang harus dilakukan jika batas tubuh dilanggar?', 'Pergi ke tempat aman bila memungkinkan, hubungi orang yang dipercaya, dan cari bantuan layanan perlindungan atau kesehatan.', 3, true, 'published' from public.articles a where a.slug = 'kesehatan-seksual-reproduksi'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa yang harus dilakukan jika batas tubuh dilanggar?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Pencegahan infeksi menular seksual', 'pencegahan-ims', 'Informasi netral tentang pencegahan, pemeriksaan, dan layanan kesehatan yang menjaga privasi.', '## Memahami topik

Infeksi menular seksual (IMS) merupakan kelompok infeksi yang perlu dicegah dan ditangani oleh tenaga kesehatan. Informasi online tidak dapat memastikan ada atau tidaknya infeksi.

## Faktor yang dapat berperan

- Kontak seksual tanpa perlindungan
- Tidak melakukan pemeriksaan saat ada pajanan atau keluhan
- Stigma atau hambatan untuk mengakses layanan

## Tanda yang dapat diperhatikan

- Sebagian IMS dapat tidak menimbulkan gejala yang jelas
- Keluhan dapat berupa perubahan pada area genital atau nyeri, tetapi tandanya tidak spesifik
- Hanya pemeriksaan tenaga kesehatan dapat menilai kondisi

## Dampak yang mungkin dirasakan

IMS yang tidak ditangani dapat menimbulkan dampak kesehatan. Penilaian lebih awal membantu seseorang mendapatkan informasi dan perawatan yang sesuai.

## Langkah pencegahan

- Pelajari pencegahan dari tenaga kesehatan dan sumber resmi
- Hindari berbagi alat suntik atau benda yang dapat membawa darah
- Jika merasa berisiko, cari layanan kesehatan untuk informasi pencegahan dan pemeriksaan

## Yang dapat dilakukan sekarang

- Jangan mencoba mendiagnosis dari foto atau daftar gejala internet
- Jangan memakai antibiotik atau obat orang lain
- Cari layanan kesehatan yang menjaga privasi dan menjelaskan pilihan pemeriksaan

## Kapan mencari bantuan

Konsultasikan dengan tenaga kesehatan setelah kemungkinan pajanan atau bila ada keluhan. Penanganan dini dan pemeriksaan profesional lebih aman daripada menunda atau mengobati sendiri.', 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-3-tahun-2026', 'published', now(), 'health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'JDIH Kementerian Kesehatan: Permenkes No. 3 Tahun 2026 tentang Penanggulangan Penyakit', 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-3-tahun-2026', '2026-11-25' from public.articles a where a.slug = 'pencegahan-ims'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-3-tahun-2026');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'JDIH Kementerian Kesehatan: Permenkes No. 2 Tahun 2025 tentang Penyelenggaraan Upaya Kesehatan Reproduksi', 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025', '2026-11-25' from public.articles a where a.slug = 'pencegahan-ims'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah IMS selalu memiliki gejala?', 'Tidak. Sebagian infeksi dapat tidak menunjukkan gejala. Pemeriksaan tenaga kesehatan diperlukan bila ada kemungkinan pajanan.', 1, true, 'published' from public.articles a where a.slug = 'pencegahan-ims'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah IMS selalu memiliki gejala?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah saya bisa memastikan IMS dari gejala?', 'Tidak. Gejala dapat serupa dengan kondisi lain dan pemeriksaan profesional diperlukan.', 2, true, 'published' from public.articles a where a.slug = 'pencegahan-ims'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah saya bisa memastikan IMS dari gejala?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bolehkah memakai obat yang tersisa?', 'Tidak dianjurkan. Obat yang tidak sesuai dapat tidak efektif dan berisiko; mintalah saran tenaga kesehatan.', 3, true, 'published' from public.articles a where a.slug = 'pencegahan-ims'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bolehkah memakai obat yang tersisa?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Pencegahan pernikahan anak', 'pencegahan-pernikahan-anak', 'Mengenali pentingnya perlindungan, pendidikan, dukungan keluarga, dan akses konsultasi yang aman.', '## Memahami topik

Keputusan menikah pada usia anak berkaitan dengan perlindungan, pendidikan, kesehatan, dan kesejahteraan. SIRAMA tidak memberi nasihat hukum individual; keluarga dapat mencari penjelasan dari layanan perlindungan anak dan instansi berwenang.

## Faktor yang dapat berperan

- Tekanan keluarga atau lingkungan
- Kehamilan atau kondisi sosial yang sulit
- Keterbatasan akses terhadap pendidikan dan dukungan

## Tanda yang dapat diperhatikan

- Pembicaraan tentang pernikahan yang disertai tekanan atau ancaman
- Khawatir kehilangan akses sekolah atau dukungan keluarga
- Merasa tidak memiliki ruang untuk menyampaikan pendapat

## Dampak yang mungkin dirasakan

Keputusan yang diambil di bawah paksaan dapat berdampak terhadap keselamatan, kesehatan, pendidikan, dan kesejahteraan. Anak perlu mendapat perlindungan dan dukungan orang dewasa yang aman.

## Langkah pencegahan

- Bangun komunikasi dengan orang dewasa tepercaya yang mengutamakan keselamatan
- Cari konseling dan informasi dari layanan perlindungan anak yang berwenang
- Jaga kesinambungan akses pendidikan dan dukungan sosial bila memungkinkan

## Yang dapat dilakukan sekarang

- Jika ada ancaman, jangan berhadapan sendiri dengan pihak yang menekan
- Hubungi orang dewasa aman, guru BK, pekerja sosial, atau layanan perlindungan
- SAPA 129 menyediakan kanal bantuan untuk kekerasan terhadap anak dan perempuan

## Kapan mencari bantuan

Jika ada paksaan, ancaman, atau bahaya, cari tempat aman dan hubungi orang dewasa tepercaya atau SAPA 129. Untuk pertanyaan hukum, minta pendampingan dari instansi berwenang.', 'https://laporsapa129.kemenpppa.go.id/', 'published', now(), 'health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian PPPA: SAPA 129', 'https://laporsapa129.kemenpppa.go.id/', '2026-11-25' from public.articles a where a.slug = 'pencegahan-pernikahan-anak'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://laporsapa129.kemenpppa.go.id/');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'JDIH Kementerian Kesehatan: Permenkes No. 2 Tahun 2025 tentang Penyelenggaraan Upaya Kesehatan Reproduksi', 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025', '2026-11-25' from public.articles a where a.slug = 'pencegahan-pernikahan-anak'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa yang bisa dilakukan jika saya ditekan untuk menikah?', 'Ceritakan kepada orang dewasa yang aman dan minta bantuan layanan perlindungan anak. Jika ada ancaman, prioritaskan tempat aman.', 1, true, 'published' from public.articles a where a.slug = 'pencegahan-pernikahan-anak'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa yang bisa dilakukan jika saya ditekan untuk menikah?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah SIRAMA dapat memberi keputusan hukum?', 'Tidak. Untuk penjelasan hukum dan layanan resmi, hubungi instansi atau pendamping yang berwenang.', 2, true, 'published' from public.articles a where a.slug = 'pencegahan-pernikahan-anak'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah SIRAMA dapat memberi keputusan hukum?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana jika saya khawatir pendidikan terhenti?', 'Bicarakan dengan guru atau layanan pendidikan yang kamu percaya untuk mencari pilihan dukungan.', 3, true, 'published' from public.articles a where a.slug = 'pencegahan-pernikahan-anak'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana jika saya khawatir pendidikan terhenti?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Perilaku hidup bersih dan sehat', 'perilaku-hidup-bersih-sehat', 'Kebiasaan harian yang mendukung kebersihan, gizi, aktivitas, dan kesehatan remaja.', '## Memahami topik

Perilaku hidup bersih dan sehat (PHBS) mencakup kebiasaan yang mendukung kesehatan diri dan lingkungan. Langkah yang realistis dan dapat dilakukan bersama lebih mudah dijaga daripada perubahan ekstrem.

## Faktor yang dapat berperan

- Akses sarana kebersihan dan air bersih
- Rutinitas sekolah, rumah, dan lingkungan
- Informasi kesehatan yang saling bertentangan

## Tanda yang dapat diperhatikan

- Kebiasaan cuci tangan atau kebersihan yang belum konsisten
- Pola makan, tidur, atau aktivitas yang terasa kurang seimbang
- Kesulitan menjaga rutinitas karena lingkungan atau beban kegiatan

## Dampak yang mungkin dirasakan

Kebiasaan yang mendukung kesehatan membantu kenyamanan dan kesejahteraan sehari-hari. Keterbatasan fasilitas bukan kesalahan individu dan membutuhkan dukungan lingkungan.

## Langkah pencegahan

- Cuci tangan dengan sabun pada waktu penting
- Pilih makanan beragam dan bergerak secara teratur sesuai kemampuan
- Jaga kebersihan diri serta ruang bersama dengan dukungan keluarga/sekolah

## Yang dapat dilakukan sekarang

- Pilih satu kebiasaan kecil untuk mulai diperbaiki
- Minta dukungan keluarga atau sekolah bila fasilitas menjadi hambatan
- Gunakan panduan Kementerian Kesehatan untuk informasi gizi

## Kapan mencari bantuan

Untuk keluhan kesehatan yang menetap, konsultasikan dengan tenaga kesehatan. Jika hambatan utamanya fasilitas lingkungan, sampaikan kepada pihak sekolah atau pengelola setempat.', 'https://ayosehat.kemkes.go.id/isi-piringku-kebutuhan-gizi-harian-seimbang', 'published', now(), 'health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian Kesehatan: Isi Piringku', 'https://ayosehat.kemkes.go.id/isi-piringku-kebutuhan-gizi-harian-seimbang', '2026-11-25' from public.articles a where a.slug = 'perilaku-hidup-bersih-sehat'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://ayosehat.kemkes.go.id/isi-piringku-kebutuhan-gizi-harian-seimbang');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian Kesehatan: Menjaga Kebersihan Alat Reproduksi pada Remaja', 'https://ayosehat.kemkes.go.id/pentingnya-menjaga-kebersihan-alat-reproduksi-pada-remaja-pria-dan-wanita', '2026-11-25' from public.articles a where a.slug = 'perilaku-hidup-bersih-sehat'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://ayosehat.kemkes.go.id/pentingnya-menjaga-kebersihan-alat-reproduksi-pada-remaja-pria-dan-wanita');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Haruskah semua kebiasaan sehat dilakukan sekaligus?', 'Tidak. Mulai dari kebiasaan yang paling mungkin dilakukan dan tambahkan langkah lain secara bertahap.', 1, true, 'published' from public.articles a where a.slug = 'perilaku-hidup-bersih-sehat'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Haruskah semua kebiasaan sehat dilakukan sekaligus?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah kebersihan sepenuhnya tanggung jawab remaja?', 'Tidak. Lingkungan, fasilitas, keluarga, dan sekolah juga berperan menyediakan dukungan.', 2, true, 'published' from public.articles a where a.slug = 'perilaku-hidup-bersih-sehat'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah kebersihan sepenuhnya tanggung jawab remaja?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah pola hidup sehat dapat menggantikan perawatan medis?', 'Tidak. Kebiasaan sehat mendukung kesejahteraan, tetapi tidak menggantikan diagnosis atau perawatan tenaga kesehatan.', 3, true, 'published' from public.articles a where a.slug = 'perilaku-hidup-bersih-sehat'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah pola hidup sehat dapat menggantikan perawatan medis?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Stres pada remaja', 'stres-remaja', 'Memahami respons terhadap tekanan dan menemukan langkah kecil untuk kembali merasa tertata.', '## Memahami topik

Stres adalah respons terhadap tuntutan atau perubahan. Sedikit tekanan dapat dirasakan sebelum tantangan, tetapi stres yang berkepanjangan dan mengganggu keseharian perlu mendapat perhatian.

## Faktor yang dapat berperan

- Tugas sekolah dan target akademik
- Konflik keluarga atau relasi
- Perubahan, ketidakpastian, dan kurang waktu istirahat

## Tanda yang dapat diperhatikan

- Pikiran terus memikirkan masalah
- Mudah lelah, sulit fokus, atau perubahan tidur
- Lebih mudah tersinggung atau menarik diri

## Dampak yang mungkin dirasakan

Stres yang terus berlangsung dapat memengaruhi tidur, belajar, relasi, dan kesehatan. Tanda ini bukan diagnosis dan setiap orang dapat mengalaminya berbeda.

## Langkah pencegahan

- Bagi tugas menjadi langkah kecil dan realistis
- Jaga rutinitas istirahat, makan, dan aktivitas
- Berbagi dengan orang yang aman dan tidak menghakimi

## Yang dapat dilakukan sekarang

- Berhenti sejenak dan pilih satu hal yang dapat dilakukan sekarang
- Gunakan latihan napas atau grounding bila terasa membantu
- Kurangi sumber tekanan yang dapat diatur dan minta bantuan untuk yang sulit

## Kapan mencari bantuan

Cari bantuan profesional bila stres berlangsung lama, terasa berat, mengganggu fungsi harian, atau sulit diatasi sendiri.', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', 'published', now(), 'mental_health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-mental'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'WHO: Mental health of adolescents', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', '2026-11-25' from public.articles a where a.slug = 'stres-remaja'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian Kesehatan: Layanan Healing119.id', 'https://kesprimkom.kemkes.go.id/konten/127/151/0/cegah-bunuh-diri-dukung-kesehatan-jiwa-kenali-layanan-healing119-id', '2026-11-25' from public.articles a where a.slug = 'stres-remaja'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://kesprimkom.kemkes.go.id/konten/127/151/0/cegah-bunuh-diri-dukung-kesehatan-jiwa-kenali-layanan-healing119-id');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa bedanya stres biasa dan stres yang perlu bantuan?', 'Lihat durasi, intensitas, dan dampaknya pada keseharian. Bila tidur, belajar, relasi, atau keselamatan terganggu, bicarakan dengan profesional.', 1, true, 'published' from public.articles a where a.slug = 'stres-remaja'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa bedanya stres biasa dan stres yang perlu bantuan?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana mengelola stres akademik?', 'Pecah tugas, buat jeda realistis, minta bantuan guru, dan prioritaskan istirahat yang cukup.', 2, true, 'published' from public.articles a where a.slug = 'stres-remaja'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana mengelola stres akademik?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah saya harus menyelesaikan semua sendiri?', 'Tidak. Meminta bantuan orang tepercaya atau profesional merupakan langkah yang wajar.', 3, true, 'published' from public.articles a where a.slug = 'stres-remaja'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah saya harus menyelesaikan semua sendiri?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Kecemasan', 'kecemasan', 'Mengenali rasa khawatir dan kapan dukungan profesional dapat membantu.', '## Memahami topik

Kecemasan adalah pengalaman khawatir atau takut yang dapat muncul dalam berbagai situasi. Hanya tenaga profesional yang dapat menilai apakah gejala berkaitan dengan kondisi tertentu.

## Faktor yang dapat berperan

- Tekanan, perubahan, pengalaman sulit, atau masalah relasi
- Kurang istirahat dan beban yang menumpuk
- Faktor biologis dan lingkungan yang berbeda bagi tiap orang

## Tanda yang dapat diperhatikan

- Khawatir yang sulit dihentikan
- Gelisah, sulit berkonsentrasi, atau gangguan tidur
- Menghindari kegiatan karena takut atau cemas

## Dampak yang mungkin dirasakan

Kecemasan dapat memengaruhi kegiatan sehari-hari, tetapi tidak berarti seseorang lemah atau gagal. Pengalaman dan kebutuhan bantuan setiap orang berbeda.

## Langkah pencegahan

- Kenali pemicu tanpa menyalahkan diri
- Jaga rutinitas dan bicara dengan orang yang aman
- Cari informasi dari profesional, bukan diagnosis mandiri dari kuis internet

## Yang dapat dilakukan sekarang

- Coba tarik napas perlahan atau grounding jika terasa membantu
- Ambil langkah kecil menuju kegiatan yang dihindari, tanpa memaksakan diri
- Buat janji dengan konselor/tenaga kesehatan bila dampaknya berulang

## Kapan mencari bantuan

Cari bantuan profesional bila kecemasan mengganggu sekolah, tidur, relasi, atau aktivitas yang penting bagimu.', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', 'published', now(), 'mental_health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-mental'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'WHO: Mental health of adolescents', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', '2026-11-25' from public.articles a where a.slug = 'kecemasan'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian Kesehatan: Layanan Healing119.id', 'https://kesprimkom.kemkes.go.id/konten/127/151/0/cegah-bunuh-diri-dukung-kesehatan-jiwa-kenali-layanan-healing119-id', '2026-11-25' from public.articles a where a.slug = 'kecemasan'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://kesprimkom.kemkes.go.id/konten/127/151/0/cegah-bunuh-diri-dukung-kesehatan-jiwa-kenali-layanan-healing119-id');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah sering cemas berarti saya memiliki gangguan?', 'Tidak dapat disimpulkan dari satu tanda. Penilaian hanya dapat dilakukan oleh profesional.', 1, true, 'published' from public.articles a where a.slug = 'kecemasan'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah sering cemas berarti saya memiliki gangguan?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa yang bisa dilakukan saat rasa cemas muncul?', 'Pindah ke tempat yang terasa aman, perlambat napas, dan hubungi orang tepercaya jika kamu ingin ditemani.', 2, true, 'published' from public.articles a where a.slug = 'kecemasan'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa yang bisa dilakukan saat rasa cemas muncul?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Kapan sebaiknya berkonsultasi?', 'Saat rasa cemas menetap, terasa berat, atau membatasi kehidupan sehari-hari.', 3, true, 'published' from public.articles a where a.slug = 'kecemasan'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Kapan sebaiknya berkonsultasi?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Tekanan akademik', 'tekanan-akademik', 'Cara menghadapi target belajar tanpa mengabaikan kesehatan dan kebutuhan istirahat.', '## Memahami topik

Tekanan akademik dapat muncul dari tugas, ujian, target diri, atau harapan orang lain. Tujuan belajar penting, tetapi kesehatan dan proses belajar juga perlu dijaga.

## Faktor yang dapat berperan

- Tugas menumpuk dan jadwal padat
- Target yang tidak realistis atau perbandingan dengan orang lain
- Takut mengecewakan keluarga atau guru

## Tanda yang dapat diperhatikan

- Sulit memulai atau menyelesaikan tugas
- Tidur terganggu dan merasa kewalahan
- Kehilangan minat atau merasa harga diri hanya ditentukan nilai

## Dampak yang mungkin dirasakan

Tekanan berkepanjangan dapat memengaruhi konsentrasi, suasana hati, dan relasi. Nilai bukan ukuran tunggal kemampuan atau nilai diri seseorang.

## Langkah pencegahan

- Susun prioritas dan tugas menjadi bagian yang lebih kecil
- Komunikasikan beban kepada guru, wali, atau keluarga yang mendukung
- Jadwalkan jeda dan waktu tidur yang memadai

## Yang dapat dilakukan sekarang

- Pilih tugas paling mendesak dan kerjakan sebentar dulu
- Minta klarifikasi atau perpanjangan secara jujur bila diperlukan
- Hindari belajar semalaman sebagai kebiasaan

## Kapan mencari bantuan

Jika tekanan terus mengganggu tidur, kesehatan, kehadiran, atau rasa aman, bicarakan dengan konselor sekolah atau profesional.', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', 'published', now(), 'mental_health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-mental'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'WHO: Mental health of adolescents', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', '2026-11-25' from public.articles a where a.slug = 'tekanan-akademik'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana memulai tugas saat merasa kewalahan?', 'Pilih satu tugas kecil, atur waktu singkat, lalu evaluasi. Minta bantuan untuk menentukan prioritas jika perlu.', 1, true, 'published' from public.articles a where a.slug = 'tekanan-akademik'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana memulai tugas saat merasa kewalahan?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah istirahat berarti saya malas?', 'Tidak. Istirahat merupakan bagian dari menjaga kemampuan belajar dan kesejahteraan.', 2, true, 'published' from public.articles a where a.slug = 'tekanan-akademik'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah istirahat berarti saya malas?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa yang dilakukan bila takut mengecewakan orang tua?', 'Cari waktu yang tenang untuk menjelaskan beban dan ajak orang dewasa tepercaya membantu percakapan.', 3, true, 'published' from public.articles a where a.slug = 'tekanan-akademik'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa yang dilakukan bila takut mengecewakan orang tua?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Kepercayaan diri dan penerimaan diri', 'kepercayaan-diri', 'Mengembangkan pandangan yang lebih adil terhadap diri dan proses bertumbuh.', '## Memahami topik

Kepercayaan diri dapat berubah mengikuti pengalaman. Menghargai diri bukan berarti harus selalu merasa yakin; itu juga berarti memberi ruang untuk belajar dan meminta bantuan.

## Faktor yang dapat berperan

- Perbandingan sosial dan komentar yang merendahkan
- Perubahan tubuh atau fase kehidupan
- Pengalaman gagal, penolakan, atau diskriminasi

## Tanda yang dapat diperhatikan

- Sering meremehkan kemampuan diri
- Takut mencoba karena khawatir dinilai
- Menilai diri hanya dari penampilan atau pencapaian

## Dampak yang mungkin dirasakan

Pandangan negatif yang terus menerus dapat mengurangi keberanian mencoba dan memengaruhi suasana hati. Pengalaman ini dapat dibicarakan tanpa menghakimi.

## Langkah pencegahan

- Kurangi paparan akun yang membuatmu merasa buruk tentang diri
- Catat usaha dan hal yang sudah dipelajari, bukan hanya hasil
- Bangun hubungan dengan orang yang menghormati batas dan pilihanmu

## Yang dapat dilakukan sekarang

- Pilih satu langkah kecil yang sesuai minatmu
- Gunakan bahasa yang lebih adil saat menilai diri
- Bicarakan komentar atau perlakuan yang membuatmu tidak aman

## Kapan mencari bantuan

Cari dukungan bila rasa tidak berharga menetap, mengganggu kehidupan, atau mendorong tindakan yang membahayakan diri.', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', 'published', now(), 'mental_health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-mental'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'WHO: Mental health of adolescents', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', '2026-11-25' from public.articles a where a.slug = 'kepercayaan-diri'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'UNICEF Indonesia: Apa itu cyberbullying dan bagaimana menghentikannya?', 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying', '2026-11-25' from public.articles a where a.slug = 'kepercayaan-diri'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah percaya diri berarti tidak pernah ragu?', 'Tidak. Ragu adalah pengalaman wajar; percaya diri juga mencakup keberanian meminta bantuan dan mencoba lagi.', 1, true, 'published' from public.articles a where a.slug = 'kepercayaan-diri'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah percaya diri berarti tidak pernah ragu?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana berhenti membandingkan diri?', 'Batasi pemicu yang tidak sehat dan ingat bahwa unggahan biasanya hanya menampilkan bagian tertentu dari hidup seseorang.', 2, true, 'published' from public.articles a where a.slug = 'kepercayaan-diri'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana berhenti membandingkan diri?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa yang dilakukan bila sering direndahkan?', 'Cari orang dewasa tepercaya atau konselor. Kamu berhak diperlakukan dengan hormat.', 3, true, 'published' from public.articles a where a.slug = 'kepercayaan-diri'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa yang dilakukan bila sering direndahkan?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Permasalahan keluarga', 'masalah-keluarga', 'Mencari cara aman untuk berbicara dan dukungan saat rumah terasa berat.', '## Memahami topik

Hubungan keluarga dapat mengalami konflik atau perubahan. Tidak semua situasi aman untuk dibicarakan langsung; keselamatan dan dukungan remaja harus menjadi pertimbangan utama.

## Faktor yang dapat berperan

- Perbedaan harapan atau cara berkomunikasi
- Perubahan kondisi keluarga dan beban ekonomi
- Konflik, kontrol, atau kekerasan di rumah

## Tanda yang dapat diperhatikan

- Merasa takut, tertekan, atau tidak didengar
- Sulit tidur atau berkonsentrasi karena konflik
- Menghindari rumah atau percakapan tertentu karena merasa tidak aman

## Dampak yang mungkin dirasakan

Konflik berkepanjangan dapat memengaruhi kesejahteraan. Kekerasan bukan kesalahan korban dan membutuhkan dukungan dari orang atau layanan yang aman.

## Langkah pencegahan

- Pilih waktu bicara hanya bila situasi aman
- Minta orang dewasa tepercaya menjadi pendamping
- Kenali tempat aman yang dapat dituju bila konflik meningkat

## Yang dapat dilakukan sekarang

- Jangan memaksakan percakapan ketika ada ancaman atau kekerasan
- Hubungi orang dewasa tepercaya, guru, atau layanan perlindungan
- Jika terancam, cari tempat aman dan bantuan segera

## Kapan mencari bantuan

Jika ada kekerasan atau ancaman terhadap anak/perempuan, hubungi SAPA 129 atau polisi 110 saat bahaya langsung. Jangan konfrontasi pelaku sendirian.', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', 'published', now(), 'mental_health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-mental'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'WHO: Mental health of adolescents', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', '2026-11-25' from public.articles a where a.slug = 'masalah-keluarga'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian PPPA: SAPA 129', 'https://laporsapa129.kemenpppa.go.id/', '2026-11-25' from public.articles a where a.slug = 'masalah-keluarga'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://laporsapa129.kemenpppa.go.id/');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah semua konflik keluarga termasuk kekerasan?', 'Tidak. Namun ancaman, paksaan, atau tindakan yang melukai perlu dianggap serius dan dinilai dengan bantuan pihak aman.', 1, true, 'published' from public.articles a where a.slug = 'masalah-keluarga'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah semua konflik keluarga termasuk kekerasan?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana bila saya takut bercerita?', 'Pilih orang dewasa yang tidak menghakimi, seperti guru atau kerabat yang dipercaya. Kamu dapat meminta ditemani.', 2, true, 'published' from public.articles a where a.slug = 'masalah-keluarga'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana bila saya takut bercerita?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa yang dilakukan jika rumah tidak aman?', 'Cari tempat aman dan hubungi orang dewasa tepercaya atau layanan perlindungan.', 3, true, 'published' from public.articles a where a.slug = 'masalah-keluarga'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa yang dilakukan jika rumah tidak aman?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Hubungan pertemanan', 'hubungan-pertemanan', 'Membangun pertemanan yang saling menghormati dan mengenali batas yang sehat.', '## Memahami topik

Pertemanan sehat memberi ruang bagi rasa hormat, pilihan, dan batas pribadi. Perbedaan pendapat dapat terjadi, tetapi ancaman dan penghinaan berulang tidak perlu dianggap sebagai hal biasa.

## Faktor yang dapat berperan

- Tekanan kelompok atau takut ditinggalkan
- Kesalahpahaman dan komunikasi yang kurang jelas
- Perundungan atau kontrol yang berulang

## Tanda yang dapat diperhatikan

- Merasa harus selalu menurut agar diterima
- Takut menyampaikan batas atau pendapat
- Dijauhi, dipermalukan, atau diancam secara berulang

## Dampak yang mungkin dirasakan

Relasi yang tidak sehat dapat membuat remaja cemas, menarik diri, atau merasa tidak berharga. Perlakuan merendahkan bukan ukuran nilai dirimu.

## Langkah pencegahan

- Sampaikan batas bila situasi aman
- Jaga pertemanan yang memberi ruang untuk berbeda
- Cari dukungan jika ada ancaman atau perundungan

## Yang dapat dilakukan sekarang

- Ambil jarak dan cari tempat ramai/aman bila merasa terancam
- Ceritakan kepada orang dewasa tepercaya
- Simpan bukti digital jika ada cyberbullying dan gunakan fitur lapor platform

## Kapan mencari bantuan

Jika pertemanan melibatkan kekerasan, ancaman, atau perundungan, mintalah bantuan guru, konselor, keluarga aman, atau layanan perlindungan.', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', 'published', now(), 'mental_health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-mental'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'WHO: Mental health of adolescents', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', '2026-11-25' from public.articles a where a.slug = 'hubungan-pertemanan'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'UNICEF Indonesia: Apa itu cyberbullying dan bagaimana menghentikannya?', 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying', '2026-11-25' from public.articles a where a.slug = 'hubungan-pertemanan'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah candaan yang menyakiti termasuk perundungan?', 'Dampak dan pola perilaku penting. Jika tindakan berulang, merendahkan, atau membuat seseorang tidak aman, ceritakan kepada orang dewasa tepercaya.', 1, true, 'published' from public.articles a where a.slug = 'hubungan-pertemanan'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah candaan yang menyakiti termasuk perundungan?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana membantu teman yang dijauhi?', 'Dengarkan, tawarkan menemani mencari bantuan, dan jangan menyebarkan cerita atau tangkapan layar.', 2, true, 'published' from public.articles a where a.slug = 'hubungan-pertemanan'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana membantu teman yang dijauhi?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Haruskah saya menghadapi teman yang mengancam?', 'Tidak jika itu berisiko. Utamakan jarak aman dan minta bantuan orang dewasa.', 3, true, 'published' from public.articles a where a.slug = 'hubungan-pertemanan'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Haruskah saya menghadapi teman yang mengancam?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Kesepian dan keterasingan', 'kesepian', 'Memahami perasaan terhubung dan mencari dukungan secara bertahap.', '## Memahami topik

Kesepian adalah perasaan kurang terhubung, bahkan ketika seseorang berada di tengah orang lain. Pengalaman ini tidak selalu terlihat oleh orang di sekitar.

## Faktor yang dapat berperan

- Perubahan sekolah, lingkungan, atau hubungan
- Perasaan berbeda atau tidak diterima
- Tekanan sosial dan interaksi daring yang terasa dangkal

## Tanda yang dapat diperhatikan

- Merasa sendirian atau tidak dipahami
- Menarik diri dari kegiatan yang biasanya disukai
- Sulit memulai percakapan atau meminta ditemani

## Dampak yang mungkin dirasakan

Kesepian yang berlarut dapat memengaruhi suasana hati dan keterlibatan sehari-hari. Perasaan ini layak diperhatikan dan bukan tanda kelemahan.

## Langkah pencegahan

- Mulai dari kontak kecil dengan orang yang terasa aman
- Cari kegiatan kelompok yang sesuai minat dan batas nyaman
- Bicarakan perasaan dengan seseorang yang dipercaya

## Yang dapat dilakukan sekarang

- Kirim pesan sederhana untuk mengajak bicara
- Pilih satu aktivitas bersama yang terasa ringan
- Jangan menilai diri berdasarkan jumlah teman atau respons media sosial

## Kapan mencari bantuan

Cari bantuan profesional bila kesepian berlangsung lama, disertai putus asa, atau mengganggu kegiatan sehari-hari.', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', 'published', now(), 'mental_health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-mental'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'WHO: Mental health of adolescents', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', '2026-11-25' from public.articles a where a.slug = 'kesepian'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah bisa merasa kesepian walau punya teman?', 'Ya. Kesepian adalah pengalaman subjektif tentang keterhubungan, bukan semata jumlah teman.', 1, true, 'published' from public.articles a where a.slug = 'kesepian'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah bisa merasa kesepian walau punya teman?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa langkah kecil untuk mulai terhubung?', 'Cobalah menghubungi satu orang aman atau ikut kegiatan yang kamu minati tanpa menuntut diri langsung akrab.', 2, true, 'published' from public.articles a where a.slug = 'kesepian'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa langkah kecil untuk mulai terhubung?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Kapan perasaan kesepian perlu bantuan profesional?', 'Jika menetap, memburuk, atau mengganggu tidur, belajar, dan keseharian.', 3, true, 'published' from public.articles a where a.slug = 'kesepian'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Kapan perasaan kesepian perlu bantuan profesional?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Mengelola emosi', 'pengelolaan-emosi', 'Mengenali emosi dan memilih respons yang lebih aman bagi diri sendiri dan orang lain.', '## Memahami topik

Emosi memberikan informasi tentang pengalaman dan kebutuhan. Tujuan mengelola emosi bukan menekan semua perasaan, melainkan mengenalinya dan memilih respons yang aman.

## Faktor yang dapat berperan

- Kurang istirahat atau tekanan yang menumpuk
- Konflik, perubahan, atau pengalaman sulit
- Belum memiliki cara yang dirasa membantu untuk menenangkan diri

## Tanda yang dapat diperhatikan

- Emosi terasa sangat kuat atau berubah cepat
- Sulit berhenti bereaksi saat konflik
- Menyesal setelah melampiaskan emosi kepada diri sendiri atau orang lain

## Dampak yang mungkin dirasakan

Emosi yang tidak tersalurkan secara aman dapat menambah ketegangan. Tindakan menyakiti diri/orang lain perlu segera mendapat dukungan.

## Langkah pencegahan

- Beri nama pada perasaan tanpa menghakimi
- Kenali hal yang membantu menenangkan diri
- Belajar menyampaikan kebutuhan dan batas dengan aman

## Yang dapat dilakukan sekarang

- Ambil jeda dan menjauh dari situasi konflik bila aman
- Gunakan grounding, gerak ringan, atau hubungi orang tepercaya
- Jika ada risiko menyakiti diri/orang lain, jangan sendirian dan cari bantuan segera

## Kapan mencari bantuan

Minta bantuan profesional jika emosi berulang terasa tidak terkendali atau menimbulkan risiko keselamatan.', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', 'published', now(), 'mental_health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-mental'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'WHO: Mental health of adolescents', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', '2026-11-25' from public.articles a where a.slug = 'pengelolaan-emosi'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian Kesehatan: Layanan Healing119.id', 'https://kesprimkom.kemkes.go.id/konten/127/151/0/cegah-bunuh-diri-dukung-kesehatan-jiwa-kenali-layanan-healing119-id', '2026-11-25' from public.articles a where a.slug = 'pengelolaan-emosi'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://kesprimkom.kemkes.go.id/konten/127/151/0/cegah-bunuh-diri-dukung-kesehatan-jiwa-kenali-layanan-healing119-id');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah menangis berarti saya tidak kuat?', 'Tidak. Menangis dapat menjadi salah satu respons terhadap emosi dan tidak menentukan kekuatan seseorang.', 1, true, 'published' from public.articles a where a.slug = 'pengelolaan-emosi'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah menangis berarti saya tidak kuat?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa yang bisa dilakukan ketika emosi terasa meledak?', 'Berhenti sejenak, pindah ke tempat aman, dan cari orang yang bisa menemani. Hindari keputusan saat merasa sangat tertekan.', 2, true, 'published' from public.articles a where a.slug = 'pengelolaan-emosi'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa yang bisa dilakukan ketika emosi terasa meledak?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana bila saya takut menyakiti diri?', 'Dekati orang yang aman sekarang, jangan sendirian, dan hubungi bantuan profesional atau layanan krisis resmi.', 3, true, 'published' from public.articles a where a.slug = 'pengelolaan-emosi'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana bila saya takut menyakiti diri?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Tekanan media sosial', 'tekanan-media-sosial', 'Menjaga batas digital dan kesehatan diri di tengah arus konten serta perbandingan.', '## Memahami topik

Media sosial dapat menjadi ruang belajar dan berhubungan, sekaligus memunculkan perbandingan, tekanan, atau perundungan. Pengalaman tiap orang berbeda dan pengaturan batas dapat membantu.

## Faktor yang dapat berperan

- Perbandingan dengan unggahan yang telah dikurasi
- Notifikasi dan tuntutan untuk selalu tersedia
- Komentar, pesan, atau konten yang merendahkan

## Tanda yang dapat diperhatikan

- Suasana hati menurun setelah membuka aplikasi
- Sulit berhenti memeriksa notifikasi atau membandingkan diri
- Mengalami ancaman, penghinaan, atau penyebaran konten tanpa izin

## Dampak yang mungkin dirasakan

Tekanan digital dapat memengaruhi suasana hati, tidur, rasa aman, dan hubungan. Cyberbullying dapat meninggalkan dampak di luar layar.

## Langkah pencegahan

- Atur waktu notifikasi dan akun yang diikuti
- Gunakan blokir/lapor pada platform saat ada perundungan
- Jangan membagikan data pribadi atau lokasi kepada orang yang tidak dikenal

## Yang dapat dilakukan sekarang

- Ambil jeda dari akun/konten pemicu
- Simpan bukti perundungan digital dengan aman dan jangan menyebarkannya
- Beri tahu orang dewasa tepercaya; minta didampingi saat melapor

## Kapan mencari bantuan

Jika ada ancaman, pemerasan, eksploitasi, atau konten intim tanpa persetujuan, jangan hadapi sendiri. Hubungi orang dewasa tepercaya dan SAPA 129.', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', 'published', now(), 'mental_health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-mental'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'WHO: Mental health of adolescents', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', '2026-11-25' from public.articles a where a.slug = 'tekanan-media-sosial'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'UNICEF Indonesia: Apa itu cyberbullying dan bagaimana menghentikannya?', 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying', '2026-11-25' from public.articles a where a.slug = 'tekanan-media-sosial'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana mengurangi kebiasaan membandingkan diri?', 'Kurasi akun yang diikuti, ingat bahwa unggahan bukan gambaran lengkap hidup seseorang, dan ambil jeda jika dibutuhkan.', 1, true, 'published' from public.articles a where a.slug = 'tekanan-media-sosial'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana mengurangi kebiasaan membandingkan diri?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa yang dilakukan saat di-bully online?', 'Cari orang dewasa tepercaya, simpan bukti dengan aman, dan gunakan fitur blokir/lapor. Jangan membalas jika itu membahayakan.', 2, true, 'published' from public.articles a where a.slug = 'tekanan-media-sosial'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa yang dilakukan saat di-bully online?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah saya harus menghapus akun?', 'Tidak selalu. Kamu dapat mengatur privasi, membatasi notifikasi, memblokir akun, atau mengambil jeda sesuai kebutuhan.', 3, true, 'published' from public.articles a where a.slug = 'tekanan-media-sosial'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah saya harus menghapus akun?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Mengenali tanda depresi', 'mengenali-depresi', 'Mengenali perubahan yang menetap dan mencari penilaian profesional tanpa mendiagnosis diri.', '## Memahami topik

Depresi adalah kondisi kesehatan mental yang perlu dinilai profesional. Perasaan sedih sesekali tidak otomatis berarti depresi; perubahan yang menetap dan berdampak pada kehidupan perlu diperhatikan.

## Faktor yang dapat berperan

- Pengalaman hidup, tekanan, kekerasan, atau kehilangan
- Faktor biologis, keluarga, dan lingkungan dapat berperan
- Penyebabnya tidak selalu sederhana atau tunggal

## Tanda yang dapat diperhatikan

- Suasana hati rendah atau mudah tersinggung yang menetap
- Kehilangan minat, perubahan tidur/makan, atau sulit berkonsentrasi
- Merasa tidak berharga, putus asa, atau menarik diri

## Dampak yang mungkin dirasakan

Depresi dapat memengaruhi sekolah, relasi, kesehatan, dan rasa aman. Ini bukan kesalahan atau kelemahan seseorang dan ada dukungan profesional yang dapat dicari.

## Langkah pencegahan

- Bangun dukungan sosial dan rutinitas yang memungkinkan
- Bicarakan perubahan yang dirasakan dengan orang dewasa aman
- Hindari memberi label diagnosis kepada diri sendiri atau teman

## Yang dapat dilakukan sekarang

- Ceritakan perubahan kepada orang tepercaya
- Minta bantuan profesional kesehatan jiwa untuk penilaian
- Jika ada pikiran menyakiti diri, jangan sendirian dan cari bantuan segera

## Kapan mencari bantuan

Cari bantuan profesional bila tanda menetap, mengganggu keseharian, atau menimbulkan putus asa. Dalam krisis, hubungi Healing119.id/119 ekstensi 8 atau layanan darurat setempat; layanan Healing119 beroperasi dari pagi hingga malam, bukan jaminan 24 jam.', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', 'published', now(), 'mental_health', '2026-11-25', null
from public.categories c where c.slug = 'sirama-kesehatan-mental'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'WHO: Mental health of adolescents', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', '2026-11-25' from public.articles a where a.slug = 'mengenali-depresi'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian Kesehatan: Layanan Healing119.id', 'https://kesprimkom.kemkes.go.id/konten/127/151/0/cegah-bunuh-diri-dukung-kesehatan-jiwa-kenali-layanan-healing119-id', '2026-11-25' from public.articles a where a.slug = 'mengenali-depresi'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://kesprimkom.kemkes.go.id/konten/127/151/0/cegah-bunuh-diri-dukung-kesehatan-jiwa-kenali-layanan-healing119-id');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah stres sama dengan depresi?', 'Tidak. Stres merupakan respons terhadap tekanan; depresi adalah kondisi kesehatan mental yang perlu dinilai profesional.', 1, true, 'published' from public.articles a where a.slug = 'mengenali-depresi'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah stres sama dengan depresi?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah perubahan mood cukup untuk mendiagnosis depresi?', 'Tidak. Diagnosis tidak dapat ditentukan dari satu gejala atau kuis daring.', 2, true, 'published' from public.articles a where a.slug = 'mengenali-depresi'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah perubahan mood cukup untuk mendiagnosis depresi?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa yang harus dilakukan jika teman berkata ingin menyakiti diri?', 'Dengarkan tanpa menghakimi, tetap bersama atau hubungi orang dewasa aman, dan cari bantuan profesional/krisis segera.', 3, true, 'published' from public.articles a where a.slug = 'mengenali-depresi'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa yang harus dilakukan jika teman berkata ingin menyakiti diri?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Perundungan fisik', 'perundungan-fisik', 'Mengenali tindakan fisik yang berulang atau mengintimidasi dan memilih langkah aman.', '## Memahami topik

Perundungan fisik dapat berupa memukul, menendang, mendorong, merusak barang, atau tindakan fisik lain yang menyakiti atau menakut-nakuti. Tanggung jawab berada pada pelaku dan orang dewasa yang perlu menjaga keselamatan.

## Faktor yang dapat berperan

- Ketimpangan kuasa atau dukungan kelompok pada pelaku
- Lingkungan yang menormalkan kekerasan
- Tidak adanya respons aman dari orang dewasa

## Tanda yang dapat diperhatikan

- Luka, barang rusak, atau ketakutan pada tempat/waktu tertentu
- Menghindari kelas, kegiatan, atau teman tertentu
- Ancaman atau tindakan yang berulang

## Dampak yang mungkin dirasakan

Korban dapat merasa tidak aman, cemas, sulit belajar, atau menarik diri. Dampak setiap orang berbeda dan bukan kesalahan korban.

## Langkah pencegahan

- Sampaikan pola perundungan kepada guru/orang dewasa aman
- Sekolah perlu membangun lingkungan yang menghentikan kekerasan
- Teman dapat menemani korban menuju orang dewasa tanpa memaksa

## Yang dapat dilakukan sekarang

- Pergi ke tempat ramai atau ruang yang diawasi bila memungkinkan
- Jangan membalas atau menghadapi pelaku sendirian bila berisiko
- Minta bantuan orang dewasa dan layanan kesehatan bila terluka

## Kapan mencari bantuan

Cari bantuan orang dewasa tepercaya atau pengelola sekolah. Jika ada cedera serius atau bahaya langsung, hubungi layanan darurat; kekerasan terhadap anak dapat dilaporkan ke SAPA 129.', 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying', 'published', now(), 'safety', '2026-11-25', null
from public.categories c where c.slug = 'sirama-keselamatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'UNICEF Indonesia: Apa itu cyberbullying dan bagaimana menghentikannya?', 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying', '2026-11-25' from public.articles a where a.slug = 'perundungan-fisik'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian PPPA: SAPA 129', 'https://laporsapa129.kemenpppa.go.id/', '2026-11-25' from public.articles a where a.slug = 'perundungan-fisik'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://laporsapa129.kemenpppa.go.id/');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa yang dilakukan jika dipukul di sekolah?', 'Menjauh ke tempat aman, beri tahu orang dewasa tepercaya, dan minta pemeriksaan kesehatan bila terluka.', 1, true, 'published' from public.articles a where a.slug = 'perundungan-fisik'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa yang dilakukan jika dipukul di sekolah?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Haruskah korban menghadapi pelaku?', 'Tidak jika situasi berisiko. Keselamatan lebih utama; minta orang dewasa terlatih menangani situasi.', 2, true, 'published' from public.articles a where a.slug = 'perundungan-fisik'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Haruskah korban menghadapi pelaku?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana menemani teman korban?', 'Dengarkan, yakinkan bahwa itu bukan salahnya, dan tawarkan menemani mencari bantuan.', 3, true, 'published' from public.articles a where a.slug = 'perundungan-fisik'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana menemani teman korban?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Perundungan verbal', 'perundungan-verbal', 'Mengenali ejekan, hinaan, ancaman, atau ucapan merendahkan yang berulang.', '## Memahami topik

Perundungan verbal menggunakan kata-kata untuk mengintimidasi, mempermalukan, atau merendahkan seseorang. Candaan yang menyakiti tetap perlu dihentikan ketika seseorang merasa terancam atau dipermalukan.

## Faktor yang dapat berperan

- Norma kelompok yang menganggap penghinaan sebagai candaan
- Ketimpangan kuasa atau pengulangan oleh beberapa orang
- Diskriminasi terhadap identitas atau kondisi seseorang

## Tanda yang dapat diperhatikan

- Julukan merendahkan atau hinaan yang berulang
- Ancaman, pelecehan, atau komentar tentang tubuh dan identitas
- Korban tampak takut bicara atau menghindari kelompok tertentu

## Dampak yang mungkin dirasakan

Ucapan merendahkan dapat memengaruhi rasa percaya diri, suasana hati, dan rasa aman. Tidak terlihat luka fisik bukan berarti dampaknya tidak nyata.

## Langkah pencegahan

- Tetapkan aturan komunikasi yang menghormati orang lain
- Sampaikan kepada orang dewasa yang mampu menindaklanjuti
- Jangan ikut menyebarkan ucapan atau konten yang merendahkan

## Yang dapat dilakukan sekarang

- Jika aman, katakan singkat bahwa ucapan itu tidak nyaman lalu menjauh
- Simpan bukti bila ancaman dilakukan secara tertulis
- Cari dukungan teman dan orang dewasa tepercaya

## Kapan mencari bantuan

Minta bantuan guru, konselor, keluarga aman, atau SAPA 129 bila ada ancaman atau kekerasan terhadap anak.', 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying', 'published', now(), 'safety', '2026-11-25', null
from public.categories c where c.slug = 'sirama-keselamatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'UNICEF Indonesia: Apa itu cyberbullying dan bagaimana menghentikannya?', 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying', '2026-11-25' from public.articles a where a.slug = 'perundungan-verbal'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian PPPA: SAPA 129', 'https://laporsapa129.kemenpppa.go.id/', '2026-11-25' from public.articles a where a.slug = 'perundungan-verbal'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://laporsapa129.kemenpppa.go.id/');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah bercanda yang menyakiti termasuk bullying?', 'Bila tindakan berulang, mempermalukan, mengintimidasi, atau membuat seseorang tidak aman, jangan dianggap candaan biasa.', 1, true, 'published' from public.articles a where a.slug = 'perundungan-verbal'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah bercanda yang menyakiti termasuk bullying?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana jika pelaku bilang hanya bercanda?', 'Dampak dan batas orang yang menerima tetap penting. Sampaikan kepada orang dewasa yang dipercaya.', 2, true, 'published' from public.articles a where a.slug = 'perundungan-verbal'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana jika pelaku bilang hanya bercanda?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa yang dilakukan jika mendapat ancaman?', 'Jangan menghadapi sendiri; cari tempat aman, simpan bukti bila aman, dan beri tahu orang dewasa tepercaya.', 3, true, 'published' from public.articles a where a.slug = 'perundungan-verbal'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa yang dilakukan jika mendapat ancaman?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Perundungan sosial', 'perundungan-sosial', 'Mengenali pengucilan, rumor, atau manipulasi hubungan yang membuat seseorang merasa tidak aman.', '## Memahami topik

Perundungan sosial berupaya merusak hubungan atau reputasi, misalnya mengucilkan secara sengaja, menyebarkan rumor, atau mengajak orang lain menjauhi seseorang.

## Faktor yang dapat berperan

- Tekanan kelompok dan ketimpangan posisi sosial
- Penyebaran rumor tanpa memeriksa dampak
- Konflik yang berkembang menjadi pengucilan berulang

## Tanda yang dapat diperhatikan

- Dijauhkan dari kegiatan atau kelompok secara terus-menerus
- Rumor atau rahasia pribadi disebarkan
- Teman lain ditekan agar tidak berinteraksi

## Dampak yang mungkin dirasakan

Pengucilan dapat membuat korban kesepian, cemas, dan sulit merasa aman di sekolah atau komunitas. Korban tidak bertanggung jawab atas pilihan pelaku.

## Langkah pencegahan

- Jangan menyebarkan rumor atau ikut mengucilkan
- Beri ruang berteman tanpa tekanan kelompok
- Laporkan pola pengucilan kepada guru/orang dewasa aman

## Yang dapat dilakukan sekarang

- Cari teman atau orang dewasa yang bisa menemani
- Simpan bukti pesan bila pengucilan dilakukan secara daring
- Jangan memaksa korban membuka cerita di depan kelompok

## Kapan mencari bantuan

Hubungi guru, konselor, atau orang dewasa tepercaya. Jika pengucilan disertai ancaman atau kekerasan, cari bantuan perlindungan.', 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying', 'published', now(), 'safety', '2026-11-25', null
from public.categories c where c.slug = 'sirama-keselamatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'UNICEF Indonesia: Apa itu cyberbullying dan bagaimana menghentikannya?', 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying', '2026-11-25' from public.articles a where a.slug = 'perundungan-sosial'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian PPPA: SAPA 129', 'https://laporsapa129.kemenpppa.go.id/', '2026-11-25' from public.articles a where a.slug = 'perundungan-sosial'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://laporsapa129.kemenpppa.go.id/');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah tidak diajak sekali berarti bullying?', 'Belum tentu. Pola, kesengajaan, dampak, dan ketimpangan kuasa perlu dipertimbangkan oleh orang dewasa yang menangani.', 1, true, 'published' from public.articles a where a.slug = 'perundungan-sosial'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah tidak diajak sekali berarti bullying?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana membantu teman yang dikucilkan?', 'Sapa dan dengarkan tanpa memaksa. Ajak kegiatan yang terasa aman dan bantu menghubungi orang dewasa.', 2, true, 'published' from public.articles a where a.slug = 'perundungan-sosial'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana membantu teman yang dikucilkan?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Haruskah rumor dibantah di media sosial?', 'Pertimbangkan risiko. Simpan bukti dan minta dukungan orang dewasa sebelum merespons secara terbuka.', 3, true, 'published' from public.articles a where a.slug = 'perundungan-sosial'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Haruskah rumor dibantah di media sosial?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Cyberbullying', 'cyberbullying', 'Langkah aman menghadapi perundungan digital dan mencari bantuan.', '## Memahami topik

Cyberbullying adalah perundungan melalui teknologi digital, seperti pesan, unggahan, komentar, atau penyebaran konten untuk menyakiti atau mempermalukan seseorang.

## Faktor yang dapat berperan

- Penyebaran konten yang cepat dan sulit dikendalikan
- Akun anonim atau tekanan kelompok
- Kurangnya dukungan saat korban melaporkan

## Tanda yang dapat diperhatikan

- Pesan, komentar, atau unggahan yang merendahkan berulang
- Akun palsu, ancaman, atau penyebaran tangkapan layar pribadi
- Takut membuka aplikasi atau mengalami gangguan tidur dan suasana hati

## Dampak yang mungkin dirasakan

Dampaknya dapat terasa di rumah maupun sekolah, termasuk malu, marah, cemas, atau menarik diri. Simpan bukti dengan aman dan jangan menyebarkannya.

## Langkah pencegahan

- Atur privasi akun dan batasi informasi lokasi/pribadi
- Gunakan fitur blokir dan laporkan konten pada platform
- Bangun kesepakatan kelas/keluarga untuk tidak ikut menyebarkan konten

## Yang dapat dilakukan sekarang

- Beri tahu orang dewasa yang dipercaya
- Simpan tangkapan layar/tautan sebagai bukti tanpa meneruskannya
- Blokir dan laporkan akun; jangan membalas jika dapat meningkatkan risiko

## Kapan mencari bantuan

Untuk ancaman, eksploitasi, kekerasan seksual, atau keselamatan anak, cari bantuan orang dewasa dan SAPA 129. Bahaya langsung membutuhkan layanan darurat.', 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying', 'published', now(), 'safety', '2026-11-25', null
from public.categories c where c.slug = 'sirama-keselamatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'UNICEF Indonesia: Apa itu cyberbullying dan bagaimana menghentikannya?', 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying', '2026-11-25' from public.articles a where a.slug = 'cyberbullying'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian PPPA: SAPA 129', 'https://laporsapa129.kemenpppa.go.id/', '2026-11-25' from public.articles a where a.slug = 'cyberbullying'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://laporsapa129.kemenpppa.go.id/');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa saja contoh cyberbullying?', 'Pesan/komentar yang merendahkan secara berulang, akun palsu untuk mengintimidasi, atau menyebarkan konten untuk mempermalukan.', 1, true, 'published' from public.articles a where a.slug = 'cyberbullying'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa saja contoh cyberbullying?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa yang harus dilakukan jika takut melapor?', 'Mulai dengan satu orang dewasa yang terasa aman dan minta ditemani. Kamu tidak perlu menghadapinya sendiri.', 2, true, 'published' from public.articles a where a.slug = 'cyberbullying'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa yang harus dilakukan jika takut melapor?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana membantu teman yang dibully online?', 'Dengarkan tanpa menyalahkan, jangan sebarkan konten, dan tawarkan menemani menyimpan bukti serta mencari bantuan.', 3, true, 'published' from public.articles a where a.slug = 'cyberbullying'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana membantu teman yang dibully online?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Kekerasan fisik', 'kekerasan-fisik', 'Mengutamakan keselamatan dan mendapatkan pertolongan setelah tindakan yang melukai atau mengancam.', '## Memahami topik

Kekerasan fisik adalah tindakan yang menggunakan tenaga atau benda untuk melukai, menakut-nakuti, atau mengendalikan seseorang. Tidak ada korban yang pantas menerima kekerasan.

## Faktor yang dapat berperan

- Paksaan atau kontrol dalam keluarga, relasi, sekolah, atau lingkungan
- Situasi yang meningkat tanpa dukungan keselamatan
- Ketergantungan korban kepada pelaku dapat menyulitkan pencarian bantuan

## Tanda yang dapat diperhatikan

- Luka, nyeri, atau tanda fisik yang tidak dapat dijelaskan
- Ketakutan terhadap seseorang atau tempat tertentu
- Ancaman, pemukulan, penahanan, atau penggunaan benda untuk melukai

## Dampak yang mungkin dirasakan

Selain cedera, korban dapat mengalami rasa takut, sulit tidur, dan gangguan keseharian. Dampak tidak selalu tampak dari luar.

## Langkah pencegahan

- Kenali orang dan tempat yang dapat membantu
- Susun langkah keselamatan bersama orang tepercaya jika ada risiko berulang
- Jangan menyalahkan atau memaksa korban mengambil keputusan tertentu

## Yang dapat dilakukan sekarang

- Jika bahaya sedang terjadi, menjauh ke lokasi aman bila memungkinkan
- Hubungi orang dewasa tepercaya atau layanan darurat
- Cari pertolongan medis untuk cedera dan pendampingan perlindungan

## Kapan mencari bantuan

SAPA 129 menerima laporan kekerasan terhadap perempuan dan anak. Jika ada bahaya langsung, hubungi polisi 110 atau layanan darurat setempat; jangan menghadapi pelaku sendirian.', 'https://laporsapa129.kemenpppa.go.id/', 'published', now(), 'safety', '2026-11-25', null
from public.categories c where c.slug = 'sirama-keselamatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian PPPA: SAPA 129', 'https://laporsapa129.kemenpppa.go.id/', '2026-11-25' from public.articles a where a.slug = 'kekerasan-fisik'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://laporsapa129.kemenpppa.go.id/');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa yang dilakukan jika masih tinggal dengan pelaku?', 'Jangan menantang pelaku sendirian. Cari pendamping dewasa atau layanan perlindungan untuk menyusun langkah keselamatan.', 1, true, 'published' from public.articles a where a.slug = 'kekerasan-fisik'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa yang dilakukan jika masih tinggal dengan pelaku?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah luka ringan tetap perlu bantuan?', 'Jika kamu khawatir atau merasa tidak aman, bicarakan dengan tenaga kesehatan atau orang dewasa tepercaya.', 2, true, 'published' from public.articles a where a.slug = 'kekerasan-fisik'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah luka ringan tetap perlu bantuan?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Siapa dapat dihubungi?', 'Untuk kekerasan terhadap anak/perempuan, SAPA 129 menyediakan telepon 129 dan WhatsApp resmi 08111-129-129.', 3, true, 'published' from public.articles a where a.slug = 'kekerasan-fisik'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Siapa dapat dihubungi?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Kekerasan verbal', 'kekerasan-verbal', 'Mengenali penghinaan, ancaman, atau ucapan yang digunakan untuk menakut-nakuti dan mengendalikan.', '## Memahami topik

Kekerasan verbal menggunakan kata-kata untuk merendahkan, mengancam, atau mengendalikan. Pola perilaku dan rasa aman perlu diperhatikan, bukan hanya apakah pelaku menyebutnya bercanda.

## Faktor yang dapat berperan

- Pola kontrol dan ketimpangan kuasa
- Konflik yang berulang tanpa dukungan
- Ucapan diskriminatif atau ancaman yang dinormalisasi

## Tanda yang dapat diperhatikan

- Ancaman untuk melukai, mengusir, atau mempermalukan
- Hinaan berulang yang menyerang harga diri
- Korban merasa takut berbicara atau melakukan kesalahan kecil

## Dampak yang mungkin dirasakan

Ucapan mengancam dapat membuat korban takut, terisolasi, dan kehilangan rasa aman. Dampak emosional layak mendapat perhatian dan dukungan.

## Langkah pencegahan

- Cari dukungan di luar situasi yang mengancam
- Jangan ikut menormalisasi hinaan sebagai candaan
- Buat rencana aman dengan orang dewasa tepercaya

## Yang dapat dilakukan sekarang

- Menjauh jika percakapan meningkat dan situasi memungkinkan
- Catat ancaman secara aman hanya jika tidak menambah risiko
- Bicarakan dengan konselor atau layanan perlindungan

## Kapan mencari bantuan

Jika ucapan disertai ancaman atau kontrol, hubungi orang dewasa aman. Kekerasan terhadap anak/perempuan dapat disampaikan ke SAPA 129.', 'https://laporsapa129.kemenpppa.go.id/', 'published', now(), 'safety', '2026-11-25', null
from public.categories c where c.slug = 'sirama-keselamatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian PPPA: SAPA 129', 'https://laporsapa129.kemenpppa.go.id/', '2026-11-25' from public.articles a where a.slug = 'kekerasan-verbal'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://laporsapa129.kemenpppa.go.id/');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'WHO: Mental health of adolescents', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', '2026-11-25' from public.articles a where a.slug = 'kekerasan-verbal'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah bentakan sekali sama dengan kekerasan verbal?', 'Konteks dan pola penting. Ancaman, penghinaan, atau tindakan berulang perlu ditanggapi serius dan dibicarakan dengan pihak aman.', 1, true, 'published' from public.articles a where a.slug = 'kekerasan-verbal'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah bentakan sekali sama dengan kekerasan verbal?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana bila pelaku adalah keluarga?', 'Kamu tetap berhak mendapat bantuan. Cari orang dewasa tepercaya di luar situasi tersebut.', 2, true, 'published' from public.articles a where a.slug = 'kekerasan-verbal'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana bila pelaku adalah keluarga?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa yang dilakukan jika ancaman semakin berat?', 'Pergi ke tempat aman dan hubungi layanan darurat atau pendamping perlindungan.', 3, true, 'published' from public.articles a where a.slug = 'kekerasan-verbal'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa yang dilakukan jika ancaman semakin berat?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Kekerasan seksual', 'kekerasan-seksual', 'Informasi yang berpihak pada keselamatan korban, tanpa menyalahkan atau memaksa bercerita.', '## Memahami topik

Kekerasan seksual adalah tindakan seksual yang tidak diinginkan, dilakukan melalui paksaan, manipulasi, ancaman, atau tanpa persetujuan yang bebas. Tanggung jawab ada pada pelaku, bukan korban.

## Faktor yang dapat berperan

- Penyalahgunaan kuasa, kepercayaan, atau ketergantungan
- Tekanan, ancaman, manipulasi, atau situasi ketika korban tidak dapat menyetujui
- Paparan daring dan penyebaran konten tanpa persetujuan

## Tanda yang dapat diperhatikan

- Sentuhan atau ajakan seksual yang tidak diinginkan
- Dipaksa, diancam, atau dimanipulasi untuk melakukan sesuatu
- Konten pribadi diambil, disimpan, atau disebarkan tanpa persetujuan

## Dampak yang mungkin dirasakan

Korban dapat mengalami dampak fisik, emosional, sosial, dan rasa aman. Respons tiap orang berbeda; korban tidak perlu membuktikan bahwa dirinya cukup terluka untuk meminta bantuan.

## Langkah pencegahan

- Pelajari batas dan hak atas tubuh
- Dukung akses ke orang dewasa dan petugas yang dapat dipercaya
- Jaga privasi korban dan jangan menyebarkan cerita atau bukti

## Yang dapat dilakukan sekarang

- Pindah ke tempat aman; jangan menghadapi pelaku sendiri
- Hubungi orang dewasa tepercaya dan layanan perlindungan
- Cari bantuan kesehatan segera bila diperlukan; profesional dapat menjelaskan pilihan selanjutnya

## Kapan mencari bantuan

SAPA 129 adalah kanal resmi untuk kekerasan terhadap perempuan dan anak. Jika ada bahaya langsung, hubungi polisi 110. Jangan paksa korban melapor atau menceritakan detail berulang kali.', 'https://laporsapa129.kemenpppa.go.id/', 'published', now(), 'safety', '2026-11-25', null
from public.categories c where c.slug = 'sirama-keselamatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian PPPA: SAPA 129', 'https://laporsapa129.kemenpppa.go.id/', '2026-11-25' from public.articles a where a.slug = 'kekerasan-seksual'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://laporsapa129.kemenpppa.go.id/');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'JDIH Kementerian Kesehatan: Permenkes No. 2 Tahun 2025 tentang Penyelenggaraan Upaya Kesehatan Reproduksi', 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025', '2026-11-25' from public.articles a where a.slug = 'kekerasan-seksual'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah korban bersalah karena tidak melawan?', 'Tidak. Respons saat mengalami ancaman berbeda-beda. Tanggung jawab kekerasan ada pada pelaku.', 1, true, 'published' from public.articles a where a.slug = 'kekerasan-seksual'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah korban bersalah karena tidak melawan?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana membantu teman yang bercerita?', 'Dengarkan, percaya bahwa ia membutuhkan dukungan, hindari pertanyaan menyalahkan, dan tawarkan menemani mencari bantuan.', 2, true, 'published' from public.articles a where a.slug = 'kekerasan-seksual'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana membantu teman yang bercerita?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Ke mana mencari bantuan?', 'Kekerasan terhadap perempuan/anak dapat dilaporkan ke SAPA 129 melalui 129 atau WhatsApp 08111-129-129.', 3, true, 'published' from public.articles a where a.slug = 'kekerasan-seksual'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Ke mana mencari bantuan?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Kekerasan emosional', 'kekerasan-emosional', 'Mengenali pola intimidasi, penghinaan, ancaman, dan kontrol yang memengaruhi rasa aman.', '## Memahami topik

Kekerasan emosional dapat berbentuk tindakan berulang untuk menakut-nakuti, merendahkan, mengisolasi, atau mengendalikan seseorang. Satu halaman ini bukan alat diagnosis hubungan.

## Faktor yang dapat berperan

- Ketimpangan kuasa dan ketergantungan
- Isolasi dari teman/keluarga
- Perilaku kontrol yang dianggap wajar oleh lingkungan

## Tanda yang dapat diperhatikan

- Diancam, dipermalukan, atau terus disalahkan
- Dilarang bertemu orang yang dipercaya atau dipantau berlebihan
- Merasa takut menentukan pilihan atau menyampaikan pendapat

## Dampak yang mungkin dirasakan

Perlakuan semacam ini dapat mengikis rasa percaya diri dan membuat korban sulit meminta bantuan. Korban berhak mendapat dukungan tanpa paksaan.

## Langkah pencegahan

- Jaga koneksi dengan orang yang aman
- Kenali tanda kontrol dan batas yang penting bagimu
- Minta bantuan pihak yang memahami perlindungan dan keselamatan

## Yang dapat dilakukan sekarang

- Ceritakan kepada orang tepercaya di luar relasi jika aman
- Jangan konfrontasi pelaku sendirian apabila dapat meningkatkan bahaya
- Cari layanan pendampingan untuk menyusun langkah yang aman

## Kapan mencari bantuan

Jika kamu atau teman mengalami ancaman atau kontrol yang membahayakan, hubungi orang dewasa tepercaya atau SAPA 129 untuk kasus anak/perempuan.', 'https://laporsapa129.kemenpppa.go.id/', 'published', now(), 'safety', '2026-11-25', null
from public.categories c where c.slug = 'sirama-keselamatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian PPPA: SAPA 129', 'https://laporsapa129.kemenpppa.go.id/', '2026-11-25' from public.articles a where a.slug = 'kekerasan-emosional'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://laporsapa129.kemenpppa.go.id/');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'WHO: Mental health of adolescents', 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health', '2026-11-25' from public.articles a where a.slug = 'kekerasan-emosional'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana membedakan konflik dan kekerasan emosional?', 'Perhatikan pola kontrol, ancaman, penghinaan, ketakutan, dan ketimpangan kuasa. Pihak profesional dapat membantu menilai situasi.', 1, true, 'published' from public.articles a where a.slug = 'kekerasan-emosional'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana membedakan konflik dan kekerasan emosional?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah saya harus memutus relasi segera?', 'Keputusan dan keselamatan harus dipertimbangkan dengan pendamping aman. Jangan mengambil langkah yang berisiko tanpa dukungan.', 2, true, 'published' from public.articles a where a.slug = 'kekerasan-emosional'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah saya harus memutus relasi segera?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana membantu teman?', 'Percaya dan dengarkan, jangan memaksa keputusan, dan bantu mencari pendamping yang aman.', 3, true, 'published' from public.articles a where a.slug = 'kekerasan-emosional'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana membantu teman?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Kekerasan dalam hubungan', 'kekerasan-dalam-hubungan', 'Mengenali kontrol dan paksaan dalam relasi serta memprioritaskan keselamatan.', '## Memahami topik

Kekerasan dalam hubungan dapat berupa fisik, seksual, verbal, emosional, atau kontrol digital. Hubungan dekat tidak membuat seseorang berhak mengancam atau mengendalikan pasangannya.

## Faktor yang dapat berperan

- Cemburu yang digunakan untuk membatasi atau mengontrol
- Tekanan, ancaman, atau ketergantungan
- Isolasi dan pemantauan digital

## Tanda yang dapat diperhatikan

- Pasangan mengatur pakaian, pertemanan, atau lokasi secara memaksa
- Ancaman, penghinaan, pemaksaan, atau kekerasan fisik
- Takut mengatakan tidak atau mengakhiri hubungan

## Dampak yang mungkin dirasakan

Kekerasan dapat membuat seseorang merasa terjebak dan terisolasi. Hubungan yang sehat menghormati batas, pilihan, dan rasa aman.

## Langkah pencegahan

- Jaga hubungan dengan teman/orang dewasa aman
- Lindungi akun dan lokasi digital jika ada pemantauan
- Rencanakan langkah dengan pendamping bila ingin menjauh

## Yang dapat dilakukan sekarang

- Hindari putus atau konfrontasi tatap muka sendirian bila berisiko
- Simpan bukti dengan aman bila tidak membahayakan
- Cari bantuan pendampingan dan tempat aman

## Kapan mencari bantuan

Untuk korban anak/perempuan, SAPA 129 dapat memberi jalur laporan dan pendampingan. Bahaya langsung memerlukan bantuan darurat.', 'https://laporsapa129.kemenpppa.go.id/', 'published', now(), 'safety', '2026-11-25', null
from public.categories c where c.slug = 'sirama-keselamatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian PPPA: SAPA 129', 'https://laporsapa129.kemenpppa.go.id/', '2026-11-25' from public.articles a where a.slug = 'kekerasan-dalam-hubungan'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://laporsapa129.kemenpppa.go.id/');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'UNICEF Indonesia: Apa itu cyberbullying dan bagaimana menghentikannya?', 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying', '2026-11-25' from public.articles a where a.slug = 'kekerasan-dalam-hubungan'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah berbagi kata sandi bukti cinta?', 'Tidak. Kamu berhak menjaga privasi dan batas digital. Tekanan untuk memberi akses akun dapat menjadi tanda kontrol.', 1, true, 'published' from public.articles a where a.slug = 'kekerasan-dalam-hubungan'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah berbagi kata sandi bukti cinta?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana jika saya takut mengakhiri hubungan?', 'Jangan lakukan sendirian bila khawatir akan bahaya. Diskusikan rencana keselamatan dengan orang dewasa atau pendamping tepercaya.', 2, true, 'published' from public.articles a where a.slug = 'kekerasan-dalam-hubungan'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana jika saya takut mengakhiri hubungan?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah ancaman melalui chat perlu disimpan?', 'Simpan hanya jika aman, jangan sebarkan, dan minta bantuan orang dewasa untuk menentukan langkah berikutnya.', 3, true, 'published' from public.articles a where a.slug = 'kekerasan-dalam-hubungan'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah ancaman melalui chat perlu disimpan?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Perlindungan anak dan remaja', 'perlindungan-anak-remaja', 'Mengetahui siapa yang dapat membantu saat hak, keselamatan, atau batas diri terancam.', '## Memahami topik

Perlindungan anak mencakup upaya mencegah dan menanggapi kekerasan, eksploitasi, penelantaran, dan perlakuan yang membahayakan. Remaja berhak didengar dan mendapat dukungan yang mengutamakan keselamatan.

## Faktor yang dapat berperan

- Kekerasan atau eksploitasi di rumah, sekolah, komunitas, maupun daring
- Hambatan untuk bercerita atau akses bantuan
- Ketergantungan pada orang yang dapat menjadi sumber ancaman

## Tanda yang dapat diperhatikan

- Takut pulang atau bertemu seseorang
- Luka, ancaman, pemaksaan, atau permintaan rahasia yang membuat tidak nyaman
- Isolasi dari teman, sekolah, atau akses komunikasi

## Dampak yang mungkin dirasakan

Dampak perlindungan yang tidak memadai dapat menyentuh kesehatan, pendidikan, rasa aman, dan hubungan sosial. Keselamatan korban adalah prioritas.

## Langkah pencegahan

- Kenali orang dewasa yang dapat dipercaya
- Sekolah, keluarga, layanan sosial, dan tenaga kesehatan dapat menjadi bagian dukungan
- Jaga informasi pribadi dan bukti tanpa menyebarkannya

## Yang dapat dilakukan sekarang

- Jika aman, pindah ke tempat ramai dan hubungi orang dewasa tepercaya
- Jangan setujui pertemuan atau konfrontasi dengan orang yang mengancam
- Hubungi SAPA 129 untuk kekerasan terhadap anak/perempuan

## Kapan mencari bantuan

SAPA 129 dapat dihubungi melalui telepon 129 dan WhatsApp 08111-129-129. Bahaya langsung: polisi 110 atau layanan darurat setempat. SIRAMA bukan kanal pelaporan resmi.', 'https://laporsapa129.kemenpppa.go.id/', 'published', now(), 'safety', '2026-11-25', null
from public.categories c where c.slug = 'sirama-keselamatan-remaja'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kementerian PPPA: SAPA 129', 'https://laporsapa129.kemenpppa.go.id/', '2026-11-25' from public.articles a where a.slug = 'perlindungan-anak-remaja'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://laporsapa129.kemenpppa.go.id/');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'UNICEF Indonesia: Apa itu cyberbullying dan bagaimana menghentikannya?', 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying', '2026-11-25' from public.articles a where a.slug = 'perlindungan-anak-remaja'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://www.unicef.org/indonesia/id/child-protection/apa-itu-cyberbullying');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apakah harus punya bukti sebelum meminta bantuan?', 'Kamu tetap boleh meminta bantuan saat merasa tidak aman. Petugas berwenang dapat menjelaskan informasi yang dibutuhkan.', 1, true, 'published' from public.articles a where a.slug = 'perlindungan-anak-remaja'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apakah harus punya bukti sebelum meminta bantuan?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Bagaimana jika orang dewasa pertama tidak percaya?', 'Coba sampaikan kepada orang dewasa aman lainnya, seperti guru, kerabat, tenaga kesehatan, atau layanan perlindungan.', 2, true, 'published' from public.articles a where a.slug = 'perlindungan-anak-remaja'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Bagaimana jika orang dewasa pertama tidak percaya?');

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, 'Apa yang bisa dilakukan teman?', 'Dengarkan, jangan menyebarkan cerita, dan bantu menghubungkan ke orang dewasa tepercaya atau layanan resmi.', 3, true, 'published' from public.articles a where a.slug = 'perlindungan-anak-remaja'
and not exists (select 1 from public.faqs existing where existing.article_id = a.id and existing.question = 'Apa yang bisa dilakukan teman?');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Menyiapkan langkah setelah lulus', 'persiapan-melanjutkan-pendidikan', 'Menyusun pilihan pendidikan, kebutuhan, dan jadwal secara bertahap.', '## Mulai dengan mengenali minat, cara belajar, biaya, lokasi, dan dukungan yang tersedia. Bicarakan pilihan dengan guru BK, keluarga yang aman, atau alumni.

## Catat persyaratan dan tanggal dari situs resmi setiap perguruan tinggi. Buat daftar dokumen dan pengingat, tetapi hindari membagikan kata sandi atau identitas kepada pihak yang tidak jelas.

## Jika ada hambatan biaya, periksa bantuan resmi seperti KIP Kuliah dan informasi kampus. Ketentuan dapat berubah setiap tahun.', 'https://kip-kuliah.kemdiktisaintek.go.id/', 'published', now(), 'education', '2026-11-25', null
from public.categories c where c.slug = 'sirama-pendidikan'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Portal resmi Kartu Indonesia Pintar Kuliah', 'https://kip-kuliah.kemdiktisaintek.go.id/', '2026-11-25' from public.articles a where a.slug = 'persiapan-melanjutkan-pendidikan'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://kip-kuliah.kemdiktisaintek.go.id/');

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Mengembangkan keterampilan yang relevan', 'keterampilan-remaja', 'Belajar melalui proyek kecil, kegiatan sekolah, dan sumber pembelajaran yang dapat diperiksa.', '## Pilih satu keterampilan yang ingin dicoba, lalu buat target yang terukur dan realistis. Proyek sederhana membantu melihat minat sekaligus menghasilkan bukti belajar.

## Manfaatkan perpustakaan, pelatihan sekolah, atau kursus dengan penyelenggara yang jelas. Periksa biaya, syarat, keamanan, dan kebijakan privasi sebelum mendaftar.

## Keterampilan berkembang lewat latihan dan umpan balik. Tidak perlu membeli kursus atau alat mahal untuk mulai belajar.', null, 'published', now(), 'education', '2026-11-25', null
from public.categories c where c.slug = 'sirama-pendidikan'
on conflict (slug) do nothing;

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Mengenal pilihan karier', 'perencanaan-karier', 'Menghubungkan minat, pengalaman, dan informasi pekerjaan tanpa harus menentukan semuanya sekarang.', '## Pilihan karier bisa berubah seiring pengalaman. Mulai dari mata pelajaran, kegiatan, dan masalah yang menarik perhatianmu.

## Cari informasi tugas, jalur pendidikan, keterampilan, dan kondisi kerja melalui sumber institusi atau organisasi profesi yang relevan.

## Diskusikan keputusan dengan guru BK atau orang dewasa tepercaya. Beri ruang untuk mengeksplorasi dan mengubah arah.', null, 'published', now(), 'education', '2026-11-25', null
from public.categories c where c.slug = 'sirama-pendidikan'
on conflict (slug) do nothing;

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Mengenali dan mengembangkan potensi diri', 'potensi-diri', 'Membangun ruang untuk mencoba, berlatih, dan mengevaluasi tanpa membandingkan perjalananmu.', '## Potensi tidak selalu terlihat sebagai prestasi akademik. Minat, kepedulian, kreativitas, ketekunan, dan kemampuan bekerja bersama juga dapat dikembangkan.

## Cobalah kegiatan yang tersedia di sekolah atau komunitas. Tetapkan langkah kecil dan evaluasi apa yang terasa menarik atau perlu dukungan.

## Jaga waktu istirahat dan jangan merasa harus unggul di semua hal. Minta umpan balik yang spesifik dan menghargai.', null, 'published', now(), 'education', '2026-11-25', null
from public.categories c where c.slug = 'sirama-pendidikan'
on conflict (slug) do nothing;

insert into public.articles (category_id, author_id, title, slug, excerpt, content, source_url, status, published_at, content_type, reviewed_at, image_alt)
select c.id, null, 'Cara memeriksa informasi pendidikan', 'memeriksa-informasi-program', 'Mengenali penyelenggara, syarat, manfaat, jadwal, dan kanal resmi sebelum bertindak.', '## Mulailah dari situs resmi penyelenggara. Pastikan alamat dan nama program benar, lalu cocokkan informasi ringkasan dengan pengumuman terbaru.

## Periksa jenjang, persyaratan, cara seleksi, manfaat, periode pendaftaran, dan dokumen yang diperlukan. Jangan menganggap ringkasan lama masih berlaku.

## Waspadai biaya atau permintaan kata sandi yang tidak dijelaskan penyelenggara. Jika ragu, hubungi kanal resmi yang tercantum di situsnya.', 'https://kip-kuliah.kemdiktisaintek.go.id/', 'published', now(), 'education', '2026-11-25', null
from public.categories c where c.slug = 'sirama-pendidikan'
on conflict (slug) do nothing;

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Portal resmi Kartu Indonesia Pintar Kuliah', 'https://kip-kuliah.kemdiktisaintek.go.id/', '2026-11-25' from public.articles a where a.slug = 'memeriksa-informasi-program'
and not exists (select 1 from public.article_sources existing where existing.article_id = a.id and existing.url = 'https://kip-kuliah.kemdiktisaintek.go.id/');

insert into public.scholarships (category_id, created_by, title, slug, provider, description, requirements, benefits, education_level, official_url, status, application_period, application_steps, reviewed_at, faq)
select c.id, null, 'Kartu Indonesia Pintar Kuliah (KIP Kuliah)', 'kip-kuliah-2026', 'Kementerian Pendidikan Tinggi, Sains, dan Teknologi', 'Bantuan pendidikan tinggi bagi calon mahasiswa yang memenuhi ketentuan ekonomi dan akademik dari penyelenggara.', 'Siswa SMA/sederajat yang akan lulus pada tahun pendaftaran atau lulusan sesuai rentang tahun yang ditetapkan penyelenggara
Memenuhi ketentuan ekonomi dan memiliki potensi akademik sesuai panduan resmi
Lulus seleksi masuk dan diterima pada perguruan tinggi/program studi yang memenuhi ketentuan', 'Pembebasan biaya pendidikan sesuai ketentuan yang dibayarkan kepada perguruan tinggi
Bantuan biaya hidup mengikuti ketentuan dan penetapan penyelenggara', 'Calon mahasiswa pendidikan tinggi', 'https://kip-kuliah.kemdiktisaintek.go.id/', 'published', 'Saat diperiksa pada 25 November 2026, portal resmi mencantumkan pendaftaran akun siswa hingga 1 Desember 2026. Jadwal dapat berubah; periksa portal sebelum mendaftar.', 'Baca panduan terbaru pada portal resmi
Periksa kesesuaian data sekolah dan identitas melalui jalur resmi
Ikuti pendaftaran akun dan seleksi sesuai pengumuman penyelenggara
Hubungi kanal resmi portal jika ada perbedaan informasi', '2026-11-25', '[["Apakah pendaftaran KIP Kuliah 2026 masih dibuka?","Saat diperiksa pada 25 November 2026, portal resmi mencantumkan pendaftaran akun siswa sampai 1 Desember 2026. Jadwal dapat berubah, jadi periksa kembali portal sebelum mendaftar."],["Apakah SIRAMA menerima pendaftaran?","Tidak. Pendaftaran dan verifikasi hanya dilakukan melalui penyelenggara resmi."],["Apakah semua penerima otomatis mendapat bantuan biaya hidup yang sama?","Tidak. Besaran dan kelayakan mengikuti ketentuan penyelenggara yang berlaku."]]'::jsonb
from public.categories c where c.slug = 'sirama-beasiswa'
on conflict (slug) do nothing;

insert into public.faqs (scholarship_id, question, answer, display_order, is_active, status)
select s.id, 'Apakah pendaftaran KIP Kuliah 2026 masih dibuka?', 'Saat diperiksa pada 25 November 2026, portal resmi mencantumkan pendaftaran akun siswa sampai 1 Desember 2026. Jadwal dapat berubah, jadi periksa kembali portal sebelum mendaftar.', 1, true, 'published' from public.scholarships s where s.slug = 'kip-kuliah-2026'
and not exists (select 1 from public.faqs existing where existing.scholarship_id = s.id and existing.question = 'Apakah pendaftaran KIP Kuliah 2026 masih dibuka?');

insert into public.faqs (scholarship_id, question, answer, display_order, is_active, status)
select s.id, 'Apakah SIRAMA menerima pendaftaran?', 'Tidak. Pendaftaran dan verifikasi hanya dilakukan melalui penyelenggara resmi.', 2, true, 'published' from public.scholarships s where s.slug = 'kip-kuliah-2026'
and not exists (select 1 from public.faqs existing where existing.scholarship_id = s.id and existing.question = 'Apakah SIRAMA menerima pendaftaran?');

insert into public.faqs (scholarship_id, question, answer, display_order, is_active, status)
select s.id, 'Apakah semua penerima otomatis mendapat bantuan biaya hidup yang sama?', 'Tidak. Besaran dan kelayakan mengikuti ketentuan penyelenggara yang berlaku.', 3, true, 'published' from public.scholarships s where s.slug = 'kip-kuliah-2026'
and not exists (select 1 from public.faqs existing where existing.scholarship_id = s.id and existing.question = 'Apakah semua penerima otomatis mendapat bantuan biaya hidup yang sama?');

insert into public.faqs (question, answer, display_order, is_active, status)
select 'Apakah saya perlu membuat akun untuk membaca SIRAMA?', 'Tidak. Informasi publik dapat dibaca tanpa akun. Login hanya tersedia bagi admin untuk mengelola konten.', 1, true, 'published'
where not exists (select 1 from public.faqs existing where existing.article_id is null and existing.scholarship_id is null and existing.question = 'Apakah saya perlu membuat akun untuk membaca SIRAMA?');

insert into public.faqs (question, answer, display_order, is_active, status)
select 'Apakah SIRAMA memberi diagnosis kesehatan atau mental?', 'Tidak. Materi SIRAMA adalah informasi edukasi dan tidak menggantikan pemeriksaan atau penilaian profesional.', 2, true, 'published'
where not exists (select 1 from public.faqs existing where existing.article_id is null and existing.scholarship_id is null and existing.question = 'Apakah SIRAMA memberi diagnosis kesehatan atau mental?');

insert into public.faqs (question, answer, display_order, is_active, status)
select 'Apakah SIRAMA merupakan layanan resmi pemerintah atau klinik?', 'SIRAMA tidak menyatakan afiliasi pemerintah atau status klinik. Identitas pengelola dan status layanan perlu dikonfirmasi sebelum klaim kelembagaan ditampilkan.', 3, true, 'published'
where not exists (select 1 from public.faqs existing where existing.article_id is null and existing.scholarship_id is null and existing.question = 'Apakah SIRAMA merupakan layanan resmi pemerintah atau klinik?');

insert into public.faqs (question, answer, display_order, is_active, status)
select 'Apakah pesan WhatsApp langsung dikirim saat tombol ditekan?', 'Tidak. Tautan membuka WhatsApp dengan draf pesan umum yang dapat kamu periksa dan ubah sendiri sebelum mengirim. Nomor SIRAMA hanya ditampilkan jika sudah dikonfigurasi sebagai nomor resmi.', 4, true, 'published'
where not exists (select 1 from public.faqs existing where existing.article_id is null and existing.scholarship_id is null and existing.question = 'Apakah pesan WhatsApp langsung dikirim saat tombol ditekan?');

insert into public.faqs (question, answer, display_order, is_active, status)
select 'Apakah SIRAMA menyimpan cerita masalah saya?', 'Situs ini tidak menyediakan formulir pengaduan atau konsultasi dan tidak menyimpan cerita kasus pengunjung. Jika kamu memilih menghubungi layanan lain, pengelolaan percakapan mengikuti kebijakan layanan tersebut.', 5, true, 'published'
where not exists (select 1 from public.faqs existing where existing.article_id is null and existing.scholarship_id is null and existing.question = 'Apakah SIRAMA menyimpan cerita masalah saya?');

insert into public.faqs (question, answer, display_order, is_active, status)
select 'Apa yang harus dilakukan dalam bahaya langsung?', 'Jangan menunggu balasan WhatsApp. Pindah ke tempat aman jika memungkinkan dan hubungi layanan darurat setempat atau orang dewasa tepercaya. Untuk kekerasan terhadap perempuan/anak, SAPA 129 dapat dihubungi di 129 atau WhatsApp 08111-129-129.', 6, true, 'published'
where not exists (select 1 from public.faqs existing where existing.article_id is null and existing.scholarship_id is null and existing.question = 'Apa yang harus dilakukan dalam bahaya langsung?');

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, 'Kemendikdasmen: Kapan Siswa Perlu Cerita kepada Guru Bimbingan dan Konseling?',
  'https://ditsmp.kemendikdasmen.go.id/berita/kapan-siswa-perlu-cerita-kepada-guru-bimbingan-dan-konseling-bk',
  '2026-11-25'
from public.articles a
where a.slug in ('keterampilan-remaja', 'perencanaan-karier', 'potensi-diri')
and not exists (
  select 1 from public.article_sources existing
  where existing.article_id = a.id
    and existing.url = 'https://ditsmp.kemendikdasmen.go.id/berita/kapan-siswa-perlu-cerita-kepada-guru-bimbingan-dan-konseling-bk'
);

insert into public.faqs (article_id, question, answer, display_order, is_active, status)
select a.id, seed.question, seed.answer, seed.display_order, true, 'published'
from (values
  ('persiapan-melanjutkan-pendidikan', 'Kapan sebaiknya mulai menyiapkan pilihan setelah lulus?', 'Mulai bertahap dengan mencari informasi jenjang, biaya, minat, dan jadwal resmi. Guru BK atau orang dewasa tepercaya dapat membantu membandingkan pilihan.', 1),
  ('persiapan-melanjutkan-pendidikan', 'Bagaimana jika biaya menjadi kendala?', 'Periksa bantuan pendidikan pada situs resmi pemerintah atau kampus dan pastikan syarat serta periode masih berlaku.', 2),
  ('keterampilan-remaja', 'Keterampilan apa yang perlu saya pelajari?', 'Mulai dari hal yang ingin dicoba dan kebutuhan belajar atau kegiatanmu. Tidak ada satu daftar yang wajib untuk semua orang.', 1),
  ('keterampilan-remaja', 'Apakah harus membeli kursus berbayar?', 'Tidak. Kamu bisa mulai lewat proyek sederhana, perpustakaan, kegiatan sekolah, atau sumber belajar gratis yang penyelenggarannya jelas.', 2),
  ('perencanaan-karier', 'Apakah saya harus menentukan karier sekarang?', 'Tidak. Kamu dapat mengeksplorasi minat dan informasi, lalu meninjau pilihan seiring pengalaman dan tahap pendidikan.', 1),
  ('perencanaan-karier', 'Siapa yang bisa membantu merencanakan karier?', 'Guru BK, keluarga yang aman, alumni, dan sumber resmi pendidikan dapat membantu menjelaskan pilihan tanpa memaksa satu keputusan.', 2),
  ('potensi-diri', 'Bagaimana jika saya belum tahu potensi saya?', 'Tidak apa-apa. Coba kegiatan baru secara bertahap, perhatikan hal yang membuatmu tertarik, dan mintalah umpan balik yang membangun.', 1),
  ('potensi-diri', 'Apakah potensi harus selalu berupa prestasi akademik?', 'Tidak. Minat, kepedulian, kreativitas, ketekunan, dan kemampuan bekerja sama juga dapat menjadi kekuatan yang berkembang.', 2),
  ('memeriksa-informasi-program', 'Bagaimana memastikan beasiswa masih dibuka?', 'Periksa tanggal terbaru di situs resmi penyelenggara. Jangan mengandalkan poster atau ringkasan lama.', 1),
  ('memeriksa-informasi-program', 'Apakah SIRAMA meminta data untuk pendaftaran?', 'Tidak. Proses pendaftaran hanya dilakukan melalui kanal resmi penyelenggara; SIRAMA tidak meminta dokumen atau kata sandi.', 2)
) as seed(slug, question, answer, display_order)
join public.articles a on a.slug = seed.slug
where not exists (
  select 1 from public.faqs existing
  where existing.article_id = a.id and existing.question = seed.question
);
