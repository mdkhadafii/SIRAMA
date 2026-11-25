export function BrandMark({ className = "" }: { className?: string }) {
  return (
    <span className={`brand-mark ${className}`} aria-hidden="true">
      <svg viewBox="0 0 32 32" fill="none" className="size-7" focusable="false">
        <path
          d="M7 25V14.5A9 9 0 0 1 25 14.5V25"
          stroke="currentColor"
          strokeWidth="1.7"
        />
        <path d="M11 25V15a5 5 0 0 1 10 0v10" stroke="currentColor" strokeWidth="1.7" />
        <path d="M4 25h24" stroke="currentColor" strokeWidth="1.7" />
        <circle cx="21.5" cy="19" r="1" fill="var(--brand-terracotta)" />
      </svg>
    </span>
  );
}
