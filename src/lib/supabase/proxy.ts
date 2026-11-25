import "server-only";
import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";
import { getServerEnv } from "@/lib/env";

export async function refreshSupabaseSession(request: NextRequest) {
  const env = getServerEnv();
  if (!env.NEXT_PUBLIC_SUPABASE_URL || !env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY) {
    return NextResponse.next({ request });
  }

  let response = NextResponse.next({ request });
  const outgoingCookies: Array<{
    name: string;
    value: string;
    options?: Parameters<typeof response.cookies.set>[2];
  }> = [];

  const supabase = createServerClient(
    env.NEXT_PUBLIC_SUPABASE_URL,
    env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach((cookie) => {
            request.cookies.set(cookie.name, cookie.value);
            outgoingCookies.push(cookie);
          });

          const preservedHeaders = ["cache-control", "expires", "pragma"].map(
            (name) => [name, response.headers.get(name)] as const,
          );
          response = NextResponse.next({ request });
          outgoingCookies.forEach(({ name, value, options }) => {
            response.cookies.set(name, value, options);
          });
          preservedHeaders.forEach(([name, value]) => {
            if (value) response.headers.set(name, value);
          });
        },
      },
    },
  );

  await supabase.auth.getClaims();
  return response;
}
