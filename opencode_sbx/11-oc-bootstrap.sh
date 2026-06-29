#!/bin/bash

insert_pass_password() {
  if [ -f $1 ]; then
    pass insert -m $2 <<<"$(cat $1)"
    if [ $? -eq 0 ]; then
      rm -f $1
    fi
  fi
}

retrieve_pass_password() {
  echo "$(pass $1)"
}

secret_path=~/.local/share/opencode/auth.json

ls -al $secret_path

if [ -f "$secret_path" ]; then
  insert_pass_password $secret_path oc/tui.lan
else
  retrieve_pass_password oc/tui.lan >$secret_path
  docker compose run --rm opencode
fi
