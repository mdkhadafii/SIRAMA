import Link from "next/link";
import Image from "next/image";
import { BookOpenText, Clock3 } from "lucide-react";
import type { Reference, Topic } from "@/features/content/catalog";
import { WhatsAppAction } from "@/features/content/whatsapp";
import type { PublishedArticle } from "@/features/content/published-content";
import { getPublishedArticleSources, getPublishedFaqs } from "@/features/content/published-content";

function TopicIndex({
  title,
  intro,
  topics,
  articles = [],
  tone = "health",
}: {
  title: string;
  intro: string;
  topics: Topic[];
  articles?: PublishedArticle[];
  tone?: "health" | "mental" | "safety";
}) {
  const accent = tone === "safety" ? "border-t-[#a4513f]" : tone === "mental" ? "border-t-[#416e80]" : "border-t-primary";
  return (
    <main id="konten-utama">
      <header className="page-gutter editorial-heading py-12 sm:py-16">
        <p className="eyebrow">Pusat informasi</p>
        <h1 className="mt-4 max-w-4xl page-title font-semibold">{title}</h1>
        <p className="mt-5 max-w-2xl text-lg leading-8 text-secondary">{intro}</p>
      </header>
      <section className="bg-surface py-10 sm:py-14" aria-labelledby="topic-list-title">
        <div className="page-gutter">
          <div className="mb-6 flex items-end justify-between gap-4 border-b border-border pb-4">
            <div>
              <p className="eyebrow">Baca sesuai kebutuhanmu</p>
              <h2 id="topic-list-title" className="mt-2 text-2xl font-semibold tracking-tight">Topik yang tersedia</h2>
            </div>
            <p className="hidden text-sm text-muted-foreground sm:block">Informasi umum, bukan diagnosis.</p>
          </div>
          <ul className="grid gap-x-8 md:grid-cols-2">
            {[...topics.map((item) => ({ slug: item.slug, title: item.title, summary: item.summary })), ...articles.map((item) => ({ slug: item.slug, title: item.title, summary: item.excerpt }))].map((item, index) => (
              <li key={item.slug} className={`border-t-[3px] ${accent} border-b border-border py-5 sm:py-6`}>
                <p className="text-sm font-semibold tabular-nums text-muted-foreground">{String(index + 1).padStart(2, "0")}</p>
                <h3 className="mt-2 text-xl font-semibold tracking-tight"><Link className="decoration-border underline-offset-4 hover:text-primary hover:underline" href={`/${tone === "health" ? "kesehatan-remaja" : tone === "mental" ? "kesehatan-mental" : "kekerasan-perundungan"}/${item.slug}`}>{item.title}</Link></h3>
                <p className="mt-2 max-w-xl text-base leading-7 text-secondary">{item.summary}</p>
                <Link className="mt-3 inline-flex min-h-11 items-center text-sm font-semibold text-primary underline underline-offset-4" href={`/${tone === "health" ? "kesehatan-remaja" : tone === "mental" ? "kesehatan-mental" : "kekerasan-perundungan"}/${item.slug}`}>Baca panduan</Link>
              </li>
            ))}
          </ul>
        </div>
      </section>
    </main>
  );
}

export function HealthIndex({ topics, articles = [] }: { topics: Topic[]; articles?: PublishedArticle[] }) {
  return <TopicIndex title="Kesehatan remaja, dengan informasi yang mudah dipahami." intro="Pelajari perubahan tubuh, kebiasaan sehat, dan langkah mencari bantuan dari sumber kesehatan tepercaya." topics={topics} articles={articles} />;
}
export function MentalIndex({ topics, articles = [] }: { topics: Topic[]; articles?: PublishedArticle[] }) {
  return <TopicIndex title="Kesehatan mental juga bagian dari kesehatan." intro="Kenali tekanan, emosi, dan hubungan dengan diri sendiri. Kamu tidak perlu menghadapi semuanya sendirian." topics={topics} articles={articles} tone="mental" />;
}
export function SafetyIndex({ topics, articles = [] }: { topics: Topic[]; articles?: PublishedArticle[] }) {
  return <TopicIndex title="Keselamatanmu penting. Kekerasan bukan salah korban." intro="Kenali bentuk perundungan dan kekerasan, rencanakan langkah yang aman, dan temukan jalur bantuan resmi." topics={topics} articles={articles} tone="safety" />;
}

function ReferenceList({ sources }: { sources: Reference[] }) {
  return (
    <section className="mt-10 border-t border-border pt-6" aria-labelledby="sources-heading">
      <h2 id="sources-heading" className="text-lg font-semibold">Sumber tepercaya</h2>
      <ul className="mt-3 grid gap-2">
        {sources.map((source) => <li key={source.url}><a className="inline-flex min-h-11 items-center gap-2 text-base font-medium text-primary underline underline-offset-4" href={source.url} target="_blank" rel="noopener noreferrer">{source.title}<span className="sr-only"> (membuka situs lain)</span></a></li>)}
      </ul>
      <p className="mt-4 text-sm text-muted-foreground">Rujukan diperiksa {sources.length ? "25 November 2026" : ""}. Periksa sumber asli untuk informasi terbaru.</p>
    </section>
  );
}

export function TopicDetail({ topic: item, kind }: { topic: Topic; kind: "health" | "mental" | "safety" }) {
  const backHref = kind === "health" ? "/kesehatan-remaja" : kind === "mental" ? "/kesehatan-mental" : "/kekerasan-perundungan";
  const label = kind === "safety" ? "Hubungi Petugas" : kind === "mental" ? "Bicara dengan Petugas" : "Konsultasi via WhatsApp";
  return (
    <main id="konten-utama" className="page-gutter py-9 sm:py-14">
      <Link href={backHref} className="inline-flex min-h-11 items-center text-sm font-semibold text-primary underline underline-offset-4">Kembali ke daftar topik</Link>
      <div className="mt-7 grid gap-10 lg:grid-cols-[minmax(0,46rem)_minmax(15rem,1fr)] lg:gap-16">
        <article className="content-reading">
          <p className="eyebrow">Panduan informasi</p>
          <h1 className="mt-3 article-title font-semibold">{item.title}</h1>
          <p className="mt-5 text-lg leading-8 text-secondary">{item.summary}</p>
          <div className="mt-5 flex items-center gap-2 text-sm text-muted-foreground"><Clock3 className="size-4" aria-hidden="true" />Diperiksa {item.checkedAt}</div>
          <div className="mt-8 border-y border-border divide-y divide-border">
            {[
              ["Memahami topik", item.introduction],
              ["Faktor yang dapat berperan", item.factors.join("; ")],
              ["Hal yang dapat diperhatikan", item.signs.join("; ")],
              ["Dampak yang mungkin dirasakan", item.impact],
              ["Langkah pencegahan", item.prevention.join("; ")],
              ["Yang dapat dilakukan sekarang", item.firstSteps.join("; ")],
            ].map(([heading, body]) => <section key={heading} className="py-6"><h2 className="text-xl font-semibold tracking-tight">{heading}</h2><p className="mt-3 text-base leading-7 text-secondary">{body}</p></section>)}
            <section className="py-6"><h2 className="text-xl font-semibold tracking-tight">Kapan mencari bantuan?</h2><p className="mt-3 text-base leading-7 text-secondary">{item.seekHelp}</p></section>
          </div>
          {kind === "safety" ? <section className="notice-panel mt-8 p-5"><h2 className="text-lg font-semibold">Jika sedang dalam bahaya</h2><p className="mt-2 text-base leading-7">Menjauh ke tempat yang aman bila memungkinkan dan hubungi orang dewasa tepercaya. SAPA 129 dapat dihubungi melalui telepon 129 atau WhatsApp 08111-129-129 untuk kekerasan terhadap perempuan dan anak. Bahaya langsung: hubungi polisi 110. Jangan menghadapi pelaku sendirian.</p><a className="mt-3 inline-flex min-h-11 items-center gap-2 font-semibold text-primary underline underline-offset-4" href="https://laporsapa129.kemenpppa.go.id/" target="_blank" rel="noopener noreferrer">Informasi resmi SAPA 129</a></section> : kind === "mental" ? <section className="notice-panel mt-8 p-5"><h2 className="text-lg font-semibold">Jika kamu merasa tidak aman dengan dirimu</h2><p className="mt-2 text-base leading-7">Jangan sendirian. Hubungi orang dewasa tepercaya yang dapat menemanimu. Dukungan psikologis awal tersedia melalui Healing119.id atau telepon 119 ekstensi 8 sesuai informasi Kementerian Kesehatan. Jika dalam bahaya langsung, hubungi layanan darurat setempat; jangan menunggu WhatsApp SIRAMA.</p><a className="mt-3 inline-flex min-h-11 items-center gap-2 font-semibold text-primary underline underline-offset-4" href="https://www.healing119.id/" target="_blank" rel="noopener noreferrer">Buka Healing119.id</a></section> : null}
          <section className="mt-10" aria-labelledby="faq-title"><div className="flex items-center gap-3"><BookOpenText className="size-5 text-primary" aria-hidden="true"/><h2 id="faq-title" className="text-2xl font-semibold tracking-tight">Pertanyaan yang sering ditanyakan</h2></div><div className="mt-4 divide-y divide-border border-y border-border">{item.faqs.map((faq) => <details key={faq.question} className="group"><summary className="flex min-h-14 cursor-pointer list-none items-center justify-between gap-4 py-4 text-left text-base font-semibold marker:hidden [&::-webkit-details-marker]:hidden">{faq.question}<span aria-hidden="true" className="text-xl font-normal text-primary group-open:hidden">+</span><span aria-hidden="true" className="hidden text-xl font-normal text-primary group-open:inline">−</span></summary><p className="max-w-2xl pb-5 pr-8 text-base leading-7 text-secondary">{faq.answer}</p></details>)}</div></section>
          <ReferenceList sources={item.sources} />
        </article>
        <aside className="h-fit border-t-[3px] border-primary bg-surface p-5 sm:p-6 lg:sticky lg:top-8" aria-labelledby="next-step-title">
          <p className="eyebrow">Langkah berikutnya</p><h2 id="next-step-title" className="mt-2 text-xl font-semibold">Kamu boleh meminta bantuan.</h2><p className="mt-3 text-base leading-7 text-secondary">Pesan WhatsApp hanya berisi kalimat pembuka umum. Periksa dan ubah draf sebelum kamu mengirimkannya.</p>
          <WhatsAppAction kind={kind} label={label} />
          <p className="mt-6 border-t border-border pt-4 text-sm leading-6 text-muted-foreground">SIRAMA menyediakan informasi edukasi, bukan diagnosis atau layanan darurat.</p>
        </aside>
      </div>
    </main>
  );
}

function ArticleBody({ content }: { content: string }) {
  const blocks = content.split(/\n\s*\n/).map((block) => block.trim()).filter(Boolean);
  return <div className="mt-8 space-y-5">{blocks.map((block, index) => {
    const lines = block.split("\n");
    const first = lines[0];
    if (first.startsWith("### ")) return <h3 key={index} className="text-xl font-semibold">{first.slice(4)}</h3>;
    if (first.startsWith("## ")) return <h2 key={index} className="pt-3 text-2xl font-semibold">{first.slice(3)}</h2>;
    if (lines.every((line) => line.startsWith("- "))) return <ul key={index} className="list-disc space-y-2 pl-5 text-base leading-7 text-secondary">{lines.map((line) => <li key={line}>{line.slice(2)}</li>)}</ul>;
    return <p key={index} className="text-base leading-8 text-secondary">{block}</p>;
  })}</div>;
}

export async function PublishedArticleDetail({ article, kind }: { article: PublishedArticle; kind: "health" | "mental" | "safety" | "education" | "general" }) {
  const WhatsAppKind = kind === "safety" ? "safety" : kind === "mental" ? "mental" : "health";
  const [sources, faqs] = await Promise.all([getPublishedArticleSources(article.id), getPublishedFaqs({ articleId: article.id })]);
  return <main id="konten-utama" className="page-gutter py-9 sm:py-14"><article className="content-reading"><Link href={kind === "health" ? "/kesehatan-remaja" : kind === "mental" ? "/kesehatan-mental" : kind === "safety" ? "/kekerasan-perundungan" : "/edukasi"} className="inline-flex min-h-11 items-center text-sm font-semibold text-primary underline underline-offset-4">Kembali ke daftar</Link><p className="eyebrow mt-8">Panduan informasi</p><h1 className="mt-3 article-title font-semibold">{article.title}</h1><p className="mt-5 text-lg leading-8 text-secondary">{article.excerpt}</p>{article.thumbnail_url ? <Image src={article.thumbnail_url} alt={article.image_alt ?? ""} width={1200} height={800} sizes="(max-width: 768px) 100vw, 46rem" className="mt-6 h-auto w-full border border-border object-cover"/> : null}{kind === "mental" ? <section className="notice-panel mt-6 p-5"><h2 className="text-lg font-semibold">Jika kamu merasa tidak aman dengan dirimu</h2><p className="mt-2 text-base leading-7">Jangan sendirian. Hubungi orang dewasa tepercaya yang dapat menemanimu. Dukungan psikologis awal tersedia melalui Healing119.id atau telepon 119 ekstensi 8 sesuai informasi Kementerian Kesehatan. Jika dalam bahaya langsung, hubungi layanan darurat setempat; jangan menunggu WhatsApp SIRAMA.</p><a href="https://www.healing119.id/" target="_blank" rel="noopener noreferrer" className="mt-3 inline-flex min-h-11 items-center font-semibold text-primary underline underline-offset-4">Buka Healing119.id</a></section> : null}{kind === "safety" ? <section className="notice-panel mt-6 p-5"><h2 className="text-lg font-semibold">Jika sedang dalam bahaya</h2><p className="mt-2 text-base leading-7">Menjauh ke tempat aman bila memungkinkan dan hubungi orang dewasa tepercaya. Untuk kekerasan terhadap perempuan/anak, SAPA 129 dapat dihubungi melalui telepon 129 atau WhatsApp 08111-129-129. Bahaya langsung: hubungi polisi 110. Jangan menghadapi pelaku sendirian.</p><a href="https://laporsapa129.kemenpppa.go.id/" target="_blank" rel="noopener noreferrer" className="mt-3 inline-flex min-h-11 items-center font-semibold text-primary underline underline-offset-4">Informasi resmi SAPA 129</a></section> : null}{article.reviewed_at ? <p className="mt-4 text-sm text-muted-foreground">Diperiksa {new Intl.DateTimeFormat("id-ID", { dateStyle: "long", timeZone: "UTC" }).format(new Date(article.reviewed_at + "T00:00:00Z"))}</p> : null}<ArticleBody content={article.content}/>{sources.length || article.source_url ? <section className="mt-9 border-t border-border pt-6"><h2 className="text-lg font-semibold">Sumber rujukan</h2><ul className="mt-2 space-y-2">{sources.map((source) => <li key={source.url}><a href={source.url} target="_blank" rel="noopener noreferrer" className="inline-flex min-h-11 items-center text-base text-primary underline underline-offset-4">{source.title}</a></li>)}{!sources.length && article.source_url ? <li><a href={article.source_url} target="_blank" rel="noopener noreferrer" className="inline-flex min-h-11 items-center text-base text-primary underline underline-offset-4">Buka sumber asli</a></li> : null}</ul>{article.reviewed_at ? <p className="mt-2 text-sm text-muted-foreground">Diperiksa {article.reviewed_at}</p> : null}</section> : null}{faqs.length ? <section className="mt-9 border-t border-border pt-6"><h2 className="text-2xl font-semibold">Pertanyaan yang sering ditanyakan</h2><div className="mt-3 divide-y divide-border border-y border-border">{faqs.map((faq) => <details key={faq.id}><summary className="flex min-h-14 cursor-pointer list-none items-center justify-between gap-4 py-4 text-left text-base font-semibold">{faq.question}<span className="text-xl text-primary" aria-hidden="true">+</span></summary><p className="pb-5 text-base leading-7 text-secondary">{faq.answer}</p></details>)}</div></section> : null}{kind !== "education" && kind !== "general" ? <section className="mt-8 border-t border-border pt-6"><h2 className="text-xl font-semibold">Ingin berbicara dengan petugas?</h2><p className="mt-2 text-base leading-7 text-secondary">Draf pesan tidak memuat identitas atau rincian pribadi. Periksa sebelum mengirim.</p><WhatsAppAction kind={WhatsAppKind} label={kind === "safety" ? "Hubungi Petugas" : kind === "mental" ? "Bicara dengan Petugas" : "Konsultasi via WhatsApp"}/></section> : null}</article></main>;
}

