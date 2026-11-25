# env
if ! { command -v midclt >/dev/null 2>&1 && [[ -f /data/freenas-v1.db ]]; }; then
    if env -i PATH="$PATH" locale -a 2>/dev/null |
        grep -qiE '^en_US\.utf-?8$'; then
        export LANG=en_US.UTF-8
        export LC_MESSAGES=en_US.UTF-8
        export LC_ALL=en_US.UTF-8
    fi
fi

export FZF_DEFAULT_OPTS='--smart-case --bind=bspace:backward-delete-char/eof'
export ZSHZ_CASE=smart

# p10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# fzf
if ! command -v fzf &> /dev/null; then
    export PATH="$HOME/.fzf/bin:$PATH"
fi

# antidote
source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh
antidote load

# fzf keybindings
source <(fzf --zsh)

# === fzf-tab + completion settings ===
# Disable default completion menu (important for fzf-tab)
zstyle ':completion:*' menu no
# Show group descriptions
zstyle ':completion:*:descriptions' format '[%d]'
# Enable colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# Case-insensitive matching and partial completion (e.g., for filenames)
zstyle ':completion:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'
# No prefix in query fiels
zstyle ':fzf-tab:*' query-string ''
# === #

# Hide internal functions
zstyle ':completion:*:-command-:*:commands' ignored-patterns \
  'autocomplete:*' \
  'azhw:*' \
  'compfiles' \
  'functions' \
  'zle-*' \
  '_*'

# Optional nice previews
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always -la $realpath 2>/dev/null || ls -la $realpath'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word 2>/dev/null'

# Ctrl+Backspace bind to delete previous word
bindkey '^H' backward-kill-word

source "$HOME/.zshrc_utils.zsh"

if [[ -f "$HOME/.zshrc_entrypoint.zsh" ]]; then
  source "$HOME/.zshrc_entrypoint.zsh"
fi

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
