import fs from 'fs';
import path from 'path';
import sqlite3 from 'sqlite3';
import { initDatabase } from '../src/schemas/schemas.js';

const DB_PATH = path.resolve(process.cwd(), 'Gestion de reportes.sqlite');

const LEGACY_ALTERS = [
  `ALTER TABLE Users ADD COLUMN area varchar(500);`,
  `ALTER TABLE Users ADD COLUMN password varchar(500);`,
  `ALTER TABLE Report ADD COLUMN departamento varchar(500);`,
  `ALTER TABLE Report ADD COLUMN tipo varchar(500);`,
  `ALTER TABLE Report ADD COLUMN resuelto_por integer;`,
  `ALTER TABLE Report ADD COLUMN resuelto_por_nombre varchar(500);`
];

function applyLegacyMigrations(db) {
  return new Promise((resolve, reject) => {
    db.serialize(() => {
      for (const cmd of LEGACY_ALTERS) {
        db.run(cmd, (err) => {
          if (err && !err.message.includes("duplicate column name")) {
            console.warn("Nota: migración omitida:", err.message);
          }
        });
      }
      db.close((closeErr) => {
        if (closeErr) return reject(closeErr);
        resolve();
      });
    });
  });
}

export async function setupDatabase() {
  if (fs.existsSync(DB_PATH)) {
    const sqlite = sqlite3.verbose();
    const db = new sqlite.Database(DB_PATH);
    await applyLegacyMigrations(db);
  }
  await initDatabase();
}

export default setupDatabase;