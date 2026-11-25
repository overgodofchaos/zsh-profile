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

# Aliases
alias awgup='awg-quick up'
alias awgdn='awg-quick down'
alias wgup='wg-quick up'
alias wdn='wg-quick down'