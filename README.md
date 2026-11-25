# SIRAMA

**Sistem Informasi Ramah Remaja** — *Ruang Aman, Generasi Sehat, Masa Depan Hebat.*

SIRAMA adalah platform informasi dan edukasi remaja dengan akses bantuan eksternal. Pengunjung tidak perlu membuat akun dan tidak mengirim data pribadi, kesehatan, atau cerita kasus melalui situs. SIRAMA bukan klinik, layanan diagnosis, kanal pengaduan resmi, ataupun layanan darurat.

## Menjalankan lokal

1. Siapkan Node.js 20.9+ dan npm.
2. Salin .env.example ke .env.local hanya jika file lokal belum ada. Jangan menimpa file yang telah terisi.
3. Isi konfigurasi melalui editor lokal/secret store. Jangan membagikan nilai secret, mencetaknya di log, atau melakukan commit .env.local.
4. Jalankan npm.cmd install.
5. Jalankan npm.cmd run dev, lalu buka http://localhost:3000.
6. Pemeriksaan: npm.cmd run typecheck, npm.cmd run lint, dan npm.cmd run build.

Tanpa Supabase, situs lokal memakai katalog editorial bawaan; login/admin CMS dan koneksi database tidak aktif. Sesudah Supabase dikonfigurasi, CMS menjadi sumber konten publik.

## Supabase Cloud

Tabel legacy dipertahankan tanpa penghapusan data. Setelah migration fondasi database yang telah dipakai sebelumnya, jalankan file berikut berurutan melalui Supabase SQL Editor pada proyek yang benar:

1. supabase/migrations/20261125150000_public_information_cms.sql
2. supabase/migrations/20261125151000_cms_public_media.sql
3. supabase/migrations/20261125152000_public_editorial_content.sql
4. supabase/migrations/20261125153000_admin_auth_rate_limit.sql
5. supabase/migrations/20261125154000_refresh_verified_references.sql

Migration editorial idempoten dan tidak menimpa konten dengan slug yang sudah ada. Periksa hasil query dan RLS sesudah diterapkan. Pastikan proyek/environment tepat sebelum menjalankan SQL.

Setelahnya:

- Nonaktifkan signups publik pada Supabase Auth settings. Login tersedia hanya untuk admin yang diprovisikan.
- Konfigurasikan redirect/callback Auth untuk URL lokal/preview/production.
- Provisikan akun admin melalui proses aman dan pastikan profiles.role bernilai admin. Jangan simpan password di source/dokumentasi.
- Simpan NEXT_PUBLIC_SUPABASE_URL dan NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY sebagai env hosting. SUPABASE_SECRET_KEY server-only dipakai terbatas untuk rate-limit login. Jangan kirim secret ke browser.
- Isi NEXT_PUBLIC_SITE_URL dengan origin HTTPS produksi agar metadata, sitemap, dan robots memakai domain yang benar.
- WHATSAPP_OFFICIAL_NUMBER opsional, format 62 diikuti nomor tanpa tanda plus dan tanpa nol awal. Kosongkan sampai pemilik mengonfirmasi nomor resmi.
- Jangan isi jam layanan, identitas pengelola, atau kontak publik yang belum dikonfirmasi.

Penerapan Cloud adalah tindakan manual pemilik/operator. Source code tidak mencetak nilai environment. Rotasi secret melalui dashboard dan hosting bila pernah terpapar.

## CMS dan konten

Admin mengelola artikel/topik, beasiswa, FAQ, kategori, sumber, gambar, dan pengaturan publikasi. Draft/archived tidak ditampilkan publik. Konten kesehatan, keselamatan, dan beasiswa harus memiliki sumber relevan dan tanggal pemeriksaan. Informasi program dan kanal krisis perlu diperiksa ulang sebelum rilis.

WhatsApp SIRAMA membuka draf umum untuk ditinjau pengunjung; tidak mengirim otomatis dan tidak menyertakan data sensitif. SAPA 129 dan Healing119 adalah layanan eksternal, bukan layanan SIRAMA.

## Struktur penting

- src/app: rute publik, admin, dan API server.
- src/features/content: katalog editorial, halaman topik, query publik, CTA WhatsApp.
- src/features/admin: CMS.
- src/lib: Supabase, auth, validation/security, environment.
- supabase/migrations: schema/RLS/storage dan seed editorial.
- CONTENT_REVIEW.md: status pemeriksaan sumber dan catatan editorial internal.
- PRD.md, AGENTS.md, DESIGN_SYSTEM.md, IMPLEMENTATION_PLAN.md, TASKS.md: keputusan produk dan status kerja.

## Status

Source publik/CMS telah dialihkan tetapi belum dinyatakan selesai sebelum migration Cloud baru diterapkan, Auth/RLS diuji, CMS dan halaman publik diuji browser, serta lint/typecheck/build pada revisi terbaru lulus. Lihat TASKS.md. Windows sebelumnya membatasi child process Next (spawn EPERM); verifikasi lagi di lokal/CI. Tidak ada deployment yang dilakukan oleh dokumentasi ini.
