import express from 'express'
import { health } from '../controllers/health'

const router = express.Router()

router.route('/').get(health)

export default router
