import { MessageCircle } from "lucide-react";
import { getOfficialWhatsAppNumber, whatsappMessage } from "@/lib/whatsapp";

export async function WhatsAppAction({
  kind,
  label,
}: {
  kind: "health" | "mental" | "safety";
  label?: string;
}) {
  const number = await getOfficialWhatsAppNumber();
  if (!number) {
    return (
      <p className="mt-4 border-l-2 border-border pl-4 text-sm leading-6 text-muted-foreground">
        Kanal WhatsApp SIRAMA belum tersedia. Kamu tetap dapat mengakses bantuan resmi yang tercantum di halaman ini.
      </p>
    );
  }
  const copy = whatsappMessage[kind];
  return (
    <a
      href={`https://wa.me/${number}?text=${encodeURIComponent(copy)}`}
      target="_blank"
      rel="noopener noreferrer"
      className="mt-4 inline-flex min-h-12 items-center gap-2 bg-primary px-5 py-3 text-sm font-semibold text-white no-underline hover:bg-[#0b625c] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent"
    >
      <MessageCircle className="size-4" aria-hidden="true" />
      {label ?? "Konsultasi via WhatsApp"}
      <span className="sr-only">Pesan dapat diperiksa sebelum dikirim</span>
    </a>
  );
}

