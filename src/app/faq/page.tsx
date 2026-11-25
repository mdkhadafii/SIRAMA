import type { Metadata } from "next";
import { Suspense } from "react";
import { globalFaqs } from "@/features/content/catalog";
import { getPublishedFaqs, isCmsConfigured } from "@/features/content/published-content";

export const metadata: Metadata = { title: "Pertanyaan umum", description: "Jawaban tentang informasi, privasi, WhatsApp, dan jalur bantuan SIRAMA." };
export const dynamic = "force-dynamic";
export default function Page() {
  return <Suspense fallback={<FaqContent items={globalFaqs} />}><PublishedFaqContent /></Suspense>;
}

async function PublishedFaqContent() {
  const [managed, cmsReady] = await Promise.all([getPublishedFaqs(), isCmsConfigured()]);
  const items = cmsReady ? managed.map((item) => ({ question: item.question, answer: item.answer })) : globalFaqs;
  return <FaqContent items={items} />;
}

function FaqContent({ items }: { items: { question: string; answer: string }[] }) {
  return <main id="konten-utama" className="page-gutter py-12 sm:py-16"><div className="max-w-4xl"><header className="border-b border-border pb-7"><p className="eyebrow">Pertanyaan umum</p><h1 className="mt-3 page-title font-semibold">Jawaban yang kamu cari.</h1><p className="mt-4 max-w-2xl text-lg leading-8 text-secondary">Pertanyaan khusus tentang menstruasi, kesehatan mental, beasiswa, dan keselamatan juga tersedia di halaman topik terkait.</p></header><div className="mt-4 divide-y divide-border border-b border-border">{items.map((item) => <details key={item.question}><summary className="flex min-h-14 cursor-pointer list-none items-center justify-between gap-4 py-4 text-left text-base font-semibold marker:hidden [&::-webkit-details-marker]:hidden">{item.question}<span className="text-xl text-primary" aria-hidden="true">+</span></summary><p className="max-w-3xl pb-5 pr-8 text-base leading-7 text-secondary">{item.answer}</p></details>)}</div></div></main>;
}
