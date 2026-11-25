import { NextResponse } from "next/server";
import { AuthorizationError } from "@/lib/security/authorization";

const secureHeaders = {
  "Cache-Control": "no-store, max-age=0",
  "Referrer-Policy": "no-referrer",
  "X-Content-Type-Options": "nosniff",
};

export function isSameOriginRequest(request: Request) {
  const origin = request.headers.get("origin");
  if (!origin) return false;

  try {
    if (new URL(origin).origin !== new URL(request.url).origin) return false;
  } catch {
    return false;
  }

  const fetchSite = request.headers.get("sec-fetch-site");
  return !fetchSite || fetchSite === "same-origin" || fetchSite === "none";
}

export async function readJsonBody(request: Request, maxBytes: number) {
  const reader = request.body?.getReader();
  if (!reader) return { ok: false as const, reason: "invalid" as const };

  const chunks: Uint8Array[] = [];
  let totalBytes = 0;

  try {
    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      totalBytes += value.byteLength;
      if (totalBytes > maxBytes) {
        await reader.cancel().catch(() => undefined);
        return { ok: false as const, reason: "too_large" as const };
      }
      chunks.push(value);
    }

    const body = new Uint8Array(totalBytes);
    let offset = 0;
    for (const chunk of chunks) {
      body.set(chunk, offset);
      offset += chunk.byteLength;
    }

    const text = new TextDecoder("utf-8", { fatal: true }).decode(body);
    return { ok: true as const, value: JSON.parse(text) as unknown };
  } catch {
    return { ok: false as const, reason: "invalid" as const };
  } finally {
    reader.releaseLock();
  }
}

export function apiSuccess<T>(data: T, status = 200) {
  return NextResponse.json({ data }, { status, headers: secureHeaders });
}

export function apiError(
  code: string,
  message: string,
  status: number,
  retryAfterSeconds?: number,
) {
  const headers = new Headers(secureHeaders);
  if (retryAfterSeconds && retryAfterSeconds > 0) {
    headers.set("Retry-After", String(retryAfterSeconds));
  }

  return NextResponse.json(
    { error: { code, message } },
    { status, headers },
  );
}

export function authorizationErrorResponse(error: unknown) {
  if (error instanceof AuthorizationError) {
    return apiError(
      error.status === 401 ? "AUTH_REQUIRED" : "FORBIDDEN",
      error.message,
      error.status,
    );
  }

  return apiError("INTERNAL_ERROR", "Permintaan belum dapat diproses.", 500);
}
