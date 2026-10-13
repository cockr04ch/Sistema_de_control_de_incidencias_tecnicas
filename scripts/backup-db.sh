#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DB="$ROOT/backend/Gestion de reportes.sqlite"
BACKUP_DIR="$ROOT/backend/backups"
KEEP=10
STAMP="$(date +%Y%m%d-%H%M%S)"
DEST="$BACKUP_DIR/Gestion de reportes.sqlite.$STAMP"

if [ ! -f "$DB" ]; then
  echo "No se encuentra la base de datos en: $DB"
  exit 1
fi

mkdir -p "$BACKUP_DIR"

STOPPED=0
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1 && [ -f "$ROOT/compose.yaml" ] && docker ps --format '{{.Names}}' | grep -q '^backend_app$'; then
  echo "Deteniendo backend_app para un backup consistente..."
  docker compose -f "$ROOT/compose.yaml" stop backend
  STOPPED=1
fi

cp "$DB" "$DEST"
echo "Backup creado: $DEST"

if [ "$STOPPED" -eq 1 ]; then
  echo "Reiniciando backend_app..."
  docker compose -f "$ROOT/compose.yaml" start backend
fi

COUNT="$(ls -1 "$BACKUP_DIR" 2>/dev/null | wc -l)"
if [ "$COUNT" -gt "$KEEP" ]; then
  OLDEST="$(ls -1t "$BACKUP_DIR" | tail -n +$((KEEP + 1)))"
  for f in $OLDEST; do
    rm -f "$BACKUP_DIR/$f"
    echo "Eliminado backup antiguo: $BACKUP_DIR/$f"
  done
fi