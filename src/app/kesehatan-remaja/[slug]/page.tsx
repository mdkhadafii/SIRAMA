import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { healthTopics } from "@/features/content/catalog";
import { PublishedArticleDetail, TopicDetail } from "@/features/content/topic-pages";
import { getPublishedArticle, isCmsConfigured } from "@/features/content/published-content";

export const dynamic = "force-dynamic";
export async function generateMetadata({ params }: { params: Promise<{ slug: string }> }): Promise<Metadata> {
  const { slug } = await params; const topic = healthTopics.find((item) => item.slug === slug); const article = await getPublishedArticle(slug);
  if (article?.content_type === "health") return { title: article.title, description: article.excerpt };
  return { title: topic?.title ?? "Topik kesehatan", description: topic?.summary ?? "Informasi kesehatan remaja." };
}
export default async function Page({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params; const article = await getPublishedArticle(slug);
  if (article?.content_type === "health") return <PublishedArticleDetail article={article} kind="health" />;
  if (await isCmsConfigured()) notFound();
  const topic = healthTopics.find((item) => item.slug === slug);
  if (!topic) notFound();
  return <TopicDetail topic={topic} kind="health" />;
}
