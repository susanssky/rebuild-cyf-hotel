import { Response } from 'express'
import { client } from '../server'
export const queryAndRespond = async (
  res: Response,
  sql: string,
  id?: number | string
) => {
  try {
    const parameters = id !== undefined ? [id] : []
    const result = await client.query(sql, parameters)
    return res.status(200).json(result.rows)
  } catch (err) {
    console.error(err)
    return res.status(500).json(err)
  }
}
