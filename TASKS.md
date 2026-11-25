# TASKS — SIRAMA

**[x]** = implementasi dan verifikasi tercatat. **[~]** = sebagian/menunggu verifikasi atau dependensi. **[ ]** = belum dikerjakan. Jangan centang hanya karena source tersedia.

## A. Arah produk dan audit

- [x] Ganti konsep dari sistem request demo menjadi platform informasi tanpa akun publik.
- [x] Tetapkan sitemap publik dan admin-only.
- [x] Pertahankan tabel legacy secara aditif; migration baru tidak menghapus data lama.
- [~] Audit penuh semua teks/file stale di repository dan konfigurasi eksternal.

## B. Penghapusan alur lama

- [x] Hapus UI login/registrasi remaja, request, pengaduan, tracking, dan akses demo dari route source.
- [x] Hapus API demo access, service requests, laporan anonim, tracking, dan admin request queue.
- [x] Hapus schema, komponen, dan scope rate-limit lama dari alur aplikasi; tambahkan RPC login admin dengan scope `auth` saja.
- [~] Verifikasi endpoint lama memberi 404 pada server aktif.
- [ ] Nonaktifkan public signup pada Supabase Auth dashboard.

## C. Konten publik

- [x] Susun 10 topik kesehatan, 10 kesehatan mental, dan 10 kekerasan/perundungan beserta FAQ dan sumber katalog.
- [x] Susun lima panduan pendidikan/pengembangan diri dengan rujukan.
- [x] Verifikasi periode KIP Kuliah 2026 langsung di portal resmi; perbarui tenggat 1 Desember 2026 dan beri catatan bahwa jadwal dapat berubah.
- [x] Buat konten editorial beranda, ilustrasi lokal, serta jalur bantuan SAPA/Healing119.
- [x] Buat migration idempoten untuk seed artikel, sumber, FAQ, kategori, dan KIP Kuliah.
- [~] Desk review sumber resmi dilakukan; review editorial/tautan per halaman oleh peninjau domain/tenaga kompeten masih diperlukan. Lihat `CONTENT_REVIEW.md`.
- [ ] Terapkan migration CMS, storage, dan editorial ke Supabase Cloud.
- [ ] Periksa konten published dan sumber di database setelah migration.
- [ ] Tetapkan jadwal/proses pemeriksaan konten berkala.

## D. WhatsApp dan bantuan

- [x] Implementasikan Click to Chat server-side dengan validasi nomor dan template tanpa data sensitif.
- [x] Nonaktifkan CTA bila konfigurasi nomor SIRAMA belum valid.
- [x] Tampilkan SAPA 129 dan Healing119 sebagai kanal eksternal terpisah.
- [ ] Pemilik mengonfirmasi nomor WhatsApp resmi SIRAMA.
- [ ] Uji template/wa.me di mobile dan desktop setelah nomor resmi dimasukkan.
- [~] Verifikasi ulang kanal krisis resmi sebelum rilis.

## E. CMS dan keamanan

- [x] Implementasikan CMS artikel/topik, beasiswa, FAQ, kategori, settings, sumber, dan media.
- [x] Buat API admin dengan Zod, pemeriksaan admin dan origin pada mutasi.
- [x] Buat migration RLS published/public dan CRUD admin; bucket upload khusus admin.
- [x] Statistik CMS berdasarkan database, tanpa angka dekoratif.
- [~] CRUD belum diverifikasi live terhadap Supabase Cloud sesudah migration baru.
- [ ] Uji auth admin, role non-admin, RLS anon, route/API langsung, dan session expiry.
- [ ] Uji upload tipe konten, ukuran, signature, dan akses gambar.
- [ ] Pastikan public signup disabled dan Auth redirect URL produksi benar.
- [ ] Tetapkan aturan arsip/penghapusan dan audit trail konten.

## F. UI, aksesibilitas, dan SEO

- [x] Redesign header, footer, beranda, indeks, dan detail inti.
- [x] Buat ilustrasi SVG lokal dan custom CSS tokens.
- [x] Tambahkan metadata dasar, robots, dan sitemap untuk rute publik serta konten terbit.
- [x] Terapkan menu mobile, skip link, fokus keyboard, FAQ native accordion.
- [x] Ringkas header dengan menu layanan, samakan breakpoint navigasi, dan tambah feedback loading/transisi ringan serta cache baca publik 30 detik dengan timeout 1,5 detik.
- [x] Jalankan permintaan CMS publik secara paralel di halaman utama dan tampilkan skeleton editorial saat navigasi menunggu respons.
- [x] Stream konten lokal terlebih dahulu di beranda, indeks layanan, FAQ, dan pendidikan; CMS menggantinya setelah respons tersedia.
- [x] Terapkan skala judul fluid pada beranda dan halaman publik agar tidak pecah menjadi terlalu banyak baris pada ponsel/tablet.
- [~] Periksa tampilan manual di 320px, tablet, desktop dan simpan bukti.
- [ ] Audit kontras WCAG, keyboard, screen reader, reduced motion.
- [~] Audit manual semua CTA/navigasi publik dan halaman 404.
- [ ] Lengkapi metadata/canonical/sitemap/robots deployment publik.

## G. Pemeriksaan teknis dan rilis

- [x] Jalankan typecheck setelah revisi terakhir: `npm.cmd run typecheck` lulus tanpa error.
- [x] Jalankan lint setelah revisi terakhir: `npm.cmd run lint` lulus tanpa error/warning.
- [~] Build dengan konfigurasi standar mengompilasi source, lalu berhenti pada `spawn EPERM`. Build produksi berhasil dengan `workerThreads: true`, satu worker, dan pemeriksaan tipe Next sementara dilewati; `next.config.ts` dipulihkan dan pemeriksaan `tsc --noEmit` mandiri lulus. Jalankan lagi konfigurasi standar pada Windows/CI yang mengizinkan child process.
- [~] Smoke test HTTP lokal: halaman utama, indeks/detail tiap layanan, pendidikan, FAQ, kontak, privasi, robots, dan sitemap merespons 200; rute demo lama 404; `/admin` mengarah ke login admin dan API CMS tanpa sesi memberi 401. Pengujian browser/viewport manual masih belum dilakukan karena `next dev` gagal `spawn EPERM`.
- [ ] Functional test CMS: tambah/edit/publish/archive artikel, beasiswa, FAQ, kategori/settings, upload.
- [ ] Security test: non-admin ditolak; draft tidak tersedia via URL/API.
- [ ] Responsive dan accessibility tests mobile/tablet/desktop.
- [ ] Preview Vercel dan smoke test env/redirect/security headers.
- [ ] Persetujuan pemilik atas konten, identitas, kanal bantuan, dan rilis.

## Konfigurasi eksternal

- [ ] Terapkan migration 20261125150000, 20261125151000, 20261125152000, 20261125153000, dan 20261125154000 berurutan di Supabase SQL Editor.
- [ ] Nonaktifkan pendaftaran publik Supabase Auth.
- [ ] Pastikan admin sintetis diprovisikan melalui jalur tepercaya dengan role admin.
- [ ] Pasang env Supabase pada hosting melalui secret store.
- [ ] Tetapkan nomor WhatsApp resmi jika sudah disetujui.
- [ ] Isi jam, kontak, identitas pengelola hanya bila telah dikonfirmasi.
