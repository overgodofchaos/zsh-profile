# Functions
xpsread() {
    if [ -z "$1" ]; then
        echo "Usage: xpsread <filename>.xps"
        return 1
    fi

    unzip -l "$1" 2>/dev/null | grep -o 'Documents/.*\.fpage' | sort -V | while read -r page; do
        unzip -p "$1" "$page" 2>/dev/null | grep -oP 'UnicodeString="\K[^"]+'
    done
}

wgkeygen() {
  if [[ -z "$1" ]]; then
    echo "Usage: wgkeygen NAME" >&2
    return 1
  fi

  local name="$1"
  wg genkey | tee "${name}.pri" | wg pubkey > "${name}.pub"
}

awgkeygen() {
  if [[ -z "$1" ]]; then
    echo "Usage: awgkeygen NAME" >&2
    return 1
  fi

  local name="$1"
  awg genkey | tee "${name}.pri" | awg pubkey > "${name}.pub"
}

wgre() {
  if [[ -z "$1" ]]; then
    echo "Usage: wgre NAME" >&2
    return 1
  fi

  local name="$1"
  wg-quick down "${name}" && wg-quick up "${name}"
}

awgre() {
  if [[ -z "$1" ]]; then
    echo "Usage: awgre NAME" >&2
    return 1
  fi

  local name="$1"
  awg-quick down "${name}" && awg-quick up "${name}"
}

ssh-host-fingerprints() {
  for key in /etc/ssh/ssh_host_*_key.pub; do
    ssh-keygen -lf "$key"
  done
}

rmdir-progress() {
  if (( $# != 1 )); then
    print -u2 "Usage: rmdir_progress DIRECTORY"
    return 2
  fi

  local target=$1
  if [[ ! -d "$target" || -L "$target" ]]; then
    print -u2 "Error: target must be a directory, not a file or symlink."
    return 1
  fi

  if [[ "$target" == "/" || "$target" == "." || "$target" == ".." ]]; then
    print -u2 "Error: refusing to remove this directory."
    return 1
  fi

  local count
  count=$(find "$target" -print | wc -l | tr -d '[:space:]')
  rm -rfv -- "$target" | pv -l -s "$count" > /dev/null
}

# Aliases
alias awgup='awg-quick up'
alias awgdn='awg-quick down'
alias wgup='wg-quick up'
alias wdn='wg-quick down'
