import type { ClientType } from './types'
// import 'dotenv/config'
import dotenv from 'dotenv'
import path from 'path'
dotenv.config({ path: path.resolve(__dirname, '../.env') })
// console.log(path.resolve(__dirname, '../.env'))
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
