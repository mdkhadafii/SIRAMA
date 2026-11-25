# Implementation Plan — SIRAMA

PRD.md saat ini menggantikan rencana sistem pengajuan demo sebelumnya. Source code tidak sama dengan migrasi Cloud atau E2E yang telah diverifikasi.

## Kondisi saat revisi

- Source Next.js dialihkan ke halaman informasi dan admin CMS.
- Katalog memuat 30 topik kesehatan/mental/keselamatan, lima panduan pendidikan, satu program KIP Kuliah dengan batas akun 1 Desember 2026 saat diperiksa pada 25 November 2026, dan FAQ kontekstual. Periode harus otomatis ditandai lewat setelah tanggal tersebut dan diperiksa ulang di portal resmi.
- Endpoint/komponen lama untuk demo, pengajuan, pelaporan, tracking, serta antrean admin dihapus.
- Migrasi CMS, storage, dan seed editorial tersedia di supabase/migrations. Perlu diterapkan manual ke Supabase Cloud secara berurutan; belum diverifikasi pada Cloud setelah perubahan ini.
- Integrasi login/CMS bergantung pada konfigurasi Supabase. Nomor WhatsApp SIRAMA belum boleh diaktifkan sebelum dikonfirmasi.
- E2E browser lintas role, uji viewport/perangkat, audit aksesibilitas formal, dan deployment baru belum diverifikasi.
- Source terakhir lulus typecheck dan lint. Build berhasil kompilasi lalu terhenti pada proses TypeScript dengan `spawn EPERM`; Next dev juga gagal mem-fork child process. Periksa pada terminal Windows/CI yang mengizinkan proses worker sebelum menilai build dan melakukan browser QA.

## Urutan fase

### Fase 1 — Reframing produk dan audit source

- Terapkan PRD revisi dan petakan modul yang dapat dipakai ulang.
- Hilangkan ketergantungan navigasi pada alur lama tanpa menghapus data database.
- Inventaris risiko, keputusan terbuka, dan konfigurasi eksternal.

### Fase 2 — Database CMS dan kebijakan akses

- Terapkan migration CMS aditif, bucket media, seed editorial, dan rate limit login admin.
- Seed artikel/topik, FAQ, referensi, kategori, serta beasiswa editorial.
- Verifikasi RLS: anon hanya membaca published/public settings; admin CRUD; draft/arsip tertutup; bucket hanya admin menulis.
- Nonaktifkan public signups pada Supabase Auth dashboard; jangan hapus tabel legacy sebelum audit.

### Fase 3 — Sumber editorial dan jalur bantuan

- Gunakan Supabase sebagai sumber CMS saat konfigurasi tersedia; katalog editorial menjadi fallback lokal tanpa Supabase.
- Implementasikan referensi, tanggal review, FAQ konteks, dan arsip.
- Aktifkan WhatsApp SIRAMA hanya setelah pemilik memberikan nomor resmi dan uji template per layanan.
- Verifikasi ulang rujukan krisis dan nomor eksternal menjelang rilis.

### Fase 4 — Website publik dan redesign

- Selesaikan beranda dan navigasi sesuai urutan di PRD.
- Selesaikan indeks/detail empat layanan, FAQ global/kontekstual, tentang, privasi, kontak, footer, dan SEO.
- Pastikan informasi beasiswa menyebut status siklus secara akurat.
- Hapus petunjuk pengembangan internal dari UI publik.

### Fase 5 — Admin CMS

- Auth admin-only, proteksi halaman/API, CRUD artikel, beasiswa, sumber, FAQ, kategori, pengaturan, dan media.
- Status draft/published/archived, statistik aktual, validasi dan sanitasi.
- Uji session expiry, login gagal, role non-admin, dan akses langsung endpoint.

### Fase 6 — QA dan keamanan

- Typecheck, lint, production build.
- Uji fungsional publik/CMS, role, RLS, visibilitas draft, upload, serta format WhatsApp.
- Keyboard/screen reader smoke test, kontras, responsif 320px/tablet/desktop.
- Tinjau konten kesehatan/krisis dan setiap tautan sumber; dokumentasikan hasil yang belum lulus.

### Fase 7 — Persiapan deployment

- Siapkan env Vercel, domain, Supabase URL/publishable key/server key, redirect Auth, signup disable, dan nomor WhatsApp terkonfirmasi.
- Deploy preview lebih dahulu; smoke test publik/admin tanpa data nyata; cek log, headers, dan privasi.
- Production deploy setelah acceptance criteria dan persetujuan operasional/pemilik terpenuhi.

## Prioritas

1. P0 keselamatan dan keamanan: rute lama ditutup, auth hanya admin, migrasi/RLS, nomor/bantuan valid.
2. P1 publikasi: seed dan sumber konten, status draft/published/archived, halaman topik.
3. P2 UX: beranda, navigasi, responsif, aksesibilitas, editorial polish.
4. P3 CMS lengkap, media, metadata, pengaturan, dan QA.
5. P4 deployment setelah verifikasi dan konfigurasi pemilik.

## Ketergantungan dan risiko

- Supabase Cloud membutuhkan migrasi baru dan public signup dinonaktifkan manual.
- SUPABASE_SECRET_KEY hanya untuk server dan rate-limit login; rotasi bila terpapar.
- Akun admin harus diprovisikan dengan role admin oleh operator berwenang.
- Nomor WhatsApp SIRAMA, jam layanan, identitas pengelola dan cakupan wilayah belum dikonfirmasi.
- Konten kesehatan memerlukan review editor/tenaga kompeten; siklus beasiswa harus terus diperiksa.
- Windows Application Control pernah memblokir Supabase CLI dan child process Next (spawn EPERM); periksa kembali pada lingkungan lokal/CI.
- Tabel legacy menyimpan struktur layanan lama; migrasi revisi tidak menjatuhkan atau menghapus datanya.
