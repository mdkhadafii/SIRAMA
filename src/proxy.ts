import { NextResponse, type NextRequest } from "next/server";
import { refreshSupabaseSession } from "@/lib/supabase/proxy";

export async function proxy(request: NextRequest) {
  try {
    return await refreshSupabaseSession(request);
  } catch {
    return NextResponse.json({ error: { code: "AUTH_UNAVAILABLE", message: "Sesi belum dapat diverifikasi." } }, { status: 503, headers: { "Cache-Control": "no-store" } });
  }
}

export const config = { matcher: ["/admin/:path*", "/api/admin/:path*"] };
