import type { Metadata, Viewport } from "next";
import { Info } from "lucide-react";
import { SiteFooter } from "@/components/layouts/site-footer";
import { SiteHeader } from "@/components/layouts/site-header";
import { getPublicSiteUrl } from "@/lib/site-url";
import "./globals.css";

export const metadata: Metadata = {
  metadataBase: getPublicSiteUrl() ?? undefined,
  title: { default: "SIRAMA — Sistem Informasi Ramah Remaja", template: "%s | SIRAMA" },
  description: "Informasi kesehatan, kesejahteraan, pendidikan, dan akses bantuan bagi remaja.",
  applicationName: "SIRAMA",
  icons: { icon: "/favicon.svg" },
};
export const viewport: Viewport = { width: "device-width", initialScale: 1, themeColor: "#f5f8f6" };

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="id">
      <body className="min-h-screen bg-background font-sans text-foreground antialiased">
        <a className="skip-link" href="#konten-utama">Lewati ke konten utama</a>
        <div className="border-b border-[#c5d9d2] bg-[#e7f0ec] text-sm text-[#214a42]" role="note">
          <div className="page-gutter flex min-h-10 items-center gap-2 py-2 leading-5">
            <Info className="size-4 shrink-0" aria-hidden="true" />
            <p>Informasi edukasi umum; bukan diagnosis atau layanan darurat.</p>
          </div>
        </div>
        <SiteHeader />
        {children}
        <SiteFooter />
      </body>
    </html>
  );
}
