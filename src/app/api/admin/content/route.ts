import { NextRequest } from "next/server";
import { z } from "zod";
import { apiError, apiSuccess, authorizationErrorResponse, isSameOriginRequest, readJsonBody } from "@/lib/security/http";
import { requireAdmin } from "@/lib/security/authorization";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export const runtime = "nodejs";
const resourceSchema = z.enum(["articles", "scholarships", "faqs", "categories", "site_settings"]);
const statusSchema = z.enum(["draft", "published", "archived"]);
const baseFields = {
  title: z.string().trim().min(1).max(200),
  slug: z.string().trim().regex(/^[a-z0-9]+(?:-[a-z0-9]+)*$/).max(220),
  status: statusSchema,
};
const sourceEntriesSchema = z.string().max(12000).optional().superRefine((value, context) => {
  for (const [index, rawLine] of (value ?? "").split(/\r?\n/).entries()) {
    const line = rawLine.trim();
    if (!line) continue;
    const separator = line.lastIndexOf(" | ");
    const title = separator >= 0 ? line.slice(0, separator).trim() : "";
    const url = separator >= 0 ? line.slice(separator + 3).trim() : "";
    try {
      if (!title || title.length > 250 || new URL(url).protocol !== "https:") throw new Error("invalid");
    } catch {
      context.addIssue({ code: "custom", message: "Setiap baris sumber harus memakai format Nama sumber | https://alamat-resmi.", path: [index] });
    }
  }
});
const schemas = {
  articles: z.object({
    ...baseFields,
    category_id: z.string().uuid(),
    excerpt: z.string().trim().min(1).max(1200),
    content: z.string().trim().min(1).max(40000),
    content_type: z.enum(["general", "health", "mental_health", "education", "safety"]),
    thumbnail_url: z.union([z.string().url().startsWith("https://"), z.literal("")]).optional(),
    image_alt: z.string().max(250).optional(),
    sources_text: sourceEntriesSchema,
    reviewed_at: z.union([z.string().regex(/^\d{4}-\d{2}-\d{2}$/), z.literal("")]).optional(),
  }).strict().superRefine((value, context) => {
    if (value.thumbnail_url && !value.image_alt?.trim()) context.addIssue({ code: "custom", message: "Deskripsi gambar wajib diisi jika gambar dipakai.", path: ["image_alt"] });
    if (value.status === "published" && !value.reviewed_at) context.addIssue({ code: "custom", message: "Tanggal pemeriksaan wajib diisi sebelum artikel diterbitkan.", path: ["reviewed_at"] });
    if (value.status === "published" && !parseSourceEntries(value.sources_text).length) context.addIssue({ code: "custom", message: "Tambahkan sedikitnya satu sumber rujukan resmi sebelum artikel diterbitkan.", path: ["sources_text"] });
  }),
  scholarships: z.object({
    ...baseFields,
    category_id: z.string().uuid(),
    provider: z.string().trim().min(1).max(150),
    description: z.string().trim().min(1).max(5000),
    requirements: z.string().max(10000).optional(),
    benefits: z.string().max(10000).optional(),
    education_level: z.string().max(100).optional(),
    deadline: z.union([z.string().regex(/^\d{4}-\d{2}-\d{2}$/), z.literal("")]).optional(),
    application_period: z.string().max(500).optional(),
    application_steps: z.string().max(5000).optional(),
    official_url: z.string().url().startsWith("https://"),
    thumbnail_url: z.union([z.string().url().startsWith("https://"), z.literal("")]).optional(),
    image_alt: z.string().max(250).optional(),
    reviewed_at: z.union([z.string().regex(/^\d{4}-\d{2}-\d{2}$/), z.literal("")]).optional(),
  }).strict().superRefine((value, context) => {
    if (value.thumbnail_url && !value.image_alt?.trim()) context.addIssue({ code: "custom", message: "Deskripsi gambar wajib diisi jika gambar dipakai.", path: ["image_alt"] });
    if (value.status === "published" && !value.reviewed_at) context.addIssue({ code: "custom", message: "Tanggal pemeriksaan wajib diisi sebelum informasi beasiswa diterbitkan.", path: ["reviewed_at"] });
  }),
  faqs: z.object({
    question: z.string().trim().min(1).max(500),
    answer: z.string().trim().min(1).max(5000),
    article_id: z.union([z.string().uuid(), z.literal("")]).optional(),
    scholarship_id: z.union([z.string().uuid(), z.literal("")]).optional(),
    display_order: z.coerce.number().int().min(0).max(9999).default(0),
    status: statusSchema,
  }).strict(),
  categories: z.object({
    name: z.string().trim().min(1).max(100),
    slug: z.string().trim().regex(/^[a-z0-9]+(?:-[a-z0-9]+)*$/).max(120),
    type: z.enum(["health", "counseling", "report", "article", "scholarship"]),
    description: z.string().max(1000).optional(),
    is_active: z.boolean(),
  }).strict(),
  site_settings: z.object({
    key: z.enum(["whatsapp_official_number", "contact_hours", "public_contact", "site_identity"]),
    value: z.string().max(500),
    is_public: z.boolean(),
  }).strict(),
} as const;

type Resource = z.infer<typeof resourceSchema>;
function parseSourceEntries(value: unknown): { title: string; url: string }[] {
  if (typeof value !== "string") return [];
  return value.split(/\r?\n/).map((line) => line.trim()).filter(Boolean).map((line) => {
    const separator = line.lastIndexOf(" | ");
    return { title: line.slice(0, separator).trim(), url: line.slice(separator + 3).trim() };
  });
}
function errorFrom(error: unknown) {
  if (error instanceof Error && error.name === "AuthorizationError") return authorizationErrorResponse(error);
  return null;
}
function rowForWrite(resource: Resource, input: Record<string, unknown>, userId: string) {
  const status = input.status;
  if (resource === "articles") {
    return {
      title: input.title, slug: input.slug, category_id: input.category_id, excerpt: input.excerpt, content: input.content,
      content_type: input.content_type, thumbnail_url: input.thumbnail_url || null, image_alt: input.image_alt || null,
      source_url: parseSourceEntries(input.sources_text)[0]?.url ?? null, status, author_id: userId,
      published_at: status === "published" ? new Date().toISOString() : null,
      reviewed_at: input.reviewed_at || null,
    };
  }
  if (resource === "scholarships") {
    return {
      title: input.title, slug: input.slug, category_id: input.category_id, provider: input.provider,
      description: input.description, requirements: input.requirements || null, benefits: input.benefits || null,
      education_level: input.education_level || null, deadline: input.deadline || null,
      application_period: input.application_period || null, application_steps: input.application_steps || null,
      official_url: input.official_url, thumbnail_url: input.thumbnail_url || null, image_alt: input.image_alt || null,
      reviewed_at: input.reviewed_at || null, status, created_by: userId,
    };
  }
  if (resource === "faqs") return { question: input.question, answer: input.answer, article_id: input.article_id || null, scholarship_id: input.scholarship_id || null, display_order: input.display_order, status, is_active: status === "published" };
  if (resource === "categories") return { name: input.name, slug: input.slug, type: input.type, description: input.description || null, is_active: input.is_active };
  return { key: input.key, value: input.value, is_public: input.is_public, updated_by: userId };
}

export async function GET(request: NextRequest) {
  const kind = resourceSchema.safeParse(request.nextUrl.searchParams.get("kind"));
  if (!kind.success) return apiError("INVALID_RESOURCE", "Jenis konten tidak dikenali.", 400);
  try {
    await requireAdmin();
    const supabase = await createSupabaseServerClient();
    const result = await supabase.from(kind.data).select("*").order(kind.data === "site_settings" ? "key" : "created_at", { ascending: false }).limit(250);
    if (result.error) return apiError("CONTENT_UNAVAILABLE", "Data belum dapat dimuat. Periksa migrasi CMS dan koneksi.", 503);
    let items: Record<string, unknown>[] = (result.data ?? []) as Record<string, unknown>[];
    if (kind.data === "articles" && items.length) {
      const ids = items.map((item) => item.id).filter((id): id is string => typeof id === "string");
      const { data: sources, error: sourceError } = await supabase.from("article_sources").select("article_id,title,url").in("article_id", ids).order("created_at");
      if (sourceError) return apiError("CONTENT_UNAVAILABLE", "Daftar sumber belum dapat dimuat.", 503);
      items = items.map((item) => ({
        ...item,
        sources_text: (sources ?? []).filter((source) => source.article_id === item.id).map((source) => `${source.title} | ${source.url}`).join("\n"),
      }));
    }
    return apiSuccess({ items });
  } catch (error) {
    return errorFrom(error) ?? apiError("CONTENT_UNAVAILABLE", "Data belum dapat dimuat.", 503);
  }
}

export async function POST(request: NextRequest) {
  if (!isSameOriginRequest(request)) return apiError("ORIGIN_DENIED", "Permintaan tidak dapat diproses.", 403);
  const kind = resourceSchema.safeParse(request.nextUrl.searchParams.get("kind"));
  if (!kind.success) return apiError("INVALID_RESOURCE", "Jenis konten tidak dikenali.", 400);
  const body = await readJsonBody(request, 60_000);
  if (!body.ok) return apiError(body.reason === "too_large" ? "PAYLOAD_TOO_LARGE" : "INVALID_REQUEST", "Isi permintaan belum valid.", body.reason === "too_large" ? 413 : 400);
  const parsed = schemas[kind.data].safeParse(body.value);
  if (!parsed.success) return apiError("INVALID_CONTENT", "Periksa kembali isian wajib dan format tautan.", 400);
  const input = parsed.data as unknown as Record<string, unknown>;
  if (kind.data === "faqs" && input.article_id && input.scholarship_id) return apiError("INVALID_CONTENT", "FAQ hanya dapat ditautkan ke satu konten.", 400);
  try {
    const admin = await requireAdmin();
    const supabase = await createSupabaseServerClient();
    if (kind.data === "site_settings") {
      const key = input.key;
      const value = input.value;
      if (key === "whatsapp_official_number" && typeof value === "string" && value && !/^62[1-9][0-9]{7,12}$/.test(value)) {
        return apiError("INVALID_PHONE", "Masukkan nomor Indonesia dengan format 62 diikuti nomor tanpa tanda plus atau nol awal.", 400);
      }
      const result = await supabase.from("site_settings").upsert(rowForWrite(kind.data, input, admin.userId) as never, { onConflict: "key" }).select().single();
      if (result.error) return apiError("SAVE_FAILED", "Pengaturan belum dapat disimpan.", 400);
      return apiSuccess({ item: result.data }, 201);
    }
    const result = await supabase.from(kind.data).insert(rowForWrite(kind.data, input, admin.userId) as never).select().single();
    if (result.error) return apiError("SAVE_FAILED", "Konten belum dapat disimpan. Periksa slug, kategori, dan migrasi CMS.", 400);
    if (kind.data === "articles") {
      const row = result.data as { id: string };
      const sources = parseSourceEntries(input.sources_text);
      if (sources.length) {
        const source = await supabase.from("article_sources").insert(sources.map((item) => ({ article_id: row.id, ...item, reviewed_at: typeof input.reviewed_at === "string" && input.reviewed_at ? input.reviewed_at : null })));
        if (source.error) {
          await supabase.from("articles").delete().eq("id", row.id);
          return apiError("SOURCE_SAVE_FAILED", "Artikel belum tersimpan karena sumber rujukan gagal disimpan.", 500);
        }
      }
    }
    return apiSuccess({ item: result.data }, 201);
  } catch (error) {
    return errorFrom(error) ?? apiError("SAVE_FAILED", "Konten belum dapat disimpan.", 503);
  }
}

export async function PATCH(request: NextRequest) {
  if (!isSameOriginRequest(request)) return apiError("ORIGIN_DENIED", "Permintaan tidak dapat diproses.", 403);
  const kind = resourceSchema.safeParse(request.nextUrl.searchParams.get("kind"));
  const id = request.nextUrl.searchParams.get("id");
  if (!kind.success || !id || id.length > 100) return apiError("INVALID_RESOURCE", "Konten tidak dikenali.", 400);
  const body = await readJsonBody(request, 60_000);
  if (!body.ok) return apiError("INVALID_REQUEST", "Isi permintaan belum valid.", 400);
  const parsed = schemas[kind.data].safeParse(body.value);
  if (!parsed.success) return apiError("INVALID_CONTENT", "Periksa kembali isian wajib dan format tautan.", 400);
  const input = parsed.data as unknown as Record<string, unknown>;
  if (kind.data === "faqs" && input.article_id && input.scholarship_id) return apiError("INVALID_CONTENT", "FAQ hanya dapat ditautkan ke satu konten.", 400);
  try {
    const admin = await requireAdmin();
    const supabase = await createSupabaseServerClient();
    if (kind.data === "site_settings") {
      const key = input.key;
      const value = input.value;
      if (key === "whatsapp_official_number" && typeof value === "string" && value && !/^62[1-9][0-9]{7,12}$/.test(value)) return apiError("INVALID_PHONE", "Format nomor WhatsApp belum benar.", 400);
      const result = await supabase.from("site_settings").upsert(rowForWrite(kind.data, input, admin.userId) as never, { onConflict: "key" }).select().single();
      if (result.error) return apiError("SAVE_FAILED", "Pengaturan belum dapat disimpan.", 400);
      return apiSuccess({ item: result.data });
    }
    const result = await supabase.from(kind.data).update(rowForWrite(kind.data, input, admin.userId) as never).eq("id", id).select().single();
    if (result.error) return apiError("SAVE_FAILED", "Perubahan belum dapat disimpan.", 400);
    if (kind.data === "articles") {
      const { data: previousSources, error: previousSourcesError } = await supabase.from("article_sources").select("id").eq("article_id", id);
      if (previousSourcesError) return apiError("SOURCE_SAVE_FAILED", "Daftar sumber lama belum dapat diperiksa.", 500);
      const sources = parseSourceEntries(input.sources_text);
      if (sources.length) {
        const source = await supabase.from("article_sources").insert(sources.map((item) => ({ article_id: id, ...item, reviewed_at: typeof input.reviewed_at === "string" && input.reviewed_at ? input.reviewed_at : null })));
        if (source.error) return apiError("SOURCE_SAVE_FAILED", "Perubahan sumber gagal disimpan; sumber sebelumnya tetap dipertahankan.", 500);
      }
      const previousIds = (previousSources ?? []).map((source) => source.id);
      if (previousIds.length) {
        const removed = await supabase.from("article_sources").delete().in("id", previousIds);
        if (removed.error) return apiError("SOURCE_SAVE_FAILED", "Artikel dan sumber baru tersimpan, tetapi sumber lama belum dapat dibersihkan.", 500);
      }
    }
    return apiSuccess({ item: result.data });
  } catch (error) {
    return errorFrom(error) ?? apiError("SAVE_FAILED", "Perubahan belum dapat disimpan.", 503);
  }
}


