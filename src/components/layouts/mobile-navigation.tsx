"use client";

import { useRef } from "react";
import Link from "next/link";
import { Menu, X } from "lucide-react";
import { serviceNavigation, siteNavigation } from "@/components/layouts/site-navigation";

export function MobileNavigation() {
  const detailsRef = useRef<HTMLDetailsElement>(null);
  const summaryRef = useRef<HTMLElement>(null);

  return (
    <div
      className="relative lg:hidden"
      onKeyDown={(event) => {
        if (event.key === "Escape" && detailsRef.current?.open) {
          detailsRef.current.open = false;
          summaryRef.current?.focus();
        }
      }}
    >
      <details ref={detailsRef} className="mobile-nav">
        <summary
          ref={summaryRef}
          aria-controls="navigasi-mobile"
          className="grid size-11 cursor-pointer list-none place-items-center border border-border bg-surface text-foreground marker:hidden [&::-webkit-details-marker]:hidden"
        >
          <Menu className="mobile-menu-open-icon size-5" aria-hidden="true" />
          <X className="mobile-menu-close-icon size-5" aria-hidden="true" />
          <span className="sr-only">Navigasi utama</span>
        </summary>
        <nav
          id="navigasi-mobile"
          className="mobile-nav-panel absolute right-0 top-[calc(100%+0.75rem)] z-40 hidden border border-border bg-surface p-3 shadow-sm"
          aria-label="Navigasi utama"
        >
          <p className="px-3 pb-1 pt-2 text-xs font-bold uppercase tracking-[0.12em] text-muted-foreground">Ruang layanan</p>
          {serviceNavigation.map((item) => (
            <Link key={item.href} href={item.href} className="flex min-h-11 items-center px-3 py-2.5 text-sm font-medium text-secondary no-underline transition-colors hover:bg-muted hover:text-primary" onClick={() => { if (detailsRef.current) detailsRef.current.open = false; }}>
              {item.label}
            </Link>
          ))}
          <div className="my-2 border-t border-border" />
          {siteNavigation.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className="flex min-h-11 items-center px-3 py-2.5 text-sm font-medium text-secondary no-underline hover:bg-muted hover:text-primary"
              onClick={() => {
                if (detailsRef.current) detailsRef.current.open = false;
              }}
            >
              {item.label}
            </Link>
          ))}
          <Link href="/kontak" className="mt-2 flex min-h-11 items-center justify-center bg-primary px-3 py-2.5 text-sm font-semibold text-white no-underline transition-colors hover:bg-[#0b625c]" onClick={() => { if (detailsRef.current) detailsRef.current.open = false; }}>
            Cari bantuan
          </Link>
        </nav>
      </details>
    </div>
  );
}
