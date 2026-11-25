# Kesiapan Rilis SIRAMA

## Status

Belum siap deployment/operasi. Pengubahan produk dan sebagian source publik/CMS telah dikerjakan, tetapi acceptance criteria belum dibuktikan end-to-end.

## Gerbang rilis

- [ ] Migration CMS, media, dan seed editorial diterapkan dan diperiksa di Supabase Cloud.
- [ ] RLS anon/admin lulus; public signups dinonaktifkan; akun admin memiliki role yang tepat.
- [ ] Typecheck, lint, dan production build pada source terakhir lulus.
- [ ] Alur publik, CTA, 404, CMS CRUD, status publikasi, dan upload lulus browser test.
- [ ] Draft/archived tidak terbaca publik, termasuk melalui URL/query langsung.
- [ ] Mobile/tablet/desktop, keyboard, screen reader smoke check, kontras, dan reduced motion ditinjau.
- [ ] Rujukan kesehatan/kekerasan/krisis/beasiswa ditinjau; tanggal, sumber, dan nomor diuji.
- [ ] Nomor WhatsApp SIRAMA, pengelola, jam layanan, dan pernyataan identitas disetujui sebelum tampil.
- [ ] Environment preview/deployment aman dan tidak mencetak secrets; privasi/hosting terms diperiksa.
- [ ] Pemilik menyetujui cakupan rilis.

## Batas keselamatan

Jangan gunakan data nyata atau identitas remaja saat demo/CMS testing. SIRAMA bukan klinik, penyedia layanan profesional, atau layanan darurat. SAPA 129, Healing119, dan layanan darurat merupakan milik pihak eksternal. Jangan janjikan respons petugas SIRAMA tanpa konfirmasi.

Detail teknis dan ketergantungan ada di IMPLEMENTATION_PLAN.md dan TASKS.md.

## Hasil pemeriksaan source terakhir

- `npm.cmd run typecheck`: lulus.
- `npm.cmd run lint`: lulus tanpa error/warning.
- `npm.cmd run build` pada konfigurasi standar: kompilasi source lulus; Next berhenti pada langkah `Running TypeScript` dengan `spawn EPERM`. Build produksi kemudian berhasil dengan `workerThreads: true` dan satu worker sementara; pemeriksaan tipe Next dilewati karena `npm.cmd run typecheck` mandiri lulus. `next.config.ts` dipulihkan setelah percobaan. Build konfigurasi standar tetap perlu dijalankan di Windows/CI yang mengizinkan child process.
- `npm.cmd run dev -- --port 3001`: gagal saat Next memanggil `child_process.fork` dengan `spawn EPERM`. Smoke test HTTP dijalankan melalui server produksi hasil workaround; pengujian browser dan viewport manual belum dilakukan.
- Smoke test HTTP dari hasil build: halaman publik utama/detail merespons 200; `/admin` redirect ke `/admin/login`; API CMS tanpa sesi menolak dengan 401; rute akses demo lama dan API demo lama memberi 404.
- Temuan itu adalah penolakan OS/runtime terhadap pembuatan proses child. Bukti pada sesi sebelumnya menunjukkan Windows Application Control memblokir executable Supabase CLI; event log policy tidak tersedia untuk memastikan aturan spesifik yang menolak worker Node/Next. Belum ada dasar untuk menyimpulkan ini sebagai error kompilasi aplikasi.
- Tidak ada migration Cloud yang dijalankan dari sesi ini. Nilai credentials tidak dicetak, dimasukkan ke source, atau dibagikan di chat.
