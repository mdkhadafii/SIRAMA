"use client";

import { useRef } from "react";
import Link from "next/link";
import { ChevronDown } from "lucide-react";
import { serviceNavigation } from "@/components/layouts/site-navigation";

export function ServiceDropdown() {
  const menuRef = useRef<HTMLDetailsElement>(null);
  const summaryRef = useRef<HTMLElement>(null);

  return (
    <details
      ref={menuRef}
      className="service-menu relative"
      onKeyDown={(event) => {
        if (event.key === "Escape" && menuRef.current?.open) {
          menuRef.current.open = false;
          summaryRef.current?.focus();
        }
      }}
    >
      <summary ref={summaryRef} className="site-nav-link flex cursor-pointer list-none items-center gap-1 px-2 text-sm font-semibold marker:hidden [&::-webkit-details-marker]:hidden">
        Ruang layanan
        <ChevronDown className="service-menu-chevron size-4" aria-hidden="true" />
      </summary>
      <div className="service-menu-panel absolute right-0 top-[calc(100%+0.5rem)] z-40 w-80 border border-border bg-surface p-2 shadow-[0_16px_38px_rgb(20_35_33_/_12%)]">
        <p className="px-3 pb-2 pt-2 text-xs font-bold uppercase tracking-[0.12em] text-muted-foreground">Pilih ruang informasi</p>
        {serviceNavigation.map((item) => (
          <Link key={item.href} href={item.href} className="flex min-h-11 items-center px-3 py-2 text-sm font-medium text-secondary no-underline transition-colors hover:bg-muted hover:text-primary" onClick={() => { if (menuRef.current) menuRef.current.open = false; }}>
            {item.label}
          </Link>
        ))}
      </div>
    </details>
  );
}
