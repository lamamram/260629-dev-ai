#!/usr/bin/env bash

set -euo pipefail

if [[ -f /work/uv.lock ]]; then
  echo "[entrypoint] uv sync --frozen (venv: ${UV_PROJECT_ENVIRONMENT})"
  uv sync --frozen --project /work
elif [[ -f /work/pyproject.toml ]]; then
  echo "[entrypoint] uv sync (pas de lock - génération)"
  uv sync --project /work
fi

git config --global --add safe.directory /work

# if [ -f /work/.env.local ] && [ ! -f /work/.env.schema ]; then
#   # echo -e "\n" | npx varlock init --agent
#   varlock init --agent
#   # npx varlock load --agent
#   varlock load --agent
#   # echo -e "\n" | npx varlock encrypt --file /work/.env.local
#   varlock encrypt --file .env.local
# fi
exec "$@"
