import { Request, Response } from 'express'
import { queryAndRespond } from '../utils/getSqlData'
import { logger } from '../utils/logger'

export const getCustomers = async (req: Request, res: Response) => {
  const startTime = Date.now()

  try {
    if (req.query.id) {
      const id = Number(req.query.id)

      await queryAndRespond(res, 'SELECT * FROM customers WHERE id=$1', id)

      logger.info('Processed getCustomers request', {
        route: req.originalUrl,
        method: req.method,
        query: req.query,
        customerId: id,
        duration_ms: Date.now() - startTime,
      })
    } else {
      await queryAndRespond(res, 'SELECT * FROM customers')
      logger.info('Processed getCustomers request', {
        route: req.originalUrl,
        method: req.method,
        query: req.query,
        duration_ms: Date.now() - startTime,
      })
    }
  } catch (error: any) {
    logger.error('Error in getCustomers controller', {
      error: error.message,
      stack: error.stack,
      route: req.originalUrl,
      method: req.method,
      query: req.query,
    })
    return res.status(500).json({ error: 'Failed to fetch customers' })
  }
}
