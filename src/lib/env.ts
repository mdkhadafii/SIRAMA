import "server-only";
import { z } from "zod";

const emptyToUndefined = (value: unknown) => value === "" || value === undefined ? undefined : value;
const optionalText = z.preprocess(emptyToUndefined, z.string().optional());
const optionalUrl = z.preprocess(emptyToUndefined, z.string().url().optional());

const serverEnvSchema = z.object({
  NEXT_PUBLIC_SITE_URL: optionalUrl,
  NEXT_PUBLIC_SUPABASE_URL: optionalUrl,
  NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY: optionalText,
  SUPABASE_SECRET_KEY: optionalText,
  WHATSAPP_OFFICIAL_NUMBER: z.preprocess(emptyToUndefined, z.string().regex(/^62[1-9][0-9]{7,12}$/, "Nomor WhatsApp harus berupa nomor Indonesia internasional tanpa tanda plus.").optional()),
}).superRefine((environment, context) => {
  if (Boolean(environment.NEXT_PUBLIC_SUPABASE_URL) !== Boolean(environment.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY)) {
    context.addIssue({ code: "custom", message: "URL dan publishable key Supabase harus diisi bersama.", path: ["NEXT_PUBLIC_SUPABASE_URL"] });
  }
  if (environment.SUPABASE_SECRET_KEY && (!environment.NEXT_PUBLIC_SUPABASE_URL || !environment.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY)) {
    context.addIssue({ code: "custom", message: "Secret Supabase hanya boleh digunakan bersama konfigurasi proyek Supabase.", path: ["SUPABASE_SECRET_KEY"] });
  }
});

export type ServerEnv = z.infer<typeof serverEnvSchema>;
export function getServerEnv(): ServerEnv {
  const result = serverEnvSchema.safeParse(process.env);
  if (!result.success) {
    const variables = [...new Set(result.error.issues.map((issue) => issue.path.join(".") || "environment"))];
    throw new Error(`Konfigurasi environment tidak valid. Periksa: ${variables.join(", ")}`);
  }
  return result.data;
}
