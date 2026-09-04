#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${ASM3_DATA_DIR:-/data}"
mkdir -p "$DATA_DIR" /tmp/asm_disk_cache

BASE_URL="${ASM3_BASE_URL:-}"
if [ -z "$BASE_URL" ] && [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
  BASE_URL="https://${RAILWAY_PUBLIC_DOMAIN}"
fi

cat > "$ASM3_CONF" <<EOF
base_url = ${BASE_URL:-http://localhost:5000}
service_url = ${BASE_URL:-http://localhost:5000}/service
locale = ${ASM3_LOCALE:-en}
timezone = ${ASM3_TIMEZONE:-0}
log_location = stderr
deployment_type = wsgi
db_type = SQLITE
db_name = ${DATA_DIR}/asm3.db
dbfs_store = database
disk_cache = /tmp/asm_disk_cache
session_secure_cookie = true
EOF

cd /app/src
exec python3 main.py
