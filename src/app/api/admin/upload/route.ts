import { randomUUID } from "node:crypto";
import { NextRequest } from "next/server";
import { apiError, apiSuccess, authorizationErrorResponse, isSameOriginRequest } from "@/lib/security/http";
import { requireAdmin } from "@/lib/security/authorization";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export const runtime = "nodejs";
const allowedTypes = new Set(["image/jpeg", "image/png", "image/webp"]);
const extensions: Record<string, string> = { "image/jpeg": "jpg", "image/png": "png", "image/webp": "webp" };

export async function POST(request: NextRequest) {
  if (!isSameOriginRequest(request)) return apiError("ORIGIN_DENIED", "Permintaan tidak dapat diproses.", 403);
  try {
    await requireAdmin();
    const form = await request.formData();
    const entry = form.get("file");
    if (!(entry instanceof File) || !allowedTypes.has(entry.type) || entry.size < 1 || entry.size > 5 * 1024 * 1024) return apiError("INVALID_FILE", "Pilih gambar PNG, JPEG, atau WebP hingga 5 MB.", 400);
    const buffer = Buffer.from(await entry.arrayBuffer());
    const signatureMatches = entry.type === "image/jpeg" ? buffer[0] === 0xff && buffer[1] === 0xd8
      : entry.type === "image/png" ? buffer.subarray(0, 8).equals(Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]))
      : buffer.subarray(0, 4).toString("ascii") === "RIFF" && buffer.subarray(8, 12).toString("ascii") === "WEBP";
    if (!signatureMatches) return apiError("INVALID_FILE", "Format file tidak cocok dengan isi gambar.", 400);
    const supabase = await createSupabaseServerClient();
    const path = "content/" + randomUUID() + "." + extensions[entry.type];
    const result = await supabase.storage.from("sirama-content").upload(path, buffer, { contentType: entry.type, cacheControl: "3600", upsert: false });
    if (result.error) return apiError("UPLOAD_FAILED", "Gambar belum dapat disimpan. Pastikan penyimpanan konten sudah disiapkan.", 503);
    const { data } = supabase.storage.from("sirama-content").getPublicUrl(path);
    return apiSuccess({ url: data.publicUrl }, 201);
  } catch (error) {
    if (error instanceof Error && error.name === "AuthorizationError") return authorizationErrorResponse(error);
    return apiError("UPLOAD_FAILED", "Gambar belum dapat diunggah.", 503);
  }
}
