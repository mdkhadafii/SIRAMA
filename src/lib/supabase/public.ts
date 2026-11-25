import "server-only";
import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import { getServerEnv } from "@/lib/env";

const publicCacheSeconds = 30;
const publicRequestTimeoutMs = 1_500;
let publicClient: SupabaseClient | null = null;

const cachedPublicFetch: typeof fetch = (input, init) => {
  const url = input instanceof Request ? input.url : input.toString();
  const method = (init?.method ?? (input instanceof Request ? input.method : "GET")).toUpperCase();
  if (!url.includes("/rest/v1/") || method !== "GET") return fetch(input, init);

  const requestSignal = init?.signal ?? (input instanceof Request ? input.signal : undefined);
  const timeoutSignal = AbortSignal.timeout(publicRequestTimeoutMs);
  const signal = requestSignal ? AbortSignal.any([requestSignal, timeoutSignal]) : timeoutSignal;
  const cachedOptions = {
    ...init,
    signal,
    next: { revalidate: publicCacheSeconds },
  } as RequestInit & { next: { revalidate: number } };

  return fetch(input, cachedOptions);
};

/** Stateless anon-key client for information already made public by RLS. */
export function createPublicSupabaseClient() {
  const env = getServerEnv();
  if (!env.NEXT_PUBLIC_SUPABASE_URL || !env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY) {
    throw new Error("Konfigurasi Supabase publik belum tersedia.");
  }

  if (!publicClient) {
    publicClient = createClient(env.NEXT_PUBLIC_SUPABASE_URL, env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY, {
      auth: { autoRefreshToken: false, persistSession: false, detectSessionInUrl: false },
      global: { fetch: cachedPublicFetch },
    });
  }

  return publicClient;
}
