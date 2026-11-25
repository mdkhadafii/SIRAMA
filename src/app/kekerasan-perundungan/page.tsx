import type { Metadata } from "next";
import { Suspense } from "react";
import { SafetyIndex } from "@/features/content/topic-pages";
import { safetyTopics } from "@/features/content/catalog";
import { getPublishedArticles, isCmsConfigured } from "@/features/content/published-content";

export const metadata: Metadata = { title: "Kekerasan dan perundungan", description: "Panduan keselamatan yang berpihak pada korban dan jalur bantuan resmi." };
export const dynamic = "force-dynamic";
export default function Page() { return <Suspense fallback={<SafetyIndex topics={safetyTopics} />}><SafetyIndexContent /></Suspense>; }
async function SafetyIndexContent() { const [articles, cmsReady] = await Promise.all([getPublishedArticles(["safety"]), isCmsConfigured()]); return <SafetyIndex topics={cmsReady ? [] : safetyTopics} articles={articles} />; }
