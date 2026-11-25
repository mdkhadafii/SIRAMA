"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { LoaderCircle, Plus, RefreshCw, Save } from "lucide-react";
import { Button } from "@/components/ui/button";
import { LogoutButton } from "@/features/auth/logout-button";

export type Resource = "articles" | "scholarships" | "faqs" | "categories" | "site_settings";
type Field = { key: string; label: string; type?: "text" | "textarea" | "select" | "date" | "url" | "checkbox" | "image"; required?: boolean; options?: { value: string; label: string }[]; help?: string };
type Item = Record<string, unknown> & { id?: string; key?: string };
type ApiResponse = { data?: { items?: Item[]; item?: Item; url?: string }; error?: { message?: string } };

const fields: Record<Resource, Field[]> = {
  articles: [
    { key: "title", label: "Judul", required: true }, { key: "slug", label: "Alamat halaman (slug)", required: true, help: "Gunakan huruf kecil dan tanda hubung." },
    { key: "content_type", label: "Jenis konten", type: "select", required: true, options: [{ value: "general", label: "Edukasi umum" }, { value: "health", label: "Kesehatan" }, { value: "mental_health", label: "Kesehatan mental" }, { value: "education", label: "Pendidikan" }, { value: "safety", label: "Kekerasan dan keselamatan" }] },
    { key: "category_id", label: "Kategori", type: "select", required: true }, { key: "excerpt", label: "Ringkasan", type: "textarea", required: true },
    { key: "content", label: "Isi artikel", type: "textarea", required: true, help: "Gunakan paragraf dan subjudul jelas. Hindari data pribadi atau cerita kasus." },
    { key: "sources_text", label: "Sumber rujukan", type: "textarea", required: true, help: "Satu sumber per baris: Nama instansi atau dokumen | https://tautan-resmi. Pastikan sumber benar-benar mendukung isi." },
    { key: "reviewed_at", label: "Tanggal pemeriksaan konten", type: "date" }, { key: "thumbnail_url", label: "Gambar sampul", type: "image", help: "PNG, JPEG, atau WebP maksimal 5 MB." },
    { key: "image_alt", label: "Deskripsi gambar" }, { key: "status", label: "Status publikasi", type: "select", required: true, options: [{ value: "draft", label: "Draf" }, { value: "published", label: "Terbit" }, { value: "archived", label: "Diarsipkan" }] },
  ],
  scholarships: [
    { key: "title", label: "Nama program", required: true }, { key: "slug", label: "Alamat halaman (slug)", required: true },
    { key: "provider", label: "Penyelenggara", required: true }, { key: "description", label: "Deskripsi", type: "textarea", required: true },
    { key: "education_level", label: "Jenjang pendidikan", required: true }, { key: "requirements", label: "Persyaratan", type: "textarea", help: "Satu persyaratan per baris." },
    { key: "benefits", label: "Manfaat", type: "textarea", help: "Satu manfaat per baris." }, { key: "application_period", label: "Periode pendaftaran", type: "textarea" },
    { key: "application_steps", label: "Cara mendaftar", type: "textarea" }, { key: "deadline", label: "Tanggal penutupan (jika pasti)", type: "date" },
    { key: "official_url", label: "Tautan penyelenggara resmi", type: "url", required: true }, { key: "category_id", label: "Kategori", type: "select", required: true },
    { key: "reviewed_at", label: "Tanggal pemeriksaan", type: "date" }, { key: "thumbnail_url", label: "Gambar sampul", type: "image" },
    { key: "image_alt", label: "Deskripsi gambar" }, { key: "status", label: "Status publikasi", type: "select", required: true, options: [{ value: "draft", label: "Draf" }, { value: "published", label: "Terbit" }, { value: "archived", label: "Diarsipkan" }] },
  ],
  faqs: [
    { key: "question", label: "Pertanyaan", type: "textarea", required: true }, { key: "answer", label: "Jawaban", type: "textarea", required: true },
    { key: "article_id", label: "Terhubung dengan artikel (opsional)", type: "select" }, { key: "scholarship_id", label: "Terhubung dengan beasiswa (opsional)", type: "select" }, { key: "display_order", label: "Urutan tampil" },
    { key: "status", label: "Status publikasi", type: "select", required: true, options: [{ value: "draft", label: "Draf" }, { value: "published", label: "Terbit" }, { value: "archived", label: "Diarsipkan" }] },
  ],
  categories: [
    { key: "name", label: "Nama kategori", required: true }, { key: "slug", label: "Slug", required: true },
    { key: "type", label: "Jenis", type: "select", required: true, options: [{ value: "health", label: "Kesehatan" }, { value: "counseling", label: "Kesehatan mental" }, { value: "report", label: "Keselamatan" }, { value: "article", label: "Edukasi umum" }, { value: "scholarship", label: "Pendidikan dan beasiswa" }] },
    { key: "description", label: "Deskripsi", type: "textarea" }, { key: "is_active", label: "Tampilkan kategori", type: "checkbox" },
  ],
  site_settings: [
    { key: "key", label: "Pengaturan", type: "select", required: true, options: [{ value: "whatsapp_official_number", label: "Nomor WhatsApp resmi" }, { value: "contact_hours", label: "Jam layanan terkonfirmasi" }, { value: "public_contact", label: "Kontak publik" }, { value: "site_identity", label: "Identitas pengelola yang disetujui" }] },
    { key: "value", label: "Nilai pengaturan", type: "textarea", required: true, help: "Nomor Indonesia memakai format 62, tanpa tanda plus atau nol awal." },
    { key: "is_public", label: "Tampilkan kepada pengunjung", type: "checkbox" },
  ],
};
const labels: Record<Resource, string> = { articles: "Artikel dan topik", scholarships: "Pendidikan dan beasiswa", faqs: "FAQ", categories: "Kategori", site_settings: "Pengaturan situs" };
const nav: { resource: Resource; href: string }[] = [{ resource: "articles", href: "/admin/artikel" }, { resource: "scholarships", href: "/admin/beasiswa" }, { resource: "faqs", href: "/admin/faq" }, { resource: "categories", href: "/admin/kategori" }, { resource: "site_settings", href: "/admin/pengaturan" }];
const defaults: Record<Resource, Record<string, unknown>> = {
  articles: { content_type: "general", status: "draft", sources_text: "", reviewed_at: "", thumbnail_url: "", image_alt: "" },
  scholarships: { status: "draft", category_id: "", requirements: "", benefits: "", application_period: "", application_steps: "", deadline: "", reviewed_at: "", thumbnail_url: "", image_alt: "" },
  faqs: { article_id: "", scholarship_id: "", display_order: 0, status: "draft" },
  categories: { type: "article", description: "", is_active: true },
  site_settings: { key: "whatsapp_official_number", value: "", is_public: true },
};
const text = (value: unknown) => value == null ? "" : String(value);

export function ContentManager({ resource }: { resource: Resource }) {
  const [items, setItems] = useState<Item[]>([]);
  const [options, setOptions] = useState<{ categories: Item[]; articles: Item[]; scholarships: Item[] }>({ categories: [], articles: [], scholarships: [] });
  const [selected, setSelected] = useState<Item | null>(null);
  const [values, setValues] = useState<Record<string, unknown>>(defaults[resource]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const config = useMemo(() => fields[resource], [resource]);

  const load = useCallback(async () => {
    setLoading(true); setError(null);
    try {
      const response = await fetch("/api/admin/content?kind=" + resource, { cache: "no-store", credentials: "same-origin" });
      const result = await response.json() as ApiResponse;
      if (!response.ok || !result.data?.items) { setError(result.error?.message ?? "Konten belum dapat dimuat."); return; }
      setItems(result.data.items);
      if (resource === "articles" || resource === "scholarships" || resource === "faqs") {
        const categoriesResponse = await fetch("/api/admin/content?kind=categories", { cache: "no-store" });
        const categoriesResult = await categoriesResponse.json() as ApiResponse;
        let articlesResult: ApiResponse | null = null;
        if (resource === "faqs") {
          const articlesResponse = await fetch("/api/admin/content?kind=articles", { cache: "no-store" });
          articlesResult = await articlesResponse.json() as ApiResponse;
        }
        let scholarshipsResult: ApiResponse | null = null;
        if (resource === "faqs") {
          const scholarshipResponse = await fetch("/api/admin/content?kind=scholarships", { cache: "no-store" });
          scholarshipsResult = await scholarshipResponse.json() as ApiResponse;
        }
        setOptions({ categories: categoriesResult.data?.items ?? [], articles: articlesResult?.data?.items ?? [], scholarships: scholarshipsResult?.data?.items ?? [] });
      }
    } catch { setError("Koneksi terganggu. Coba muat ulang."); }
    finally { setLoading(false); }
  }, [resource]);
  useEffect(() => {
    const timer = window.setTimeout(() => void load(), 0);
    return () => window.clearTimeout(timer);
  }, [load]);

  function beginEdit(item: Item) {
    setSelected(item);
    setValues(Object.fromEntries(config.map((field) => [field.key, item[field.key] ?? defaults[resource][field.key] ?? (field.type === "checkbox" ? false : "")])));
    setError(null); setMessage(null);
  }
  function beginNew() { setSelected(null); setValues({ ...defaults[resource] }); setError(null); setMessage(null); }
  function setValue(key: string, value: unknown) { setValues((current) => ({ ...current, [key]: value })); }

  async function upload(file?: File) {
    if (!file) return;
    setSaving(true); setError(null);
    try {
      const body = new FormData(); body.set("file", file);
      const response = await fetch("/api/admin/upload", { method: "POST", body, credentials: "same-origin" });
      const result = await response.json() as ApiResponse;
      if (!response.ok || !result.data?.url) { setError(result.error?.message ?? "Gambar belum dapat diunggah."); return; }
      setValue("thumbnail_url", result.data.url); setMessage("Gambar berhasil diunggah. Isi deskripsinya sebelum menyimpan.");
    } catch { setError("Gambar belum dapat diunggah."); }
    finally { setSaving(false); }
  }

  async function save(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault(); setSaving(true); setError(null); setMessage(null);
    try {
      const isSettings = resource === "site_settings";
      const method = selected && !isSettings ? "PATCH" : "POST";
      const url = "/api/admin/content?kind=" + resource + (selected && !isSettings ? "&id=" + encodeURIComponent(text(selected.id)) : "");
      const response = await fetch(url, { method, headers: { "Content-Type": "application/json" }, body: JSON.stringify(values), cache: "no-store", credentials: "same-origin" });
      const result = await response.json() as ApiResponse;
      if (!response.ok) { setError(result.error?.message ?? "Konten belum dapat disimpan."); return; }
      setMessage("Perubahan berhasil disimpan."); setSelected(result.data?.item ?? null); await load();
    } catch { setError("Koneksi terganggu. Coba simpan kembali."); }
    finally { setSaving(false); }
  }

  function optionsFor(field: Field) {
    if (field.key === "category_id") return options.categories.filter((item) => item.is_active !== false).map((item) => ({ value: text(item.id), label: text(item.name) }));
    if (field.key === "article_id") return [{ value: "", label: "FAQ umum atau untuk beasiswa" }, ...options.articles.map((item) => ({ value: text(item.id), label: text(item.title) }))];
    if (field.key === "scholarship_id") return [{ value: "", label: "Tidak terhubung ke beasiswa" }, ...options.scholarships.map((item) => ({ value: text(item.id), label: text(item.title) }))];
    return field.options ?? [];
  }
  function titleOf(item: Item) { return text(item.title ?? item.question ?? item.name ?? item.key ?? "Pengaturan"); }
  function statusOf(item: Item) {
    if (item.status === "draft") return "Draf";
    if (item.status === "published") return "Terbit";
    if (item.status === "archived") return "Diarsipkan";
    return item.is_active ? "Aktif" : "Nonaktif";
  }

  return <main id="konten-utama" className="page-gutter py-9 sm:py-12">
    <header className="flex flex-wrap items-start justify-between gap-5 border-b border-border pb-5"><div><Link className="inline-flex min-h-11 items-center text-sm font-semibold text-primary underline underline-offset-4" href="/admin">Kembali ke pengelolaan</Link><p className="eyebrow mt-3">SIRAMA · Pengelola</p><h1 className="mt-2 text-3xl font-semibold tracking-tight">{labels[resource]}</h1></div><LogoutButton/></header>
    <nav className="mt-4 flex flex-wrap gap-x-5 gap-y-1 border-b border-border" aria-label="Modul pengelolaan">{nav.map((item) => <Link key={item.href} href={item.href} aria-current={item.resource === resource ? "page" : undefined} className={"inline-flex min-h-11 items-center text-sm font-semibold underline-offset-4 " + (item.resource === resource ? "border-b-2 border-primary text-primary" : "text-secondary hover:text-primary")}>{labels[item.resource]}</Link>)}</nav>
    <div className="grid gap-9 py-7 lg:grid-cols-[minmax(13rem,0.72fr)_minmax(0,1.28fr)]">
      <section aria-labelledby="entries-title"><div className="flex items-center justify-between gap-3 border-b border-border pb-3"><h2 id="entries-title" className="font-semibold">Daftar konten</h2><Button size="small" onClick={beginNew}><Plus aria-hidden="true"/>Tambah</Button></div><button type="button" onClick={() => void load()} className="mt-2 inline-flex min-h-11 items-center gap-2 text-sm font-semibold text-secondary underline underline-offset-4"><RefreshCw aria-hidden="true"/>Muat ulang</button>{loading ? <p className="py-5 text-sm text-secondary" role="status">Memuat konten…</p> : error ? <p className="py-5 text-sm text-danger" role="alert">{error}</p> : items.length ? <ul className="mt-2 divide-y divide-border">{items.map((item, index) => <li key={text(item.id ?? item.key ?? index)}><button type="button" onClick={() => beginEdit(item)} className={"w-full py-3 text-left " + (selected?.id === item.id ? "text-primary" : "text-secondary")}><span className="block font-semibold">{titleOf(item)}</span><span className="mt-1 block text-sm text-muted-foreground">{statusOf(item)}</span></button></li>)}</ul> : <p className="py-5 text-sm text-secondary">Belum ada konten tersimpan.</p>}</section>
      <section aria-labelledby="editor-title"><h2 id="editor-title" className="border-b border-border pb-3 font-semibold">{selected ? "Edit konten" : "Konten baru"}</h2><form className="mt-4 grid gap-4" onSubmit={save}>{config.map((field) => { const inputId = "cms-" + field.key; return <div className="grid gap-2" key={field.key}><label className="text-sm font-semibold" htmlFor={inputId}>{field.label}{field.required ? " *" : ""}</label>{field.type === "checkbox" ? <input id={inputId} type="checkbox" checked={Boolean(values[field.key])} onChange={(event) => setValue(field.key, event.target.checked)} className="size-5 accent-primary"/> : field.type === "select" ? <select id={inputId} value={text(values[field.key])} required={field.required} onChange={(event) => setValue(field.key, event.target.value)} className="min-h-12 border border-border bg-background px-3 text-base">{optionsFor(field).map((option) => <option key={option.value} value={option.value}>{option.label}</option>)}</select> : field.type === "textarea" ? <textarea id={inputId} value={text(values[field.key])} required={field.required} onChange={(event) => setValue(field.key, event.target.value)} rows={field.key === "content" ? 14 : 5} maxLength={field.key === "content" ? 40000 : 10000} className="min-h-12 border border-border bg-background px-3 py-2 text-base leading-7"/> : field.type === "image" ? <div className="grid gap-2"><input id={inputId} type="file" accept="image/png,image/jpeg,image/webp" disabled={saving} onChange={(event) => void upload(event.target.files?.[0])} className="min-h-11 text-sm"/>{values.thumbnail_url ? <p className="break-all text-sm text-muted-foreground">Gambar tersimpan: {text(values.thumbnail_url)}</p> : null}</div> : <input id={inputId} type={field.type ?? "text"} value={text(values[field.key])} required={field.required} maxLength={1000} onChange={(event) => setValue(field.key, event.target.value)} className="min-h-12 border border-border bg-background px-3 text-base"/>}{field.help ? <p className="text-sm leading-6 text-muted-foreground">{field.help}</p> : null}</div>; })}{error ? <p role="alert" className="text-sm text-danger">{error}</p> : null}{message ? <p role="status" className="text-sm text-success">{message}</p> : null}<div className="flex flex-wrap gap-3"><Button type="submit" disabled={saving}>{saving ? <LoaderCircle className="animate-spin" aria-hidden="true"/> : <Save aria-hidden="true"/>}{saving ? "Menyimpan" : "Simpan perubahan"}</Button><Button type="button" variant="outline" onClick={beginNew} disabled={saving}>Batalkan edit</Button></div></form></section>
    </div>
  </main>;
}

