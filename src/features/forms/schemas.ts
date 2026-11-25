import { z } from "zod";

export const loginFormSchema = z.object({ email: z.string().trim().toLowerCase().email().max(254), password: z.string().min(1).max(128) }).strict();
export const loginRequestSchema = loginFormSchema.extend({ next: z.string().max(2048).optional() }).strict();
export type LoginFormValues = z.infer<typeof loginFormSchema>;
