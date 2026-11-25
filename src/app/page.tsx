import { Suspense } from "react";
import Image from "next/image";
import Link from "next/link";
import { GraduationCap, HeartPulse, MessageCircleHeart, Shield } from "lucide-react";
import { educationArticles, globalFaqs, healthTopics, mentalTopics, scholarships } from "@/features/content/catalog";
import { WhatsAppAction } from "@/features/content/whatsapp";
import { getPublishedArticles, getPublishedFaqs, getPublishedScholarships, isCmsConfigured } from "@/features/content/published-content";
import { getScholarshipPeriodText } from "@/features/content/scholarship-period";

const services = [
  { title: "Kesehatan remaja", text: "Kenali pubertas, menstruasi, gizi, anemia, dan kesehatan reproduksi dari sumber tepercaya.", href: "/kesehatan-remaja", icon: HeartPulse, accent: "#0f766e" },
  { title: "Kesehatan mental", text: "Pahami stres, kecemasan, hubungan, emosi, dan cara mencari dukungan yang sesuai.", href: "/kesehatan-mental", icon: MessageCircleHeart, accent: "#416e80" },
  { title: "Pendidikan dan beasiswa", text: "Temukan panduan pengembangan diri dan tautan program dari penyelenggara resmi.", href: "/pendidikan", icon: GraduationCap, accent: "#a4513f" },
  { title: "Kekerasan dan perundungan", text: "Kenali bentuk kekerasan dan pilih langkah yang memprioritaskan keselamatan korban.", href: "/kekerasan-perundungan", icon: Shield, accent: "#774f72" },
];

type HomeLinkItem = { slug: string; title: string; summary: string };
type HomeScholarship = { slug: string; title: string; provider: string; summary: string; period: string; url: string };
type HomeFaq = { question: string; answer: string };
type HomeEditorialData = {
  healthItems: HomeLinkItem[];
  mentalItems: HomeLinkItem[];
  readingItems: HomeLinkItem[];
  scholarshipItems: HomeScholarship[];
  faqItems: HomeFaq[];
};

function getLocalEditorialData(): HomeEditorialData {
  return {
    healthItems: healthTopics.slice(0, 4).map(({ slug, title, summary }) => ({ slug, title, summary })),
    mentalItems: mentalTopics.slice(0, 4).map(({ slug, title, summary }) => ({ slug, title, summary })),
    readingItems: educationArticles.slice(0, 3).map(({ slug, title, summary }) => ({ slug, title, summary })),
    scholarshipItems: scholarships.map((item) => ({
      slug: item.slug,
      title: item.title,
      provider: item.provider,
      summary: item.summary,
      period: getScholarshipPeriodText(item),
      url: item.officialUrl,
    })),
    faqItems: globalFaqs,
  };
}

export const dynamic = "force-dynamic";

export default function HomePage() {
  return (
    <main id="konten-utama">
      <section className="page-gutter grid gap-9 py-9 sm:py-14 lg:grid-cols-[1.05fr_0.95fr] lg:items-center lg:gap-14 lg:py-16">
        <div className="max-w-2xl">
          <p className="eyebrow">Sistem Informasi Ramah Remaja</p>
          <h1 className="hero-title mt-4 max-w-[19ch] font-semibold">Temukan informasi, pahami dirimu, dan dapatkan bantuan yang kamu butuhkan.</h1>
          <p className="mt-5 max-w-xl text-lg leading-8 text-secondary">SIRAMA membantu remaja memahami kesehatan, kesejahteraan, pendidikan, dan langkah mencari bantuan melalui informasi yang ditulis dengan jelas.</p>
          <div className="mt-7 flex flex-col gap-3 sm:flex-row sm:items-center">
            <a className="inline-flex min-h-12 items-center justify-center bg-primary px-5 py-3 text-sm font-semibold text-white no-underline hover:bg-[#0b625c]" href="#layanan">Jelajahi layanan</a>
            <Link className="inline-flex min-h-12 items-center justify-center px-4 text-sm font-semibold text-secondary underline underline-offset-4 hover:text-primary" href="/tentang">Tentang SIRAMA</Link>
          </div>
          <p className="mt-7 border-l-2 border-[#c06f4f] pl-4 text-sm leading-6 text-muted-foreground">Informasi edukasi umum, bukan diagnosis atau pengganti tenaga profesional.</p>
        </div>
        <figure className="relative mx-auto w-full max-w-[37rem] lg:ml-auto">
          <Image src="/ilustrasi-ruang-remaja.svg" alt="Tiga remaja berbincang dan belajar bersama" width={720} height={560} priority className="w-full" />
          <figcaption className="mt-3 text-right text-sm text-muted-foreground">Ruang untuk belajar, bertanya, dan saling mendukung.</figcaption>
        </figure>
      </section>

      <section id="layanan" className="bg-surface py-12 sm:py-16" aria-labelledby="services-heading">
        <div className="page-gutter">
          <div className="grid gap-4 border-b border-border pb-6 sm:grid-cols-[0.7fr_1.3fr] sm:items-end sm:pb-8">
            <p className="eyebrow">Empat ruang informasi</p>
            <div><h2 id="services-heading" className="max-w-2xl text-3xl font-semibold tracking-[-0.04em] sm:text-4xl">Mulai dari hal yang sedang kamu cari tahu.</h2><p className="mt-3 max-w-2xl text-base leading-7 text-secondary">Semua materi dapat dibaca tanpa akun. Pilih topik yang paling dekat dengan kebutuhanmu.</p></div>
          </div>
          <ul className="grid gap-x-10 sm:grid-cols-2">
            {services.map(({ title, text, href, icon: Icon, accent }) => <li key={href} className="border-b border-border py-6 sm:py-8"><div className="flex items-start gap-4"><span className="grid size-11 shrink-0 place-items-center border border-border bg-background" style={{ color: accent }}><Icon className="size-5" aria-hidden="true" /></span><div><h3 className="text-xl font-semibold tracking-tight"><Link href={href} className="underline decoration-border underline-offset-4 hover:text-primary">{title}</Link></h3><p className="mt-2 max-w-lg text-base leading-7 text-secondary">{text}</p><Link className="mt-3 inline-flex min-h-11 items-center text-sm font-semibold text-primary underline underline-offset-4" href={href}>Lihat topik</Link></div></div></li>)}
          </ul>
        </div>
      </section>

      <Suspense fallback={<HomeEditorialSections data={getLocalEditorialData()} pending />}>
        <HomeCmsSections />
      </Suspense>

      <div className="page-gutter pb-8"><div className="border-t border-border pt-5 text-sm leading-6 text-muted-foreground">SIRAMA tidak menyatakan diri sebagai layanan pemerintah atau klinik medis. Informasi di situs ini bersifat edukasi dan tidak menggantikan bantuan profesional.</div></div>
    </main>
  );
}

async function HomeCmsSections() {
  const localData = getLocalEditorialData();
  const [cmsEnabled, healthManaged, mentalManaged, educationManaged, scholarshipManaged, faqManaged] = await Promise.all([
    isCmsConfigured(),
    getPublishedArticles(["health"]),
    getPublishedArticles(["mental_health"]),
    getPublishedArticles(["general", "education"]),
    getPublishedScholarships(),
    getPublishedFaqs(),
  ]);

  const data: HomeEditorialData = {
    healthItems: cmsEnabled ? healthManaged.slice(0, 4).map(({ slug, title, excerpt }) => ({ slug, title, summary: excerpt })) : localData.healthItems,
    mentalItems: cmsEnabled ? mentalManaged.slice(0, 4).map(({ slug, title, excerpt }) => ({ slug, title, summary: excerpt })) : localData.mentalItems,
    readingItems: cmsEnabled ? educationManaged.slice(0, 3).map(({ slug, title, excerpt }) => ({ slug, title, summary: excerpt })) : localData.readingItems,
    scholarshipItems: cmsEnabled
      ? scholarshipManaged.map((item) => ({ slug: item.slug, title: item.title, provider: item.provider, summary: item.description, period: getScholarshipPeriodText(item), url: item.official_url }))
      : localData.scholarshipItems,
    faqItems: cmsEnabled ? faqManaged.map(({ question, answer }) => ({ question, answer })) : localData.faqItems,
  };

  return <HomeEditorialSections data={data} />;
}

function HomeEditorialSections({ data, pending = false }: { data: HomeEditorialData; pending?: boolean }) {
  return (
    <>
      <section className="page-gutter grid gap-8 py-12 sm:py-16 lg:grid-cols-[0.75fr_1.25fr] lg:gap-16">
        <div><p className="eyebrow">Mulai membaca</p><h2 className="mt-3 max-w-md text-3xl font-semibold tracking-[-0.04em] sm:text-4xl">Topik yang dekat dengan keseharian.</h2><p className="mt-4 text-base leading-7 text-secondary">Panduan menjelaskan informasi dasar, hal yang perlu diperhatikan, langkah awal, dan kapan mencari bantuan.</p></div>
        <div className="grid gap-8 border-t border-border pt-5 sm:grid-cols-2 sm:border-t-0 sm:pt-0">
          <TopicLinks title="Kesehatan remaja" href="/kesehatan-remaja" items={data.healthItems} />
          <TopicLinks title="Kesehatan mental" href="/kesehatan-mental" items={data.mentalItems} />
        </div>
      </section>

      <section className="bg-surface py-12 sm:py-16" aria-labelledby="reading-heading">
        <div className="page-gutter grid gap-8 lg:grid-cols-[0.7fr_1.3fr] lg:gap-16"><div><p className="eyebrow">Pusat informasi dan edukasi</p><h2 id="reading-heading" className="mt-3 text-3xl font-semibold tracking-[-0.04em]">Pengetahuan untuk langkah sehari-hari.</h2><p className="mt-4 text-base leading-7 text-secondary">Bacaan ringkas tentang pilihan belajar, keterampilan, dan cara menilai informasi dari sumber resmi.</p><Link href="/edukasi" className="mt-4 inline-flex min-h-11 items-center font-semibold text-primary underline underline-offset-4">Kunjungi pusat edukasi</Link></div><ul className="divide-y divide-border border-y border-border">{data.readingItems.map((item) => <li key={item.slug} className="py-4"><Link href={`/edukasi/${item.slug}`} className="text-lg font-semibold underline decoration-border underline-offset-4 hover:text-primary">{item.title}</Link><p className="mt-2 text-base leading-7 text-secondary">{item.summary}</p></li>)}</ul></div>
      </section>

      <section className="bg-[#eaf1ee] py-12 sm:py-16" aria-labelledby="education-heading">
        <div className="page-gutter grid gap-8 lg:grid-cols-[0.75fr_1.25fr] lg:items-center lg:gap-16">
          <div><p className="eyebrow">Belajar dan bertumbuh</p><h2 id="education-heading" className="mt-3 text-3xl font-semibold tracking-[-0.04em] sm:text-4xl">Pendidikan membuka lebih banyak pilihan.</h2><p className="mt-4 max-w-lg text-base leading-7 text-secondary">Telusuri panduan pendidikan dan program beasiswa dengan tautan langsung ke sumber penyelenggara.</p><Link className="mt-5 inline-flex min-h-11 items-center font-semibold text-primary underline underline-offset-4" href="/pendidikan">Jelajahi pendidikan dan beasiswa</Link></div>
          {data.scholarshipItems.map((item) => <article key={item.slug} className="border-l-2 border-[#c06f4f] bg-surface p-5 sm:p-7"><p className="eyebrow">Informasi penyelenggara resmi</p><h3 className="mt-3 text-2xl font-semibold tracking-tight"><Link href={`/pendidikan/${item.slug}`} className="underline decoration-border underline-offset-4 hover:text-primary">{item.title}</Link></h3><p className="mt-2 text-sm font-medium text-muted-foreground">{item.provider}</p><p className="mt-4 text-base leading-7 text-secondary">{item.summary}</p><p className="mt-4 border-t border-border pt-4 text-sm leading-6 text-secondary">{item.period}</p><a className="mt-3 inline-flex min-h-11 items-center font-semibold text-primary underline underline-offset-4" href={item.url} target="_blank" rel="noopener noreferrer">Periksa portal resmi</a></article>)}
        </div>
      </section>

      <section className="page-gutter grid gap-8 py-12 sm:py-16 lg:grid-cols-[1fr_1fr] lg:items-center lg:gap-16">
        <div className="notice-panel p-6 sm:p-8"><p className="eyebrow">Keselamatan lebih dulu</p><h2 className="mt-3 text-3xl font-semibold tracking-[-0.04em]">Mengalami kekerasan atau perundungan?</h2><p className="mt-4 text-base leading-7">Kamu tidak harus menghadapi pelaku sendiri. Pelajari pilihan yang aman, cari orang dewasa tepercaya, atau akses kanal perlindungan resmi.</p><Link href="/kekerasan-perundungan" className="mt-4 inline-flex min-h-11 items-center font-semibold text-primary underline underline-offset-4">Baca panduan keselamatan</Link></div>
        <div><p className="eyebrow">Bantuan resmi untuk kekerasan terhadap perempuan dan anak</p><h3 className="mt-3 text-2xl font-semibold">SAPA 129</h3><p className="mt-3 text-base leading-7 text-secondary">Telepon 129 atau WhatsApp 08111-129-129. Jika dalam bahaya langsung, hubungi polisi 110 atau layanan darurat setempat.</p><a href="https://laporsapa129.kemenpppa.go.id/" target="_blank" rel="noopener noreferrer" className="mt-3 inline-flex min-h-11 items-center font-semibold text-primary underline underline-offset-4">Buka informasi SAPA 129</a><p className="mt-3 text-sm leading-6 text-muted-foreground">Kanal tersebut dikelola Kementerian Pemberdayaan Perempuan dan Perlindungan Anak, bukan oleh SIRAMA.</p></div>
      </section>

      <section className="bg-surface py-12 sm:py-16" aria-labelledby="faq-home">
        <div className="page-gutter grid gap-8 lg:grid-cols-[0.7fr_1.3fr] lg:gap-16"><div><p className="eyebrow">Pertanyaan umum</p><h2 id="faq-home" className="mt-3 text-3xl font-semibold tracking-[-0.04em]">Sebelum mulai membaca.</h2><Link href="/faq" className="mt-4 inline-flex min-h-11 items-center font-semibold text-primary underline underline-offset-4">Lihat semua FAQ</Link></div><div className="divide-y divide-border border-y border-border">{data.faqItems.slice(0, 4).map((item) => <details key={item.question} className="group"><summary className="flex min-h-14 cursor-pointer list-none items-center justify-between gap-4 py-4 text-left text-base font-semibold marker:hidden [&::-webkit-details-marker]:hidden">{item.question}<span aria-hidden="true" className="faq-toggle text-xl font-normal text-primary">+</span></summary><p className="max-w-2xl pb-5 pr-8 text-base leading-7 text-secondary">{item.answer}</p></details>)}</div></div>
      </section>

      <section className="page-gutter grid gap-7 py-12 sm:py-16 lg:grid-cols-[1fr_auto] lg:items-center" aria-labelledby="contact-home">
        <div><p className="eyebrow">Butuh berbicara dengan petugas?</p><h2 id="contact-home" className="mt-3 max-w-2xl text-3xl font-semibold tracking-[-0.04em] sm:text-4xl">Kamu berhak mencari dukungan.</h2><p className="mt-4 max-w-2xl text-base leading-7 text-secondary">Jika nomor WhatsApp resmi SIRAMA telah tersedia, kamu dapat meninjau draf pesan sebelum mengirimnya. Dalam bahaya langsung, gunakan layanan darurat resmi.</p></div>
        {pending ? <Link href="/kontak" className="inline-flex min-h-12 items-center border border-primary px-5 py-3 text-sm font-semibold text-primary no-underline hover:bg-muted">Lihat kontak dan bantuan</Link> : <Suspense fallback={<p className="border-l-2 border-border pl-4 text-sm leading-6 text-muted-foreground">Menyiapkan kanal layanan…</p>}><WhatsAppAction kind="health" label="Hubungi layanan SIRAMA" /></Suspense>}
      </section>
    </>
  );
}

function TopicLinks({ title, href, items }: { title: string; href: string; items: HomeLinkItem[] }) {
  return (
    <div><h3 className="border-b border-border pb-3 text-base font-semibold">{title}</h3><ul className="mt-2 divide-y divide-border">{items.map((item) => <li key={item.slug}><Link className="flex min-h-12 items-center justify-between gap-3 text-base text-secondary underline-offset-4 hover:text-primary hover:underline" href={`${href}/${item.slug}`}>{item.title}</Link></li>)}</ul><Link className="mt-3 inline-flex min-h-11 items-center text-sm font-semibold text-primary underline underline-offset-4" href={href}>Lihat semua topik</Link></div>
  );
}
