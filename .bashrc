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

# Ls
alias l.='exa -d .*'
alias l='exa -lah'
alias la='ls -ah --git-ignore'
alias lg='ls -lah --git-ignore'
alias ll='exa -lh'
alias ls='exa'
alias tree='exa --tree --sort type'

