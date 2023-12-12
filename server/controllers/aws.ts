import os from 'os'
import { Request, Response } from 'express'

export const getServerName = async (req: Request, res: Response) => {
  const osHostname = os.hostname()
  const reqHostname = req.headers.host

  return res.status(200).json({
    osHostname,
    reqHostname,
  })
}
