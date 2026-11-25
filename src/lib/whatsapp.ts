import "server-only";
import { getServerEnv } from "@/lib/env";
import { createPublicSupabaseClient } from "@/lib/supabase/public";

export const whatsappMessage = {
  health: "Halo, saya ingin mendapatkan informasi dan berkonsultasi mengenai kesehatan remaja melalui SIRAMA.",
  mental: "Halo, saya ingin berkonsultasi mengenai permasalahan yang sedang saya hadapi.",
  safety: "Halo, saya membutuhkan bantuan terkait kekerasan atau perundungan.",
} as const;

const validIndonesianNumber = (value: unknown): value is string =>
  typeof value === "string" && /^62[1-9][0-9]{7,12}$/.test(value);

export async function getOfficialWhatsAppNumber() {
  let value: unknown;
  try {
    value = getServerEnv().WHATSAPP_OFFICIAL_NUMBER;
  } catch {
    return null;
  }
  if (!value) {
    try {
      const supabase = createPublicSupabaseClient();
      const { data } = await supabase.from("site_settings").select("value").eq("key", "whatsapp_official_number").eq("is_public", true).maybeSingle();
      value = data?.value;
    } catch {
      return null;
    }
  }
  const number = typeof value === "string" ? value : null;
  return validIndonesianNumber(number) ? number : null;
}

