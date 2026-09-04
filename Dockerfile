FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    ASM3_CONF=/app/asm3.conf

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Generate the version module that `make` normally creates (asm3/__version__.py)
RUN { echo "#!/usr/bin/env python3"; \
      echo "VERSION = \"$(cat VERSION) [$(date)]\""; \
      echo "BUILD = \"$(date +%m%d%H%M%S)\""; } > src/asm3/__version__.py

RUN mkdir -p /data /tmp/asm_disk_cache

CMD ["bash", "/app/start.sh"]
