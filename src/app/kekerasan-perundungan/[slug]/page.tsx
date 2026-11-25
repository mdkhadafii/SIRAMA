import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { safetyTopics } from "@/features/content/catalog";
import { PublishedArticleDetail, TopicDetail } from "@/features/content/topic-pages";
import { getPublishedArticle, isCmsConfigured } from "@/features/content/published-content";

export const dynamic = "force-dynamic";
export async function generateMetadata({ params }: { params: Promise<{ slug: string }> }): Promise<Metadata> {
  const { slug } = await params; const topic = safetyTopics.find((item) => item.slug === slug); const article = await getPublishedArticle(slug);
  if (article?.content_type === "safety") return { title: article.title, description: article.excerpt };
  return { title: topic?.title ?? "Panduan keselamatan", description: topic?.summary ?? "Informasi mengenai kekerasan dan perundungan." };
}
export default async function Page({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params; const article = await getPublishedArticle(slug);
  if (article?.content_type === "safety") return <PublishedArticleDetail article={article} kind="safety" />;
  if (await isCmsConfigured()) notFound();
  const topic = safetyTopics.find((item) => item.slug === slug);
  if (!topic) notFound();
  return <TopicDetail topic={topic} kind="safety" />;
}
