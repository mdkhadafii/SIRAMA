import Link from "next/link";
import { BrandMark } from "@/components/layouts/brand-mark";
import { MobileNavigation } from "@/components/layouts/mobile-navigation";
import { siteNavigation } from "@/components/layouts/site-navigation";
import { ServiceDropdown } from "@/components/layouts/service-dropdown";

export function SiteHeader() {
  return (
    <header className="site-header">
      <div className="page-gutter flex min-h-[4.5rem] items-center justify-between gap-4 sm:min-h-[5rem]">
        <Link href="/" className="inline-flex min-w-0 items-center gap-3 no-underline" aria-label="SIRAMA — halaman beranda">
          <BrandMark />
          <span className="min-w-0">
            <span className="block text-sm font-extrabold tracking-[0.17em]">SIRAMA</span>
            <span className="hidden text-sm text-muted-foreground sm:block">Sistem Informasi Ramah Remaja</span>
          </span>
        </Link>
        <nav className="hidden items-center gap-1 lg:flex" aria-label="Navigasi utama">
          <ServiceDropdown />
          {siteNavigation.map((item) => <Link key={item.href} href={item.href} className="site-nav-link px-2 text-sm font-semibold">{item.label}</Link>)}
          <Link href="/kontak" className="ml-2 inline-flex min-h-11 items-center border border-primary px-4 text-sm font-semibold text-primary no-underline transition-colors hover:bg-primary hover:text-white">Cari bantuan</Link>
        </nav>
        <MobileNavigation />
      </div>
    </header>
  );
}
