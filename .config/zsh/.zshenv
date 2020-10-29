# ===================================================
# Environment variables
# ===================================================

# Zsh
export HISTFILE=$HOME/.cache/zsh/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# Terminal launch script
export launchterm="/usr/local/bin/launch-alacritty"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi
