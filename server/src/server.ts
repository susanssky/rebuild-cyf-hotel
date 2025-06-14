import express, { Express, Request, Response } from 'express'
import 'dotenv/config'
import { Client } from 'pg'
import { ClientConfig } from './utils/clientConfig'
import cors from 'cors'
import customerRoutes from './routes/customers'
import awsRoutes from './routes/aws'
import healthRoutes from './routes/health'
import { logger } from './utils/logger'
import { seedDatabase } from './utils/seedDatabase'
import { prometheusMiddleware, getMetrics } from './utils/prom'

const app: Express = express()

app.use(cors())
app.use(prometheusMiddleware)

app.get('/metrics', getMetrics)

export let client: Client | undefined


async function connectWithRetry(
  maxRetries = 10,
  delayMs = 5000
): Promise<Client> {
  let retries = 0
  while (retries < maxRetries) {
    try {
      const client = new Client(ClientConfig)
      await client.connect()
      logger.info('Successfully connected to database')
      await seedDatabase(client)
      return client
    } catch (err) {
      retries++
      logger.error(
        `Failed to connect to database (attempt ${retries}/${maxRetries}):`,
        err
      )
      if (retries === maxRetries) {
        throw new Error('Max retries reached, could not connect to database')
      }
      await new Promise((resolve) => setTimeout(resolve, delayMs))
    }
  }
  throw new Error('Unexpected error in connectWithRetry')
}

if (process.env.DATABASE_URL) {
  connectWithRetry()
    .then((connectedClient) => {
      client = connectedClient
    })
    .catch((err) => {
      logger.error('Failed to initialize database connection:', err)
      process.exit(1)
    })
} else {
  logger.warn(
    'DATABASE_URL is not set. Database operations will return empty array.'
  )
}

app.use('/api/customers', customerRoutes)
app.use('/healthz', healthRoutes)
app.use('/aws', awsRoutes)

app.listen(process.env.SERVER_PORT, () => {
  logger.info(`Server is listening on port ${process.env.SERVER_PORT}`)
})
