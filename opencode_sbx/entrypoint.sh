#!/usr/bin/env bash

set -euo pipefail

if [ ! -d .beads ]; then
    # alimente AGENTS.md
    # injecte les commandes /beads:*
    bd init
fi

if [ -f /work/.env.local ] && [ ! -f /work/.env.schema ]; then
 echo -e "\n" | npx varlock init --agent
 ### on ne peut pas l'automatiser pour le moment
 #echo -e "\n\n" | npx varlock encrypt --file .env.local
fi
exec "$@"
