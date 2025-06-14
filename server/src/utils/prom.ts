import promClient from 'prom-client';
import { Request, Response, NextFunction } from 'express';


promClient.collectDefaultMetrics();


export const httpRequestCounter = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
});


export const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code'],
  buckets: [0.1, 0.3, 0.5, 1, 2, 5],
});


export const prometheusMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    const labels = {
      method: req.method,
      route: req.baseUrl || req.path,
      status_code: res.statusCode.toString(),
    };
    httpRequestCounter.inc(labels);
    httpRequestDuration.observe(labels, duration);
  });
  next();
};


export const getMetrics = async (req: Request, res: Response) => {
  res.set('Content-Type', promClient.register.contentType);
  res.end(await promClient.register.metrics());
};