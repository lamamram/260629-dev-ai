#!/bin/bash

sudo apt-get -qq update
sudo apt-get -yq install gnupg2 pass


create_gpg_key() {
  read -s -p "Enter your password: " password
  gpg2 --quick-gen-key --batch --passphrase $password $1
}

create_pass_store() {
  ID=$(gpg2 --list-keys | grep -oE "[A-F0-9]+$")
  pass init $ID > /dev/null
}


insert_pass_password() {
  if [ -f $1 ]; then
    pass insert -m $2 <<< "$(cat $1)"
    if [ $? -eq 0 ]; then
      rm -f $1
    fi
  fi
}

retrieve_pass_password() {
  echo "$(pass $1)"
}

delete_pass_password() {
  pass rm -f $1
}

delete_pass_store() {
  rm -rf ~/.password-store
}

delete_gpg_key() {
  gpg2 --batch --yes --delete-secret-keys $1
}



