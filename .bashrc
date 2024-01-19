# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Starship prompt
if [ -x "$(which starship)" ]; then
    eval "$(starship init bash)"
else
    echo "starship prompt is not installed"
fi

LS_COLORS=''

# Editor
export EDITOR='nvim'
alias v='$EDITOR'

# Ls
alias l.='eza -d .*'
alias l='eza -lah --git'
alias la='ls -ah --git --git-ignore'
alias lg='ls -lah --git --git-ignore'
alias ll='eza -lh --git'
alias ls='eza --git'
alias tree='eza --tree --sort type'
alias tree-git='eza --tree --sort type --git-ignore'
