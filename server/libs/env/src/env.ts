import { z } from 'zod';

export const envSchema = z.object({
  NODE_ENV: z.string().default('stage'),

  NATS_HOST: z.string().default('localhost'),
  NATS_PORT: z.coerce.number().default(4222),

  TG_BOT_KEY: z.string(),
  VK_APP_KEY: z.string(),
  JWT_SECRET: z.string(),
});

export type Env = z.infer<typeof envSchema>;
