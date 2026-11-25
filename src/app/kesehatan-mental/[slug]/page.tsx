import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { mentalTopics } from "@/features/content/catalog";
import { PublishedArticleDetail, TopicDetail } from "@/features/content/topic-pages";
import { getPublishedArticle, isCmsConfigured } from "@/features/content/published-content";

export const dynamic = "force-dynamic";
export async function generateMetadata({ params }: { params: Promise<{ slug: string }> }): Promise<Metadata> {
  const { slug } = await params; const topic = mentalTopics.find((item) => item.slug === slug); const article = await getPublishedArticle(slug);
  if (article?.content_type === "mental_health") return { title: article.title, description: article.excerpt };
  return { title: topic?.title ?? "Topik kesehatan mental", description: topic?.summary ?? "Informasi kesehatan mental remaja." };
}
export default async function Page({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params; const article = await getPublishedArticle(slug);
  if (article?.content_type === "mental_health") return <PublishedArticleDetail article={article} kind="mental" />;
  if (await isCmsConfigured()) notFound();
  const topic = mentalTopics.find((item) => item.slug === slug);
  if (!topic) notFound();
  return <TopicDetail topic={topic} kind="mental" />;
}
