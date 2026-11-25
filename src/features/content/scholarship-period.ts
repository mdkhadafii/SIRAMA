type ScholarshipPeriod = {
  deadline?: string | null;
  period?: string | null;
  application_period?: string | null;
};

function todayInJakarta() {
  const parts = new Intl.DateTimeFormat("en", {
    timeZone: "Asia/Jakarta",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).formatToParts(new Date());
  const values = Object.fromEntries(parts.map(({ type, value }) => [type, value]));
  return `${values.year}-${values.month}-${values.day}`;
}

export function getScholarshipPeriodText(item: ScholarshipPeriod) {
  if (item.deadline && /^\d{4}-\d{2}-\d{2}$/.test(item.deadline) && item.deadline < todayInJakarta()) {
    return "Periode yang diperiksa telah berlalu. Periksa portal resmi penyelenggara untuk jadwal dan ketentuan terbaru.";
  }

  return item.period ?? item.application_period ?? "Periksa periode terbaru pada portal resmi penyelenggara.";
}
