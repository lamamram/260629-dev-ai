alias gst='git status'
__git_complete gst _git_status
alias gci='git commit'
__git_complete gci _git_commit
alias gco='git checkout'
__git_complete gco _git_checkout
alias gadd='git add .'
alias push='git push'
__git_complete push _git_push
alias pull='git pull'
__git_complete pull _git_pull
alias fetch='git fetch'
__git_complete fetch _git_fetch
alias gbr='git branch'
__git_complete gbr _git_branch

alias ll="ls -al"
alias dexit_oc="docker compose exec -it opencode bash"
alias dim="docker images"
alias dps="docker ps"
alias dpsa="docker ps -a"

ac() {
  if [ $# -ne 1 ]; then
    echo "bad message !"
  elif [ $# -eq 1 ]; then gadd && gci -m "$1"; fi
}

create_gpg_key() {
  read -s -p "Enter your password: " password
  gpg2 --quick-gen-key --batch --passphrase $password $1
}

create_pass_store() {
  ID=$(gpg2 --list-keys | grep -oE "[A-F0-9]+$")
  pass init $ID >/dev/null
}

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

delete_pass_password() {
  pass rm -f $1
}

delete_pass_store() {
  rm -rf ~/.password-store
}

delete_gpg_secret_key() {
  gpg2 --batch --yes --delete-secret-keys $1
}

delete_gpg_key() {
  gpg2 --batch --yes --delete-keys $1
}

get_val() {
  printenv | grep -E "^$1=.*" | sed -n -e 's/^$1=\(.*\)/\1/p'
}

#alias oc='11-oc-bootstrap.sh'
alias='docker compose run --rm opencode'
