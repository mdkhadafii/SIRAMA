export default function Loading() {
  return (
    <main id="konten-utama" className="page-gutter route-loading" aria-busy="true" aria-live="polite">
      <div className="route-loading-content">
        <div className="route-loading-track" aria-hidden="true" />
        <p className="mt-4 text-sm font-semibold text-secondary" role="status">Memuat informasi untukmu…</p>
        <div className="route-skeleton-grid" aria-hidden="true">
          <div>
            <div className="loading-skeleton h-4 w-48" />
            <div className="mt-6 space-y-3">
              <div className="loading-skeleton h-9 w-[92%]" />
              <div className="loading-skeleton h-9 w-[74%]" />
            </div>
            <div className="mt-6 space-y-2.5">
              <div className="loading-skeleton h-4 w-full" />
              <div className="loading-skeleton h-4 w-[88%]" />
              <div className="loading-skeleton h-4 w-[61%]" />
            </div>
          </div>
          <div className="loading-skeleton route-skeleton-visual" />
        </div>
      </div>
    </main>
  );
}
