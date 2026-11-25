import type { Metadata } from "next";
import Link from "next/link";
import { Suspense } from "react";
import { educationArticles, scholarships } from "@/features/content/catalog";
import { getPublishedScholarships, isCmsConfigured } from "@/features/content/published-content";
import { getScholarshipPeriodText } from "@/features/content/scholarship-period";

export const metadata: Metadata = { title: "Pendidikan dan beasiswa", description: "Informasi pendidikan, peluang beasiswa resmi, dan pengembangan diri remaja." };
export const dynamic = "force-dynamic";

type EducationProgram = { slug: string; title: string; provider: string; summary: string; period: string };
type EducationGuide = { slug: string; title: string; summary: string };

function getLocalPrograms(): EducationProgram[] {
  return scholarships.map((item) => ({
    slug: item.slug,
    title: item.title,
    provider: item.provider,
    summary: item.summary,
    period: getScholarshipPeriodText(item),
  }));
}
const localGuides: EducationGuide[] = educationArticles.map(({ slug, title, summary }) => ({ slug, title, summary }));

export default function Page() {
  return <Suspense fallback={<EducationContent programs={getLocalPrograms()} guides={localGuides} />}><PublishedEducationContent /></Suspense>;
}

async function PublishedEducationContent() {
  const [managed, cmsReady] = await Promise.all([getPublishedScholarships(), isCmsConfigured()]);
  const programs = cmsReady
    ? managed.map((item) => ({ slug: item.slug, title: item.title, provider: item.provider, summary: item.description, period: getScholarshipPeriodText(item) }))
    : getLocalPrograms();
  return <EducationContent programs={programs} guides={cmsReady ? [] : localGuides} />;
}

function EducationContent({ programs, guides }: { programs: EducationProgram[]; guides: EducationGuide[] }) {
  return (
    <main id="konten-utama">
      <header className="page-gutter editorial-heading py-12 sm:py-16">
        <p className="eyebrow">Pendidikan dan masa depan</p>
        <h1 className="mt-4 max-w-4xl page-title font-semibold">Pilih langkah yang sesuai dengan minat dan kebutuhanmu.</h1>
        <p className="mt-5 max-w-2xl text-lg leading-8 text-secondary">Informasi program selalu ditautkan ke penyelenggara. Periksa kembali syarat dan jadwal terbaru sebelum mendaftar.</p>
      </header>
      <section className="bg-surface py-10 sm:py-14">
        <div className="page-gutter">
          <h2 className="border-b border-border pb-4 text-2xl font-semibold">Program pendidikan dan beasiswa</h2>
          <div className="mt-5 grid gap-8">
            {programs.map((item) => (
              <article key={item.slug} className="grid gap-5 border-b border-border pb-7 sm:grid-cols-[minmax(0,1fr)_minmax(15rem,0.55fr)]">
                <div><p className="eyebrow">{item.provider}</p><h3 className="mt-3 text-2xl font-semibold"><Link href={`/pendidikan/${item.slug}`} className="underline decoration-border underline-offset-4 hover:text-primary">{item.title}</Link></h3><p className="mt-3 max-w-2xl text-base leading-7 text-secondary">{item.summary}</p><Link href={`/pendidikan/${item.slug}`} className="mt-3 inline-flex min-h-11 items-center font-semibold text-primary underline underline-offset-4">Baca persyaratan dan panduan</Link></div>
                <p className="h-fit border-l-2 border-[#c06f4f] bg-background p-4 text-sm leading-6 text-secondary">{item.period}</p>
              </article>
            ))}
          </div>
          {programs.length === 0 ? <p className="mt-6 text-base leading-7 text-secondary">Belum ada program terbit. Periksa informasi langsung pada situs resmi penyelenggara.</p> : null}
        </div>
      </section>
      {guides.length ? <section className="page-gutter py-11 sm:py-14"><div className="grid gap-6 sm:grid-cols-[0.7fr_1.3fr]"><div><p className="eyebrow">Panduan belajar</p><h2 className="mt-2 text-2xl font-semibold">Kembangkan rencana dan keterampilan.</h2></div><ul className="divide-y divide-border border-y border-border">{guides.map((item) => <li key={item.slug}><Link href={`/edukasi/${item.slug}`} className="flex min-h-14 items-center justify-between gap-4 py-3 text-base font-semibold underline decoration-border underline-offset-4 hover:text-primary">{item.title}<span className="text-primary">Baca</span></Link><p className="pb-4 text-sm leading-6 text-secondary">{item.summary}</p></li>)}</ul></div></section> : null}
    </main>
  );
}
