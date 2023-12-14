import express from 'express'
import { getServerName } from '../controllers/aws'

const router = express.Router()

router.route('/').get(getServerName)

export default router
