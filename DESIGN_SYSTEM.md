# Design System — SIRAMA

## Arah visual

SIRAMA terasa sebagai ruang informasi publik yang hangat, mudah dijelajahi, editorial, dan terpercaya bagi remaja. Gunakan gaya modern minimalis dan human-centered; susun halaman seperti publikasi digital, bukan panel administrasi atau landing SaaS generik. Seluruh UI memakai Bahasa Indonesia.

## Token warna

| Token | Nilai | Peran |
|---|---|---|
| Latar | #F5F8F6 | Kanvas halaman |
| Permukaan | #FFFFFF | Bidang baca dan form |
| Teks utama | #142321 | Headline dan isi utama |
| Teks sekunder | #344743 | Paragraf penjelas |
| Teks redup | #52635F | Metadata yang tetap terbaca |
| Batas | #D2DDD9 | Garis pemisah dan input |
| Hijau utama | #0F766E | Aksi dan navigasi utama |
| Biru aksen | #176B83 | Fokus keyboard dan tautan sekunder |
| Terracotta | #BD6947 | Aksen pendidikan/editorial |
| Bahaya | #B42318 | Error/ancaman dengan label teks |

Gunakan warna secara hemat; status selalu memiliki label teks. Validasi kombinasi foreground/background terhadap WCAG AA.

## Tipografi dan layout

- Keluarga sans modern yang telah dipasang (Plus Jakarta Sans) dengan fallback sistem.
- Body minimal 16px, line-height sekitar 1.6–1.8; metadata umumnya 14px atau lebih.
- Headline responsif dengan skala jelas; lebar baca artikel sekitar 65–72 karakter.
- Skala judul harus fluid, bukan melonjak ke ukuran desktop pada breakpoint `sm`: judul utama sekitar 32–64 px sesuai lebar viewport, judul halaman sekitar 32–60 px, dan judul artikel sekitar 32–52 px. Pastikan kalimat panjang tetap terbaca dalam baris yang wajar pada 320 px dan tablet.
- Grid berbasis whitespace, pemisah garis tipis, editorial columns dan aksen border. Radius kecil dan konsisten; hindari semua konten menjadi kartu.
- Container utama maksimal sekitar 76rem; gutter meningkat pada tablet/desktop. Tidak ada overflow horizontal pada layar sempit.

## Komponen dan pola

- Header publik ringkas dengan menu desktop yang mengelompokkan empat layanan dalam satu dropdown, menu mobile yang memuat seluruh tujuan utama, dan CTA bantuan yang selalu mudah ditemukan. Login admin tidak tampil sebagai navigasi publik.
- Hero memakai headline manusiawi, penjelasan, CTA informatif, dan ilustrasi karya lokal. Jangan gunakan metrik/testimoni dekoratif.
- Empat layanan diberi ikon Lucide konsisten dan deskripsi tugas yang jelas.
- Halaman daftar memakai editorial rows/columns; halaman detail memakai artikel, poin, FAQ accordion, sumber, tanggal review, dan bantuan kontekstual.
- FAQ menggunakan details/summary atau primitive accessible, target sentuh minimal 44px, state buka/tutup jelas.
- Bantuan krisis memakai notice dengan bahasa jelas, kanal resmi, kepemilikan instansi, dan batas layanan.
- WhatsApp CTA hanya link Click to Chat valid yang membuka draf umum. Jika belum tersedia, tampilkan penjelasan dan alternatif bantuan resmi.
- CMS admin menggunakan form berlabel, status publikasi, empty/loading/error/success, dan feedback operasi.

## Aksesibilitas dan gerak

- Skip link, urutan heading logis, landmark, aria-current, label form, dan pesan error tertaut.
- Kontrol keyboard-accessible; focus-visible tegas; kontras WCAG AA; ikon dekoratif aria-hidden.
- Hormati prefers-reduced-motion; animasi hanya transisi ringan yang mendukung status. Tampilkan konten lokal yang aman terlebih dahulu sambil CMS dimuat; gunakan skeleton editorial hanya untuk area yang belum memiliki konten lokal.
- Jangan memakai emoji sebagai ikon navigasi atau tindakan.

## Responsif

Rancang mulai dari 320px. Menu mobile nyaman dipakai dengan keyboard/sentuh; form satu kolom; artikel mudah dibaca. Pada layar besar perluas grid dan ruang kosong tanpa memperlebar baris teks. Periksa ponsel, tablet, dan desktop sebelum rilis.
