import express, { Express } from 'express'

import 'dotenv/config'

import { Client } from 'pg'
import { ClientConfig } from './utils/clientConfig'

import cors from 'cors'

import customerRoutes from './routes/customers'
import awsRoutes from './routes/aws'

const app: Express = express()

app.use(cors())

export const client = new Client(ClientConfig)
client.connect()

app.use('/', customerRoutes)
app.use('/aws', awsRoutes)

console.log(
  'Are ENV VARS being loaded correctly? SERVER_PORT:',
  process.env.SERVER_PORT
)

app.listen(process.env.SERVER_PORT, () => {
  console.log(`Server is listening on port ${process.env.SERVER_PORT}`)
})
