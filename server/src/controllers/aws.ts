import os from 'os'
import { Request, Response } from 'express'
import { logger } from '../utils/logger'

export const getServerName = async (req: Request, res: Response) => {
  const startTime = Date.now()

  try {
    const osHostname = os.hostname()
    const reqHostname = req.headers.host

    const responseData = {
      osHostname,
      reqHostname,
    }

    logger.info('Processed getServerName request', {
      route: req.originalUrl,
      method: req.method,
      duration_ms: Date.now() - startTime,
    })

    return res.status(200).json(responseData)
  } catch (error: any) {
    logger.error('Error in getServerName controller', {
      error: error.message,
      stack: error.stack,
      route: req.path,
      method: req.method,
      host: req.headers.host,
    })
    return res.status(500).json({ error: 'Internal server error' })
  }
}
