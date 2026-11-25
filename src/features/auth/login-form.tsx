"use client";

import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { LoaderCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { loginFormSchema, type LoginFormValues } from "@/features/forms/schemas";

type LoginFormProps = { returnTo: string };
export function LoginForm({ returnTo }: LoginFormProps) {
  const [serverError, setServerError] = useState<string | null>(null);
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<LoginFormValues>({ resolver: zodResolver(loginFormSchema), defaultValues: { email: "", password: "" } });
  async function onSubmit(values: LoginFormValues) {
    setServerError(null);
    try {
      const response = await fetch("/api/auth/login", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ ...values, next: returnTo }), cache: "no-store", credentials: "same-origin" });
      const result = await response.json() as { redirectTo?: string; error?: { message?: string } };
      if (!response.ok || !result.redirectTo) { setServerError(result.error?.message ?? "Akun admin belum dapat diverifikasi."); return; }
      window.location.assign(result.redirectTo);
    } catch { setServerError("Koneksi terganggu. Silakan coba lagi."); }
  }
  return <form className="mt-7 grid gap-4" onSubmit={handleSubmit(onSubmit)} noValidate>
    <div className="grid gap-2"><label htmlFor="login-email" className="text-base font-semibold">Email admin</label><input id="login-email" type="email" autoComplete="username" maxLength={254} aria-invalid={Boolean(errors.email)} aria-describedby={errors.email ? "login-email-error" : undefined} disabled={isSubmitting} className="min-h-12 w-full border border-border bg-background px-3 text-base outline-none focus-visible:border-accent focus-visible:ring-2 focus-visible:ring-accent/25" {...register("email")}/>{errors.email ? <p id="login-email-error" className="text-sm text-danger" role="alert">Masukkan alamat email yang valid.</p> : null}</div>
    <div className="grid gap-2"><label htmlFor="login-password" className="text-base font-semibold">Kata sandi</label><input id="login-password" type="password" autoComplete="current-password" maxLength={128} aria-invalid={Boolean(errors.password)} aria-describedby={errors.password ? "login-password-error" : undefined} disabled={isSubmitting} className="min-h-12 w-full border border-border bg-background px-3 text-base outline-none focus-visible:border-accent focus-visible:ring-2 focus-visible:ring-accent/25" {...register("password")}/>{errors.password ? <p id="login-password-error" className="text-sm text-danger" role="alert">Kata sandi wajib diisi.</p> : null}</div>
    {serverError ? <p role="alert" className="text-sm text-danger">{serverError}</p> : null}
    <Button className="w-full sm:w-fit" type="submit" disabled={isSubmitting}>{isSubmitting ? <><LoaderCircle className="animate-spin" aria-hidden="true"/> Memeriksa akun</> : "Masuk ke pengelolaan"}</Button>
  </form>;
}
