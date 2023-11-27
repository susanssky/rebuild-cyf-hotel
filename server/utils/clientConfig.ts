import type { ClientType } from './types'
import 'dotenv/config'

export const ClientConfig: ClientType = {
  // host: process.env.HOST!,
  // user: process.env.USER!,
  // database: process.env.DATABASE!,
  // password: process.env.PASSWORD!,
  // port: Number(process.env.PORT!),
  ssl: {
    rejectUnauthorized: false,
  },
  connectionString: process.env.DATEBASE_URL!,
}
