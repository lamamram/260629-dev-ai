#!/usr/bin/env bash

set -euo pipefail

if [ -f /work/.env.local ]; then
  echo -e "\n" | npx varlock init --agent
  npx varlock load --agent
  rm -f /work/.env.local
fi
exec "$@"
