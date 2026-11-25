# Pedoman Agent — SIRAMA

## Sumber kebenaran

- Baca PRD.md sebelum mengubah aplikasi. PRD revisi terbaru menggantikan arahan lama yang bertentangan.
- DESIGN_SYSTEM.md mengatur identitas visual; IMPLEMENTATION_PLAN.md dan TASKS.md mengatur prioritas dan status berdasarkan bukti.
- Audit rute, modul server, dan kebijakan database terkait sebelum mengubah fitur.

## Arah produk dan batas keselamatan

- SIRAMA adalah platform informasi, edukasi, pendampingan awal, dan akses bantuan remaja. Situs publik tanpa akun; autentikasi hanya untuk admin.
- Pertahankan modul yang masih layak; lakukan refactor kecil, jelas, dan terpisah per fitur.
- Jangan menghidupkan kembali demo gate, akun remaja, registrasi, pengajuan konsultasi/pengaduan, tracking, riwayat, atau penjadwalan.
- Jangan menerima atau menguji data kesehatan, identitas, atau pengalaman kekerasan nyata. Data demonstrasi harus sintetis.
- Jangan menyatakan SIRAMA sebagai klinik/pemerintah, jangan mengarang alamat, kontak, jam petugas, statistik, ahli, atau SLA.
- Materi kesehatan bukan diagnosis/resep. Materi kekerasan harus berpihak pada korban dan keselamatan. WhatsApp SIRAMA bukan jalur darurat.

## Standar sumber dan konten

- Klaim faktual memerlukan tautan sumber asli yang relevan, bukan mesin pencari.
- Utamakan Kemenkes, Kemendukbangga/BKKBN/GenRe, KemenPPPA, kementerian pendidikan, WHO, UNICEF Indonesia, profesi tepercaya, dan penyelenggara resmi.
- Tulis ulang dengan Bahasa Indonesia jelas, empatik, dan tidak menghakimi; jangan menyalin artikel.
- Beasiswa/jadwal harus ditinjau ulang sebelum publikasi. Konten belum terverifikasi tetap internal atau draft.
- Cantumkan tanggal pemeriksaan dan FAQ yang menjawab pertanyaan nyata, bukan pengisi.

## Arsitektur

- Next.js App Router, TypeScript strict, Tailwind, komponen shadcn/ui yang disesuaikan, Lucide, Supabase SSR/Auth/PostgreSQL, Zod.
- Letakkan UI domain di src/features, primitives di src/components, logika server di src/lib, migrasi aditif di supabase/migrations.
- Client components hanya untuk interaksi browser. Mutasi CMS dan pemeriksaan role berjalan di server.
- Query publik memakai publishable key dan RLS; secret key hanya server. Jangan cetak credential. Jangan mengandalkan penyembunyian UI sebagai proteksi.
- Mutasi CMS memvalidasi Zod, memeriksa same-origin, sesi/role admin, dan batas payload.
- Jangan menghapus tabel legacy secara destruktif. Catat migrasi dan retensi; cabut akses aplikasi melalui policy/grant bila sesuai.
- Rute dan API lama harus dihapus, bukan sekadar disembunyikan pada navigasi.

## UI/UX dan aksesibilitas

- Bahasa Indonesia; desain editorial modern, human-centered, ramah remaja, profesional, mobile-first.
- Hindari landing SaaS generik, gradient/glassmorphism/emoji dekoratif, kartu/badge berlebihan, lorem ipsum, statistik/testimoni palsu.
- Gunakan hirarki tipografi, whitespace, warna semantik, foto/ilustrasi berlisensi, dan variasi layout yang membantu membaca.
- Pastikan keyboard, fokus, label, kontras, target sentuh, reduced-motion, serta state loading/empty/error/success.
- Tombol bantuan jelas. Bila nomor WhatsApp tidak valid, jangan buat URL wa.me.

## Validasi perubahan

- Untuk QA, jalankan npm.cmd run typecheck, npm.cmd run lint, dan npm.cmd run build; bedakan error aplikasi dari batas process policy.
- Jangan menyatakan E2E lulus tanpa browser dan database aktual.
- Perbarui TASKS.md hanya berdasarkan hasil nyata; catat migrasi Cloud/manual dan pengujian yang menunggu pemilik.
- Jangan membaca/menampilkan .env.local; jangan menyimpan credential, kode admin, atau data sensitif pada dokumentasi, screenshot, maupun chat.
