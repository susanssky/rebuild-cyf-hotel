
import { readFileSync } from 'fs';
import { join } from 'path';
import { Client } from 'pg';
import { logger } from './logger';

export const seedDatabase = async (client: Client) => {
  try {
    // Read the seeding.sql file
    const sqlFilePath = join(__dirname, 'seeding.sql');
    const sql = readFileSync(sqlFilePath, 'utf8');

    // Execute the SQL commands
    await client.query(sql);
    logger.info('Database seeded successfully');
  } catch (err) {
    logger.error('Failed to seed database:', err);
    throw err; // Optionally rethrow to handle in caller
  }
};