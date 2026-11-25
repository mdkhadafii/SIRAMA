-- Refresh source URLs and time-sensitive KIP Kuliah schedule after checking the official sites.
update public.article_sources
set url = 'https://kesprimkom.kemkes.go.id/konten/127/151/0/cegah-bunuh-diri-dukung-kesehatan-jiwa-kenali-layanan-healing119-id'
where url = 'https://kesprimkom.kemkes.go.id/konten/146/151/0/cegah-bunuh-diri-dukung-kesehatan-jiwa-kenali-layanan-healing119-id';

update public.article_sources
set title = 'JDIH Kementerian Kesehatan: Permenkes No. 2 Tahun 2025 tentang Penyelenggaraan Upaya Kesehatan Reproduksi',
    url = 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-2-tahun-2025'
where url = 'https://jdih.kemkes.go.id/common/dokumen/2025permenkes002.pdf';

update public.article_sources
set title = 'Kementerian Kesehatan: Menjaga Kesehatan Remaja di Tengah Perubahan Fisik',
    url = 'https://upk.kemkes.go.id/new/menjaga-kesehatan-remaja-di-tengah-perubahan-fisik-tekanan-sosial-dan-gaya-hidup'
where url = 'https://www.kemkes.go.id/id/bagi-para-remaja-kenali-perubahan-fisik-untuk-menghindari-masalah-seksual';

update public.article_sources
set title = 'Kementerian Kesehatan: Menjaga Kebersihan Alat Reproduksi pada Remaja',
    url = 'https://ayosehat.kemkes.go.id/pentingnya-menjaga-kebersihan-alat-reproduksi-pada-remaja-pria-dan-wanita'
where url = 'https://ayosehat.kemkes.go.id/pentingnya-menjaga-kebersihan-alat-reproduksi';

update public.article_sources
set title = 'Kementerian Kesehatan: Anemia',
    url = 'https://ayosehat.kemkes.go.id/topik-penyakit/defisiensi-nutrisi/anemia'
where url = 'https://ayosehat.kemkes.go.id/mengenal-gejala-anemia-pada-remaja';

update public.article_sources
set title = 'JDIH Kementerian Kesehatan: Permenkes No. 3 Tahun 2026 tentang Penanggulangan Penyakit',
    url = 'https://jdih.kemkes.go.id/documents/peraturan-menteri-kesehatan-nomor-3-tahun-2026'
where url = 'https://jdih.kemkes.go.id/storage/documents/pdfs/2022permenkes023.pdf';

update public.scholarships
set deadline = '2026-12-01',
    application_period = 'Saat diperiksa pada 25 November 2026, portal resmi mencantumkan pendaftaran akun siswa hingga 1 Desember 2026. Jadwal dapat berubah; periksa portal sebelum mendaftar.',
    application_steps = 'Baca panduan terbaru pada portal resmi
Periksa kesesuaian data sekolah dan identitas melalui jalur resmi
Ikuti pendaftaran akun dan seleksi sesuai pengumuman penyelenggara
Hubungi kanal resmi portal jika ada perbedaan informasi',
    reviewed_at = '2026-11-25',
    faq = '[{"Apakah pendaftaran KIP Kuliah 2026 masih dibuka?":"Saat diperiksa pada 25 November 2026, portal resmi mencantumkan pendaftaran akun siswa sampai 1 Desember 2026. Jadwal dapat berubah, jadi periksa kembali portal sebelum mendaftar."},{"Apakah SIRAMA menerima pendaftaran?":"Tidak. Pendaftaran dan verifikasi hanya dilakukan melalui penyelenggara resmi."},{"Apakah semua penerima otomatis mendapat bantuan biaya hidup yang sama?":"Tidak. Besaran dan kelayakan mengikuti ketentuan penyelenggara yang berlaku."}]'::jsonb
where slug = 'kip-kuliah-2026';

update public.faqs
set question = 'Di mana saya memeriksa jadwal KIP Kuliah?',
    answer = 'Saat diperiksa pada 25 November 2026, portal resmi mencantumkan pendaftaran akun siswa hingga 1 Desember 2026. Jadwal dapat berubah, jadi periksa portal penyelenggara sebelum mendaftar.'
where scholarship_id = (select id from public.scholarships where slug = 'kip-kuliah-2026')
  and question = 'Apakah pendaftaran KIP Kuliah 2026 masih dibuka?';

comment on table public.scholarships is 'Informasi beasiswa dari penyelenggara; periode dan ketentuan harus diperiksa ulang sebelum dipublikasikan.';

insert into public.article_sources (article_id, title, url, reviewed_at)
select a.id, source.title, source.url, '2026-11-25'
from (values
  ('menstruasi', 'Kementerian Kesehatan: Manajemen Kebersihan Menstruasi', 'https://kemkes.go.id/id/manajemen-kebersihan-menstruasi-perlu-dipahami'),
  ('pencegahan-pernikahan-anak', 'Kemendukbangga/BKKBN: Cegah Pernikahan Anak, BKKBN Edukasi Remaja', 'https://sulteng.kemendukbangga.go.id/posts/4d589e46-01e4-446f-897c-904de93b39ee-cegah-pernikahan-anak-bkkbn-edukasi-remaja'),
  ('perilaku-hidup-bersih-sehat', 'Ayo Sehat Kementerian Kesehatan: Gerakan Masyarakat Hidup Sehat', 'https://ayosehat.kemkes.go.id/germas'),
  ('keterampilan-remaja', 'Pusat Asesmen Pendidikan Kemendikdasmen: Penilaian Bakat Minat dan Potensi Karier Siswa', 'https://pusmendik.kemendikdasmen.go.id/produk?item=penilaian-bakat-minat-pbm&kategori=tes'),
  ('perencanaan-karier', 'Pusat Asesmen Pendidikan Kemendikdasmen: Penilaian Bakat Minat dan Potensi Karier Siswa', 'https://pusmendik.kemendikdasmen.go.id/produk?item=penilaian-bakat-minat-pbm&kategori=tes'),
  ('potensi-diri', 'Pusat Asesmen Pendidikan Kemendikdasmen: Penilaian Bakat Minat dan Potensi Karier Siswa', 'https://pusmendik.kemendikdasmen.go.id/produk?item=penilaian-bakat-minat-pbm&kategori=tes'),
  ('perundungan-fisik', 'Polri: Call Center 110', 'https://polri.go.id/kontak/call-center-110'),
  ('perundungan-verbal', 'Polri: Call Center 110', 'https://polri.go.id/kontak/call-center-110'),
  ('perundungan-sosial', 'Polri: Call Center 110', 'https://polri.go.id/kontak/call-center-110'),
  ('cyberbullying', 'Polri: Call Center 110', 'https://polri.go.id/kontak/call-center-110'),
  ('kekerasan-fisik', 'Polri: Call Center 110', 'https://polri.go.id/kontak/call-center-110'),
  ('kekerasan-verbal', 'Polri: Call Center 110', 'https://polri.go.id/kontak/call-center-110'),
  ('kekerasan-seksual', 'Polri: Call Center 110', 'https://polri.go.id/kontak/call-center-110'),
  ('kekerasan-emosional', 'Polri: Call Center 110', 'https://polri.go.id/kontak/call-center-110'),
  ('kekerasan-dalam-hubungan', 'Polri: Call Center 110', 'https://polri.go.id/kontak/call-center-110'),
  ('perlindungan-anak-remaja', 'Polri: Call Center 110', 'https://polri.go.id/kontak/call-center-110')
) as source(slug, title, url)
join public.articles a on a.slug = source.slug
where not exists (
  select 1 from public.article_sources existing
  where existing.article_id = a.id and existing.url = source.url
);
