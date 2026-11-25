import "server-only";
import { getServerEnv } from "@/lib/env";
import { createPublicSupabaseClient } from "@/lib/supabase/public";

function getPublishedAtCutoff() {
  const interval = 30_000;
  return new Date(Math.floor(Date.now() / interval) * interval).toISOString();
}

export async function isCmsConfigured() {
  try {
    if (!getServerEnv().NEXT_PUBLIC_SUPABASE_URL) return false;
    const supabase = createPublicSupabaseClient();
    const [settingsResult, contentResult] = await Promise.all([
      supabase.from("site_settings").select("key").limit(1),
      supabase.from("articles").select("id").eq("status", "published").not("published_at", "is", null).lte("published_at", getPublishedAtCutoff()).limit(1),
    ]);
    return !settingsResult.error && !contentResult.error && (contentResult.data?.length ?? 0) > 0;
  } catch {
    return false;
  }
}

export type PublishedArticle = {
  id: string;
  title: string;
  slug: string;
  excerpt: string;
  content: string;
  content_type: string;
  source_url: string | null;
  thumbnail_url: string | null;
  image_alt: string | null;
  reviewed_at: string | null;
  published_at: string;
};

export async function getPublishedArticles(contentTypes?: string[]): Promise<PublishedArticle[]> {
  try {
    const supabase = createPublicSupabaseClient();
    let query = supabase.from("articles")
      .select("id,title,slug,excerpt,content,content_type,source_url,thumbnail_url,image_alt,reviewed_at,published_at")
      .eq("status", "published").not("published_at", "is", null).lte("published_at", getPublishedAtCutoff())
      .order("published_at", { ascending: false });
    if (contentTypes?.length) query = query.in("content_type", contentTypes);
    const { data, error } = await query.limit(100);
    if (error || !data) return [];
    return data as PublishedArticle[];
  } catch { return []; }
}

export async function getPublishedArticle(slug: string): Promise<PublishedArticle | null> {
  if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(slug)) return null;
  try {
    const supabase = createPublicSupabaseClient();
    const { data, error } = await supabase.from("articles")
      .select("id,title,slug,excerpt,content,content_type,source_url,thumbnail_url,image_alt,reviewed_at,published_at")
      .eq("slug", slug).eq("status", "published").not("published_at", "is", null).lte("published_at", getPublishedAtCutoff()).maybeSingle();
    if (error || !data) return null;
    return data as PublishedArticle;
  } catch { return null; }
}

export async function getPublishedArticleSources(articleId: string) {
  try {
    const supabase = createPublicSupabaseClient();
    const { data, error } = await supabase.from("article_sources").select("title,url,reviewed_at").eq("article_id", articleId).order("created_at");
    return error ? [] : data ?? [];
  } catch { return []; }
}

export async function getPublishedFaqs(context?: { articleId?: string; scholarshipId?: string }) {
  try {
    const supabase = createPublicSupabaseClient();
    let query = supabase.from("faqs").select("id,question,answer,article_id,scholarship_id,display_order").eq("status", "published").eq("is_active", true).order("display_order");
    if (context?.articleId) query = query.eq("article_id", context.articleId);
    else if (context?.scholarshipId) query = query.eq("scholarship_id", context.scholarshipId);
    else query = query.is("article_id", null).is("scholarship_id", null);
    const { data, error } = await query.limit(100);
    return error ? [] : data ?? [];
  } catch { return []; }
}

export async function getPublishedScholarships() {
  try {
    const supabase = createPublicSupabaseClient();
    const { data, error } = await supabase.from("scholarships").select("id,title,slug,provider,description,requirements,benefits,education_level,deadline,official_url,thumbnail_url,image_alt,status,application_period,application_steps,reviewed_at").eq("status", "published").order("updated_at", { ascending: false }).limit(50);
    return error ? [] : data ?? [];
  } catch { return []; }
}

export async function getPublicSiteSettings() {
  try {
    const supabase = createPublicSupabaseClient();
    const { data, error } = await supabase
      .from("site_settings")
      .select("key,value")
      .eq("is_public", true)
      .limit(20);
    if (error) return {};
    return Object.fromEntries((data ?? []).filter((item) => typeof item.value === "string").map((item) => [item.key, item.value]));
  } catch {
    return {};
  }
}

