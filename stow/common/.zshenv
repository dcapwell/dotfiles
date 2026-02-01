# Override the `cd` command to be `z`
ZOXIDE_CMD_OVERRIDE=cd


# Set the default them to be the fork of robbyrussell
ZSH_THEME="robbyrussell-plusplus"

# In most cases use nvim, unless coming in from SSH
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Default to UTF-8.  This is the default on mac, but good practice to make sure nothing falls through
export LANG=en_US.UTF-8

export DOTFILE_HOME="/Users/dcapwell/src/github/dotfiles"

. "$HOME/.cargo/env"

source <(capri --zsh-completions 2>/dev/null)
source <(isc --zsh-completions 2>/dev/null)
source <(acc --zsh-completions 2>/dev/null)

# Currently opencode doesn't let me set this via config...
export OPENCODE_EXPERIMENTAL_BASH_DEFAULT_TIMEOUT_MS=600000

