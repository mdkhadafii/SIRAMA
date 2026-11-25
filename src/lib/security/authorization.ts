import "server-only";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export class AuthorizationError extends Error {
  constructor(message: string, readonly status: 401 | 403 = 403) { super(message); this.name = "AuthorizationError"; }
}

export type AuthenticatedAdmin = { userId: string; displayName: string; role: "admin" };

export async function getAuthenticatedAdmin(): Promise<AuthenticatedAdmin | null> {
  try {
    const supabase = await createSupabaseServerClient();
    const { data, error } = await supabase.auth.getClaims();
    const userId = data?.claims?.sub;
    if (error || typeof userId !== "string") return null;
    const { data: profile, error: profileError } = await supabase.from("profiles").select("id, display_name, role").eq("id", userId).maybeSingle();
    if (profileError || !profile || profile.role !== "admin") return null;
    return { userId: profile.id, displayName: profile.display_name, role: "admin" };
  } catch {
    return null;
  }
}

export async function requireAdmin() {
  const profile = await getAuthenticatedAdmin();
  if (!profile) throw new AuthorizationError("Sesi admin diperlukan.", 401);
  return profile;
}
