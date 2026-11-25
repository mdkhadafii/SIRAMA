import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { ShieldCheck } from "lucide-react";
import { BrandMark } from "@/components/layouts/brand-mark";
import { LoginForm } from "@/features/auth/login-form";
import { getAuthenticatedAdmin } from "@/lib/security/authorization";

export const metadata: Metadata = { title: "Masuk admin", robots: { index: false, follow: false } };
export default async function AdminLoginPage({ searchParams }: { searchParams: Promise<{ next?: string | string[] }> }) {
  if (await getAuthenticatedAdmin()) redirect("/admin");
  const params = await searchParams; const candidate = Array.isArray(params.next) ? params.next[0] : params.next;
  const returnTo = candidate?.startsWith("/admin/") && !candidate.startsWith("/admin/login") ? candidate : "/admin";
  return <main id="konten-utama" className="page-gutter py-12 sm:py-16"><section className="mx-auto max-w-xl border border-border border-t-[3px] border-t-primary bg-surface p-6 sm:p-9"><div className="flex items-start gap-4 border-b border-border pb-6"><BrandMark className="size-11"/><div><p className="eyebrow">Pengelola konten</p><h1 className="mt-2 text-3xl font-semibold tracking-tight">Masuk admin SIRAMA</h1></div></div><p className="mt-6 text-base leading-7 text-secondary">Halaman ini hanya untuk admin yang telah diberi akses. Tidak tersedia pendaftaran akun publik.</p><div className="mt-5 flex items-start gap-3 border-l-2 border-primary bg-[#f1f6f3] p-4 text-sm leading-6 text-secondary"><ShieldCheck className="mt-0.5 size-5 shrink-0 text-primary" aria-hidden="true"/>Gunakan akun pengelola yang telah diprovisikan dan dilindungi kata sandi kuat.</div><LoginForm returnTo={returnTo}/></section></main>;
}
