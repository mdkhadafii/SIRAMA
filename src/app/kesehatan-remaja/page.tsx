import type { Metadata } from "next";
import { Suspense } from "react";
import { HealthIndex } from "@/features/content/topic-pages";
import { healthTopics } from "@/features/content/catalog";
import { getPublishedArticles, isCmsConfigured } from "@/features/content/published-content";

export const metadata: Metadata = { title: "Kesehatan remaja", description: "Informasi kesehatan remaja yang mudah dipahami, lengkap dengan sumber dan langkah mencari bantuan." };
export const dynamic = "force-dynamic";
export default function Page() { return <Suspense fallback={<HealthIndex topics={healthTopics} />}><HealthIndexContent /></Suspense>; }
async function HealthIndexContent() { const [articles, cmsReady] = await Promise.all([getPublishedArticles(["health"]), isCmsConfigured()]); return <HealthIndex topics={cmsReady ? [] : healthTopics} articles={articles} />; }
