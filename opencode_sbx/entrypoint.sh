#!/usr/bin/env bash

set -euo pipefail

if [ ! -d .beads ]; then
    bd init
fi

if [ -f /work/.env.local ] && [ ! -f /work/.env.schema ]; then
 echo -e "\n" | npx varlock init --agent
 #echo -e "\n\n" | npx varlock encrypt --file .env.local
fi
exec "$@"
