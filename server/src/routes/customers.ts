import express from 'express'
import { getCustomers } from '../controllers/customers'

const router = express.Router()

router.route('/').get(getCustomers)

export default router
