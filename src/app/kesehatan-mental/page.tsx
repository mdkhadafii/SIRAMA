import type { Metadata } from "next";
import { Suspense } from "react";
import { MentalIndex } from "@/features/content/topic-pages";
import { mentalTopics } from "@/features/content/catalog";
import { getPublishedArticles, isCmsConfigured } from "@/features/content/published-content";

export const metadata: Metadata = { title: "Kesehatan mental", description: "Edukasi kesehatan mental remaja dengan bahasa empatik, pertanyaan kontekstual, dan jalur bantuan." };
export const dynamic = "force-dynamic";
export default function Page() { return <Suspense fallback={<MentalIndex topics={mentalTopics} />}><MentalIndexContent /></Suspense>; }
async function MentalIndexContent() { const [articles, cmsReady] = await Promise.all([getPublishedArticles(["mental_health"]), isCmsConfigured()]); return <MentalIndex topics={cmsReady ? [] : mentalTopics} articles={articles} />; }
