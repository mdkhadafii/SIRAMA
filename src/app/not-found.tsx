import Link from "next/link";
import { Button } from "@/components/ui/button";

export default function NotFound() {
  return (
    <main id="konten-utama" className="page-gutter py-20 sm:py-28">
      <section className="max-w-2xl border-l-2 border-primary pl-5 sm:pl-8">
        <p className="text-xs font-bold uppercase tracking-[0.16em] text-primary">
          Halaman tidak ditemukan
        </p>
        <h1 className="mt-3 text-3xl font-semibold tracking-[-0.04em] text-foreground sm:text-4xl">
          Halaman yang kamu cari tidak tersedia.
        </h1>
        <p className="mt-4 max-w-xl text-sm leading-6 text-muted-foreground sm:text-base sm:leading-7">
          Periksa kembali alamat halaman atau lanjutkan membaca informasi di beranda.
        </p>
        <div className="mt-7">
          <Button asChild variant="outline">
            <Link href="/">
              Kembali ke beranda
            </Link>
          </Button>
        </div>
      </section>
    </main>
  );
}
