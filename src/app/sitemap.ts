import type { MetadataRoute } from "next";
import { educationArticles, healthTopics, mentalTopics, safetyTopics, scholarships } from "@/features/content/catalog";
import { getPublishedArticles, getPublishedScholarships, isCmsConfigured } from "@/features/content/published-content";
import { getPublicSiteUrl } from "@/lib/site-url";

const staticRoutes = ["/", "/tentang", "/kesehatan-remaja", "/kesehatan-mental", "/pendidikan", "/kekerasan-perundungan", "/edukasi", "/faq", "/kontak", "/privasi"];

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const siteUrl = getPublicSiteUrl();
  if (!siteUrl) return [];
  const base = siteUrl;
  const cmsReady = await isCmsConfigured();
  const routes: MetadataRoute.Sitemap = staticRoutes.map((route) => ({ url: new URL(route, base).toString() }));

  if (cmsReady) {
    const [articles, programs] = await Promise.all([getPublishedArticles(), getPublishedScholarships()]);
    routes.push(...articles.map((article) => {
      const section = article.content_type === "health" ? "kesehatan-remaja"
        : article.content_type === "mental_health" ? "kesehatan-mental"
        : article.content_type === "safety" ? "kekerasan-perundungan" : "edukasi";
      return { url: new URL(`/${section}/${article.slug}`, base).toString(), lastModified: article.reviewed_at ?? article.published_at };
    }));
    routes.push(...programs.map((program) => ({ url: new URL(`/pendidikan/${program.slug}`, base).toString(), lastModified: program.reviewed_at ?? undefined })));
    return routes;
  }

  const entries = [
    ...healthTopics.map((item) => `/kesehatan-remaja/${item.slug}`),
    ...mentalTopics.map((item) => `/kesehatan-mental/${item.slug}`),
    ...safetyTopics.map((item) => `/kekerasan-perundungan/${item.slug}`),
    ...educationArticles.map((item) => `/edukasi/${item.slug}`),
    ...scholarships.map((item) => `/pendidikan/${item.slug}`),
  ];
  routes.push(...entries.map((route) => ({ url: new URL(route, base).toString() })));
  return routes;
}
