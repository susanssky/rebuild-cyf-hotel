import express, { Express } from 'express'
import 'dotenv/config'
import { Client } from 'pg'
import { ClientConfig } from './utils/clientConfig'
import fs from 'fs'
import cors from 'cors'
import path from 'path'
import customerRoutes from './routes/customers'

const app: Express = express()
app.use(cors())

export const client = new Client(ClientConfig)
client.connect()

const seedQuery = fs.readFileSync(
  path.resolve(__dirname, './utils/seeding.sql'),
  {
    encoding: 'utf8',
  }
)
client.query(seedQuery, (err, res) => {
  console.log(err, res)
  console.log('Seeding Completed!')
  // client.end()
})
app.use('/', customerRoutes)
app.listen(process.env.PORT, () => {
  console.log(`Server is listening on post ${process.env.PORT}`)
})
