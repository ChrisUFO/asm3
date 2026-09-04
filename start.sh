#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${ASM3_DATA_DIR:-/data}"
mkdir -p "$DATA_DIR" /tmp/asm_disk_cache

BASE_URL="${ASM3_BASE_URL:-}"
if [ -z "$BASE_URL" ] && [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
  BASE_URL="https://${RAILWAY_PUBLIC_DOMAIN}"
fi

DB_CONFIG="db_type = SQLITE
db_name = ${DATA_DIR}/asm3.db"
if [ "${ASM3_DB_TYPE:-SQLITE}" = "POSTGRESQL" ]; then
  DB_CONFIG="db_type = POSTGRESQL
db_host = ${ASM3_DB_HOST}
db_port = ${ASM3_DB_PORT:-5432}
db_username = ${ASM3_DB_USER}
db_password = ${ASM3_DB_PASSWORD}
db_name = ${ASM3_DB_NAME}"
fi

cat > "$ASM3_CONF" <<EOF
base_url = ${BASE_URL:-http://localhost:5000}
service_url = ${BASE_URL:-http://localhost:5000}/service
locale = ${ASM3_LOCALE:-en}
timezone = ${ASM3_TIMEZONE:-0}
log_location = stderr
deployment_type = wsgi
${DB_CONFIG}
dbfs_store = database
disk_cache = /tmp/asm_disk_cache
session_secure_cookie = true
EOF

cd /app/src
exec python3 main.py
