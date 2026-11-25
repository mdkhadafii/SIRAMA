# PRD — SIRAMA

**Produk:** SIRAMA — Sistem Informasi Ramah Remaja  
**Tagline:** Ruang Aman, Generasi Sehat, Masa Depan Hebat.  
**Status:** Arah produk revisi; menggantikan kebutuhan yang bertentangan di versi sebelumnya.  
**Bahasa:** Bahasa Indonesia  
**Platform:** Web responsif, mobile-first  
**Target:** Remaja dan masyarakat umum; admin konten  
**Teknologi:** Next.js App Router, TypeScript, Tailwind CSS, shadcn/ui, Lucide React, Supabase PostgreSQL/Auth, Zod, Vercel.

## 1. Ringkasan dan tujuan

SIRAMA adalah platform informasi, edukasi, pendampingan awal, dan akses bantuan bagi remaja. Tujuannya membantu pengunjung menemukan informasi dengan sumber yang dapat diperiksa, memahami topik yang dihadapi, mengetahui langkah awal yang aman, dan mengenali kapan perlu mencari bantuan profesional atau layanan resmi.

SIRAMA bukan klinik, penyedia diagnosis, kanal pengaduan resmi, layanan darurat, ataupun sistem pengajuan dan pelacakan pelayanan. Pengunjung membaca seluruh informasi tanpa akun. Komunikasi dengan petugas SIRAMA, bila pengelola dan nomor WhatsApp resminya telah dikonfirmasi, dilakukan langsung melalui WhatsApp dengan draf umum yang dapat diperiksa sebelum dikirim.

## 2. Pengguna dan alur utama

### Pengunjung

1. Membuka beranda dan memilih salah satu dari empat layanan utama.
2. Menelusuri topik atau artikel pendidikan.
3. Membaca pembahasan, FAQ kontekstual, sumber asli, tanggal pemeriksaan, dan batas layanan.
4. Memilih tautan bantuan resmi atau tombol WhatsApp bila konfigurasi valid tersedia.
5. Meninjau draf pesan di WhatsApp dan memutuskan sendiri apakah akan mengirim.

Akun tidak diperlukan. Tidak ada formulir konsultasi/pengaduan, registrasi, profil remaja, penjadwalan, riwayat, atau kode pelacakan.

### Admin

1. Masuk melalui halaman admin dengan akun yang diprovisikan secara aman.
2. Mengelola artikel/topik, beasiswa, FAQ, kategori, gambar, sumber, identitas dan kanal kontak.
3. Menyimpan konten sebagai **draft**, **published**, atau **archived**.
4. Hanya konten **published** dapat dibaca publik.
5. Keluar dari sesi admin.

### Krisis

Untuk kekerasan terhadap perempuan/anak, tampilkan SAPA 129 sebagai kanal resmi. Untuk krisis kesehatan mental, tampilkan Healing119.id/119 ekstensi 8 beserta batas ketersediaannya. Tekankan agar pengunjung tidak menunggu WhatsApp SIRAMA dalam bahaya langsung, mencari orang/tempat aman, dan memakai layanan darurat resmi. Setiap kanal dan nomor harus bersumber resmi serta ditinjau ulang.

## 3. Layanan dan standar konten

### Kesehatan remaja

Topik meliputi kesehatan reproduksi, pubertas, kebersihan diri, menstruasi, gizi, anemia, kesehatan seksual/reproduksi, pencegahan IMS, pencegahan pernikahan dini, serta perilaku hidup bersih dan sehat.

Setiap halaman topik menjelaskan pengertian; faktor relevan; tanda/gejala bila relevan; dampak; pencegahan; langkah awal aman; kapan mencari tenaga kesehatan; FAQ kontekstual; sumber asli; dan tanggal pemeriksaan. Konten tidak mendiagnosis atau meresepkan obat.

### Kesehatan mental dan konseling

Topik meliputi stres, kecemasan, tekanan akademik, kepercayaan diri, keluarga, pertemanan, kesepian, pengelolaan emosi, media sosial, tanda depresi, dan pencarian bantuan profesional. Bahasa harus empatik dan tidak menghakimi; halaman bukan alat diagnosis.

### Pendidikan dan beasiswa

Topik meliputi peluang pendidikan, beasiswa, persiapan studi, keterampilan, karier, potensi diri, pelatihan, dan pengembangan remaja. Informasi program memuat nama, penyelenggara, deskripsi, syarat, jenjang, manfaat, periode, cara mendaftar, FAQ relevan, serta tautan resmi. Jadwal/persyaratan tidak boleh direka; konten kedaluwarsa harus diperiksa dan diperbarui atau diarsipkan.

### Kekerasan dan perundungan

Topik meliputi perundungan fisik, verbal, sosial, cyberbullying, kekerasan fisik, verbal, seksual, emosional, dalam hubungan, serta perlindungan anak/remaja. Setiap halaman menjelaskan definisi, tanda, contoh, dampak, langkah bagi korban, dukungan teman, cara menemukan tempat/orang aman, kapan meminta bantuan, FAQ, dan sumber resmi. Utamakan kendali serta keselamatan korban; jangan menyalahkan atau menyuruh korban menghadapi pelaku sendirian.

### Standar editorial

Setiap konten memiliki judul, ringkasan, pembahasan terstruktur, informasi praktis, FAQ kontekstual, rujukan yang dapat dibuka, dan tanggal pemeriksaan. Rujukan diutamakan dari Kemenkes, Kemendukbangga/BKKBN/GenRe, KemenPPPA, kementerian pendidikan, WHO, UNICEF Indonesia, profesi kredibel, dan penyelenggara resmi. Tulis rangkuman dengan bahasa sendiri. Bila rujukan belum diverifikasi, jangan publikasikan klaim faktual; catat kekurangannya secara internal.

## 4. Kebutuhan fungsional

- F-01: Seluruh halaman informasi publik terbuka tanpa akun.
- F-02: Beranda menampilkan navigasi, hero, empat layanan, topik populer, pusat edukasi, beasiswa, bantuan kekerasan, FAQ, kontak, dan footer.
- F-03: Setiap layanan memiliki indeks dan halaman detail topik.
- F-04: FAQ tersedia global serta tertaut ke artikel/topik/beasiswa.
- F-05: Sumber dan tanggal pemeriksaan tampil pada konten yang terbit.
- F-06: WhatsApp memakai URL Click to Chat dengan nomor tervalidasi, pesan umum per layanan, dan tanpa data sensitif. Jika nomor belum valid, tautan tidak dibuat.
- F-07: Bantuan krisis resmi ditampilkan terpisah dari kontak SIRAMA dan tidak bergantung pada nomor SIRAMA.
- F-08: Admin dapat mengelola konten, sumber, gambar, kategori, FAQ, beasiswa, kontak, jam layanan terkonfirmasi, dan identitas yang disetujui.
- F-09: Alur publikasi draft/published/archived; hanya published dapat dibaca publik.
- F-10: Statistik admin hanya menghitung data aktual.
- F-11: Admin routes dan API memeriksa sesi serta role admin di server.
- F-12: Rute lama untuk akun remaja, request, laporan, demo gate, dan tracking dihapus/nonaktif; autentikasi hanya admin.

## 5. Sitemap

**Publik:** /, /tentang, /kesehatan-remaja, /kesehatan-remaja/[slug], /kesehatan-mental, /kesehatan-mental/[slug], /pendidikan, /pendidikan/[slug], /kekerasan-perundungan, /kekerasan-perundungan/[slug], /edukasi, /edukasi/[slug], /faq, /kontak, /privasi.

**Admin:** /admin/login, /admin, /admin/artikel, /admin/beasiswa, /admin/faq, /admin/kategori, /admin/pengaturan.

Rute legacy dapat diarahkan ke halaman informasi terkait atau memberi 404; endpoint mutasi lama harus dihapus. Tidak ada tautan publik ke login admin.

## 6. Skema data konseptual

- **profiles:** id mengacu auth.users, display_name, role (user legacy atau admin), avatar, timestamps. Akun baru hanya admin terprovisi; role bukan input pengguna.
- **categories:** nama, slug unik, tipe/topik, deskripsi, status aktif, timestamps.
- **articles:** kategori, judul, slug unik, ringkasan, isi, content_type (general, health, mental_health, education, safety), gambar dan alt, sumber utama kompatibilitas, status publikasi, waktu terbit, tanggal review, author nullable untuk seed editorial.
- **scholarships:** penyelenggara, judul/slug, deskripsi, syarat, manfaat, jenjang, tenggat/periode, cara mendaftar, tautan resmi, gambar, FAQ kompatibilitas, status, tanggal review, creator nullable.
- **faqs:** pertanyaan/jawaban, urutan, status/aktif, opsional tepat satu relasi ke artikel atau beasiswa; tanpa relasi berarti FAQ global.
- **article_sources:** satu atau lebih nama, HTTPS URL, tanggal pemeriksaan per artikel.
- **site_settings:** key unik, value JSON, is_public, updater/timestamps. Hanya nilai publik dibaca pengunjung; nilai kontak hanya diubah admin.
- Tabel service_requests, service_status_history, tracking_tokens, dan bucket rate-limit lama tetap dipertahankan tanpa operasi penghapusan. Aplikasi baru tidak mengakses tabel layanan; bucket hanya dipakai untuk membatasi percobaan login admin melalui RPC server-only dengan scope `auth`.

## 7. Aturan bisnis

- Publikasi memerlukan sumber yang mendukung isi dan tanggal pemeriksaan, terutama kesehatan, keselamatan, program, serta kontak darurat.
- Draft dan archived tidak dapat dipilih query publik atau kebijakan RLS.
- Nomor WhatsApp SIRAMA kosong/tidak valid berarti CTA tidak aktif dan tidak ada tautan palsu. Format: 62 + nomor tanpa tanda plus atau nol awal.
- Pesan WhatsApp hanya draf umum; browser tidak mengirimnya otomatis dan tidak menambahkan identitas/kronologi.
- SIRAMA bukan layanan 24 jam. Jam respons hanya ditampilkan setelah pengelola mengonfirmasi.
- Beasiswa ditautkan ke penyelenggara; tanggal lama tidak disajikan sebagai pendaftaran aktif.
- Pengunjung tidak mengirim data lewat formulir situs. Admin dilarang memasukkan data kasus, kesehatan, atau identitas anak/remaja ke CMS.

## 8. Non-functional, keamanan, dan privasi

- Responsif pada ponsel kecil, tablet, desktop; tidak ada overflow horizontal.
- TypeScript strict, validasi Zod server-side, komponen terpakai ulang, UI Bahasa Indonesia.
- Aksesibilitas: semantik HTML, label form, fokus terlihat, navigasi keyboard, kontras WCAG AA, reduced motion, FAQ accordion usable.
- RLS aktif dengan GRANT eksplisit; anon hanya membaca konten published dan pengaturan publik. Admin memiliki CRUD sesuai role.
- Secret key hanya server-side. Cookie auth aman; admin routes dilindungi. Registrasi publik Supabase dinonaktifkan pada pengaturan Auth proyek.
- Validasi URL HTTPS, tipe/MIME/file signature/ukuran gambar, sanitasi konten, same-origin untuk mutasi, rate-limit login, dan pesan error yang tidak membocorkan rahasia.
- Jangan mengumpulkan data kesehatan, identitas remaja, cerita kasus, atau kronologi pengaduan. Jangan kirim data sensitif ke analytics/log.
- Konten kesehatan/krisis ditinjau sumber asli; jangan membuat afiliasi, statistik, ahli, jam, nomor, atau klaim resmi yang belum disetujui.

## 9. Acceptance criteria

- Seluruh kebutuhan F-01–F-12 berjalan pada deployment uji.
- Tidak ada rute/tautan/form/endpoint/teks/konfigurasi demo gate, akun remaja, request, atau tracking yang masih aktif.
- Empat layanan, halaman detail, FAQ kontekstual, sumber, dan tanggal review terbit benar.
- Draft/arsip ditolak oleh query publik dan RLS.
- WhatsApp hanya tampil untuk nomor terkonfirmasi dan draf dapat ditinjau.
- CMS mengelola konten utama dan perubahan publik mengikuti status.
- Login hanya admin; user non-admin tidak dapat membuka halaman atau API CMS.
- Responsif, keyboard, screen reader labels, lint, typecheck, functional/security tests, dan production build lulus.
- Status implementasi di TASKS.md hanya dicentang setelah bukti uji tersedia.

## 10. Keputusan yang memerlukan pemilik

Nama/cakupan resmi pengelola, wilayah SIRAMA, jam/kapasitas petugas, nomor WhatsApp resmi, persetujuan tenaga/editor, siklus beasiswa berikutnya, kontak privasi, retensi legacy data, dan status organisasi belum boleh diasumsikan. SAPA 129 dan Healing119 merupakan layanan eksternal milik instansi terkait.
