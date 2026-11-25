import { notFound, redirect } from "next/navigation";
import { ContentManager, type Resource } from "@/features/admin/content-manager";
import { getAuthenticatedAdmin } from "@/lib/security/authorization";

const sectionResources: Record<string, Resource> = { artikel: "articles", beasiswa: "scholarships", faq: "faqs", kategori: "categories", pengaturan: "site_settings" };
export default async function AdminSectionPage({ params }: { params: Promise<{ section: string }> }) {
  const { section } = await params;
  const resource = sectionResources[section];
  if (!resource) notFound();
  if (!await getAuthenticatedAdmin()) redirect("/admin/login?next=/admin/" + section);
  return <ContentManager resource={resource} />;
}
