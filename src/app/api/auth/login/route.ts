import { NextRequest } from "next/server";
import { loginRequestSchema } from "@/features/forms/schemas";
import { consumeRateLimit, RateLimitUnavailableError } from "@/lib/security/rate-limit";
import { apiError, apiSuccess, isSameOriginRequest } from "@/lib/security/http";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export const runtime = "nodejs";

export async function POST(request: NextRequest) {
  if (!isSameOriginRequest(request)) return apiError("ORIGIN_DENIED", "Permintaan tidak dapat diproses.", 403);
  try {
    const limit = await consumeRateLimit("auth", request.headers);
    if (!limit.allowed) return apiError("RATE_LIMITED", "Terlalu banyak percobaan. Tunggu sebelum mencoba kembali.", 429, limit.retryAfterSeconds);
  } catch (error) {
    if (error instanceof RateLimitUnavailableError) return apiError("RATE_LIMIT_UNAVAILABLE", "Login admin belum dapat diverifikasi.", 503);
    return apiError("RATE_LIMIT_UNAVAILABLE", "Login admin belum dapat diverifikasi.", 503);
  }
  const length = Number(request.headers.get("content-length") ?? 0);
  if (length > 4096) return apiError("PAYLOAD_TOO_LARGE", "Permintaan terlalu besar.", 413);
  let input: unknown;
  try { const body = await request.text(); if (body.length > 4096) return apiError("PAYLOAD_TOO_LARGE", "Permintaan terlalu besar.", 413); input = JSON.parse(body); }
  catch { return apiError("INVALID_REQUEST", "Format permintaan tidak valid.", 400); }
  const parsed = loginRequestSchema.safeParse(input);
  if (!parsed.success) return apiError("INVALID_REQUEST", "Email atau kata sandi belum valid.", 400);
  try {
    const supabase = await createSupabaseServerClient();
    const { data, error } = await supabase.auth.signInWithPassword({ email: parsed.data.email, password: parsed.data.password });
    if (error || !data.user) return apiError("LOGIN_FAILED", "Email atau kata sandi tidak sesuai.", 401);
    const { data: claims, error: claimsError } = await supabase.auth.getClaims();
    const userId = claims?.claims?.sub;
    if (claimsError || typeof userId !== "string" || userId !== data.user.id) { await supabase.auth.signOut(); return apiError("LOGIN_FAILED", "Sesi belum dapat diverifikasi.", 401); }
    const { data: profile, error: profileError } = await supabase.from("profiles").select("role").eq("id", userId).maybeSingle();
    if (profileError || profile?.role !== "admin") { await supabase.auth.signOut(); return apiError("LOGIN_FAILED", "Akun ini tidak memiliki akses pengelola.", 403); }
    const requested = parsed.data.next;
    const redirectTo = requested?.startsWith("/admin/") && !requested.startsWith("/admin/login") ? requested : "/admin";
    return apiSuccess({ redirectTo });
  } catch {
    return apiError("AUTH_UNAVAILABLE", "Login belum dapat diproses.", 503);
  }
}
