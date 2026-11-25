import "server-only";
import { createHmac } from "node:crypto";
import { isIP } from "node:net";
import { getServerEnv } from "@/lib/env";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";

export type RateLimitScope = "auth";

export class RateLimitUnavailableError extends Error {
  constructor() {
    super("Pembatasan laju tidak tersedia.");
    this.name = "RateLimitUnavailableError";
  }
}

function getTrustedClientAddress(headers: Headers) {
  if (process.env.NODE_ENV !== "production") return "local-development";
  if (process.env.VERCEL !== "1") throw new RateLimitUnavailableError();

  const forwarded =
    headers.get("x-vercel-forwarded-for") ?? headers.get("x-forwarded-for");
  const address = forwarded?.split(",", 1)[0]?.trim();
  if (!address || isIP(address) === 0) throw new RateLimitUnavailableError();
  return address;
}

export async function consumeRateLimit(
  scope: RateLimitScope,
  headers: Headers,
) {
  let env;
  try {
    env = getServerEnv();
  } catch {
    throw new RateLimitUnavailableError();
  }

  if (!env.SUPABASE_SECRET_KEY) throw new RateLimitUnavailableError();

  const address = getTrustedClientAddress(headers);
  // Hash the trusted request scope before it reaches the rate-limit table.
  const keyHash = createHmac("sha256", env.SUPABASE_SECRET_KEY)
    .update(`sirama:rate-limit:v1:${scope}:${address}`)
    .digest("hex");

  let result;
  try {
    const supabase = createSupabaseAdminClient();
    result = await supabase.rpc("consume_auth_rate_limit", {
      p_scope: scope,
      p_key_hash: keyHash,
    });
  } catch {
    throw new RateLimitUnavailableError();
  }

  if (result.error) throw new RateLimitUnavailableError();

  const row = Array.isArray(result.data) ? result.data[0] : result.data;
  if (
    !row ||
    typeof row.allowed !== "boolean" ||
    typeof row.retry_after_seconds !== "number"
  ) {
    throw new RateLimitUnavailableError();
  }

  return {
    allowed: row.allowed,
    retryAfterSeconds: Math.max(0, row.retry_after_seconds),
  };
}
