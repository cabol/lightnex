#!/usr/bin/env bash
set -euo pipefail
echo "🧹 Removing docker volumes & data dirs..."
docker compose -f docker/docker-compose.yml --env-file docker/.env down -v || true
rm -rf docker/data/*
echo "✓ Cleaned."
