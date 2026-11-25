import { NextRequest } from "next/server";
import { apiError, apiSuccess, isSameOriginRequest } from "@/lib/security/http";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export const runtime = "nodejs";

export async function POST(request: NextRequest) {
  if (!isSameOriginRequest(request)) {
    return apiError("ORIGIN_DENIED", "Permintaan tidak dapat diproses.", 403);
  }

  try {
    const supabase = await createSupabaseServerClient();
    const { error } = await supabase.auth.signOut();
    if (error) return apiError("LOGOUT_FAILED", "Sesi belum dapat diakhiri.", 503);
    return apiSuccess({ signedOut: true });
  } catch {
    return apiError("LOGOUT_FAILED", "Sesi belum dapat diakhiri.", 503);
  }
}
