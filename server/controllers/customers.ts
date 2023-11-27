import { Request, Response } from 'express'
import { queryAndRespond } from '../utils/getSQLData'

export const getCustomers = async (req: Request, res: Response) => {
  if (req.query.id) {
    queryAndRespond(
      res,
      'SELECT * FROM customers WHERE id=$1',
      Number(req.query.id)
    )
  } else {
    queryAndRespond(res, 'SELECT * FROM customers')
  }
}
