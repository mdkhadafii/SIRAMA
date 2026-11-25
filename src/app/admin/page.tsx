import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { LogoutButton } from "@/features/auth/logout-button";
import { getAuthenticatedAdmin } from "@/lib/security/authorization";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export const metadata: Metadata = { title: "Pengelolaan konten", robots: { index: false, follow: false } };
const sections = [
  ["Artikel dan topik", "Atur artikel edukasi, kesehatan, psikologis, dan keselamatan.", "/admin/artikel"],
  ["Pendidikan dan beasiswa", "Kelola informasi program serta tautan resmi.", "/admin/beasiswa"],
  ["Pertanyaan umum", "Kelola FAQ global maupun FAQ yang terhubung dengan konten.", "/admin/faq"],
  ["Kategori", "Atur kategori konten yang ditampilkan kepada pembaca.", "/admin/kategori"],
  ["Kontak dan identitas", "Atur nomor WhatsApp, jam layanan, serta informasi situs.", "/admin/pengaturan"],
];

async function readPublishedCounts() {
  try {
    const supabase = await createSupabaseServerClient();
    const [articles, scholarships, faqs] = await Promise.all([
      supabase.from("articles").select("id", { count: "exact", head: true }).eq("status", "published"),
      supabase.from("scholarships").select("id", { count: "exact", head: true }).eq("status", "published"),
      supabase.from("faqs").select("id", { count: "exact", head: true }).eq("status", "published"),
    ]);
    if (articles.error || scholarships.error || faqs.error) return null;
    return { articles: articles.count ?? 0, scholarships: scholarships.count ?? 0, faqs: faqs.count ?? 0 };
  } catch { return null; }
}

export default async function AdminPage() {
  const admin = await getAuthenticatedAdmin();
  if (!admin) redirect("/admin/login");
  const counts = await readPublishedCounts();
  return <main id="konten-utama" className="page-gutter py-10 sm:py-14"><header className="flex flex-wrap items-start justify-between gap-5 border-b border-border pb-6"><div><p className="eyebrow">SIRAMA · Pengelola</p><h1 className="mt-3 text-3xl font-semibold tracking-[-0.04em] sm:text-4xl">Ruang pengelolaan konten</h1><p className="mt-2 text-base text-secondary">Halo, {admin.displayName}. Kelola informasi yang dibaca pengunjung.</p></div><LogoutButton/></header><section className="py-7" aria-labelledby="content-stat-title"><h2 id="content-stat-title" className="text-lg font-semibold">Konten terpublikasi</h2>{counts ? <dl className="mt-4 grid grid-cols-3 divide-x divide-border border-y border-border"><div className="py-4 pr-4"><dt className="text-sm text-muted-foreground">Artikel</dt><dd className="mt-1 text-2xl font-semibold">{counts.articles}</dd></div><div className="px-4 py-4"><dt className="text-sm text-muted-foreground">Beasiswa</dt><dd className="mt-1 text-2xl font-semibold">{counts.scholarships}</dd></div><div className="py-4 pl-4"><dt className="text-sm text-muted-foreground">FAQ</dt><dd className="mt-1 text-2xl font-semibold">{counts.faqs}</dd></div></dl> : <p className="mt-3 border-l-2 border-[#a4513f] pl-4 text-sm leading-6 text-secondary">Ringkasan belum dapat dimuat. Pastikan migrasi CMS dan koneksi database sudah aktif.</p>}</section><section className="grid gap-x-8 sm:grid-cols-2" aria-label="Modul pengelolaan">{sections.map(([title, description, href], index) => <article key={href} className="border-t-[3px] border-primary py-5"><p className="text-sm font-semibold text-muted-foreground">Modul {String(index + 1).padStart(2, "0")}</p><h2 className="mt-2 text-xl font-semibold"><Link href={href} className="underline decoration-border underline-offset-4 hover:text-primary">{title}</Link></h2><p className="mt-2 text-base leading-7 text-secondary">{description}</p><Link href={href} className="mt-3 inline-flex min-h-11 items-center text-sm font-semibold text-primary underline underline-offset-4">Buka pengelolaan</Link></article>)}</section></main>;
}
