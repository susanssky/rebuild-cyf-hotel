import express, { Express, Request, Response, NextFunction } from 'express'
import 'dotenv/config'
import { Client } from 'pg'
import { ClientConfig } from './utils/clientConfig'
import cors from 'cors'
import customerRoutes from './routes/customers'
import awsRoutes from './routes/aws'
import promClient from 'prom-client'
import { logger } from './utils/logger'


const app: Express = express()

app.use(cors())

promClient.collectDefaultMetrics()

const httpRequestCounter = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
})

const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code'],
  buckets: [0.1, 0.3, 0.5, 1, 2, 5],
})

app.use((req: Request, res: Response, next: NextFunction) => {
  const start = Date.now()
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000
    const labels = {
      method: req.method,
      route: req.baseUrl || req.path,
      status_code: res.statusCode.toString(),
    }
    httpRequestCounter.inc(labels)
    httpRequestDuration.observe(labels, duration)
  })
  next()
})

app.get('/metrics', async (req: Request, res: Response) => {
  res.set('Content-Type', promClient.register.contentType)
  res.end(await promClient.register.metrics())
})

// export const client = new Client(ClientConfig)
// client.connect()
export let client: Client | undefined

if (process.env.DATABASE_URL) {
  client = new Client(ClientConfig)
  client
    .connect()
    .then(() => {
      logger.info('Successfully connected to database')
    })
    .catch((err) => {
      logger.error('Failed to connect to database:', err)
    })
} else {
  logger.warn(
    'DATABASE_URL is not set. Database operations will return empty array.'
  )
}

app.use('/aws', awsRoutes)
app.use('/', customerRoutes)

app.listen(process.env.SERVER_PORT, () => {
  logger.info(`Server is listening on port ${process.env.SERVER_PORT}`)
})
