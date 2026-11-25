import Link from "next/link";
import { BrandMark } from "@/components/layouts/brand-mark";

export function SiteFooter() {
  return (
    <footer className="site-footer">
      <div className="page-gutter grid gap-9 py-10 sm:py-12 md:grid-cols-[1.2fr_1fr] md:gap-16">
        <div className="flex items-start gap-3">
          <BrandMark className="size-10" />
          <div>
            <p className="text-sm font-extrabold tracking-[0.16em]">SIRAMA</p>
            <p className="mt-2 max-w-xl text-base leading-7 text-muted-foreground">Informasi, edukasi, dan jalur bantuan untuk remaja.</p>
            <p className="mt-3 text-sm font-medium tracking-wide text-secondary">Ruang Aman, Generasi Sehat, Masa Depan Hebat.</p>
          </div>
        </div>
        <nav aria-label="Navigasi footer">
          <p className="eyebrow mb-2">Jelajahi SIRAMA</p>
          <div className="grid grid-cols-2 gap-x-6 text-base">
            <Link href="/tentang" className="inline-flex min-h-11 items-center text-secondary transition-colors hover:text-primary">Tentang SIRAMA</Link>
            <Link href="/edukasi" className="inline-flex min-h-11 items-center text-secondary transition-colors hover:text-primary">Pusat edukasi</Link>
            <Link href="/faq" className="inline-flex min-h-11 items-center text-secondary transition-colors hover:text-primary">FAQ</Link>
            <Link href="/kontak" className="inline-flex min-h-11 items-center text-secondary transition-colors hover:text-primary">Kontak dan bantuan</Link>
            <Link href="/privasi" className="inline-flex min-h-11 items-center text-secondary transition-colors hover:text-primary">Kebijakan privasi</Link>
          </div>
        </nav>
        <div className="border-t border-border pt-4 text-sm leading-6 text-muted-foreground md:col-span-2">SIRAMA tidak menyatakan diri sebagai layanan pemerintah atau klinik medis. Kontak darurat dan layanan resmi dikelola oleh instansi masing-masing.</div>
      </div>
    </footer>
  );
}
