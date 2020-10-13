# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/tobi/.oh-my-zsh"

# Setting history file
HISTFILE=$HOME/.cache/zsh/.zsh_history

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git cargo rustup)

source $ZSH/oh-my-zsh.sh

# User configuration # export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# ===================================================
# Miscellaneous
# ===================================================

# vi-mode
# bindkey -v
# export KEYTIMEOUT=1

# colors
eval "$(dircolors)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# bash insulter
if [ -f $HOME/.local/etc/bash.command-not-found ]; then
    . $HOME/.local/etc/bash.command-not-found
fi

# thefuck
eval $(thefuck --alias)

# p10k theme
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh

# ===================================================
# Environment variables
# ===================================================

export launchterm="/usr/local/bin/launch-alacritty"

# ===================================================
# Aliases
# ===================================================

# Programs
alias v='$EDITOR'
alias vo='file=$(fzf-tmux); if [ "$file" != "" ]; then; $EDITOR -o $file; fi'
alias vs='nvim -c Rg'
alias vp='nvim -c Files'
alias vf='vifm'
alias fz='fzf-tmux'
alias fs='rg --column --heading --line-number . | fzf-tmux'
alias music='update-cmus-playlist;cmus'

alias music-dl='youtube-dl -f 140 --output "%(title)s.%(ext)s"'

# Config
alias cfz='$EDITOR ~/.config/zsh/.zshrc'
alias cfnv='$EDITOR ~/.config/nvim/init.vim'
alias cfal='$EDITOR ~/.config/alacritty/alacritty.yml'
alias cftm='$EDITOR ~/.tmux.conf'

# Cd
alias cdp='cd ~/Documents/projects'
alias cdn='cd ~/Documents/notable/notes'
alias countryroads='cd ~'

# Git
alias ggc='git gc --prune=now --aggressive'
alias gdu="git rev-list --objects --all \
         | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
         | sed -n 's/^blob //p' \
         | sort --numeric-sort --key=2 \
         | cut -c 1-12,41- \
         | $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest"

# Dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias dotfiles-pull='git --git-dir=$HOME/.dotfiles --work-tree=$HOME pull origin master'
alias dotfiles-forcepull='git --git-dir=$HOME/.dotfiles --work-tree=$HOME stash save;\
                          git --git-dir=$HOME/.dotfiles --work-tree=$HOME stash drop;\
                          git --git-dir=$HOME/.dotfiles --work-tree=$HOME pull origin master'
alias dotfiles-push='git --git-dir=$HOME/.dotfiles --work-tree=$HOME add -u;\
                     git --git-dir=$HOME/.dotfiles --work-tree=$HOME commit -m update;\
                     git --git-dir=$HOME/.dotfiles --work-tree=$HOME push origin master'
alias dotfiles-forcepush='git --git-dir=$HOME/.dotfiles --work-tree=$HOME add -u;\
                          git --git-dir=$HOME/.dotfiles --work-tree=$HOME commit --amend;\
                          git --git-dir=$HOME/.dotfiles --work-tree=$HOME push origin master -f'
# Stuff
alias stuff='git --git-dir=$HOME/.stuff --work-tree=$HOME'
alias stuff-pull='git --git-dir=$HOME/.stuff --work-tree=$HOME pull origin master'
alias stuff-forcepull='git --git-dir=$HOME/.stuff --work-tree=$HOME stash save;\
                       git --git-dir=$HOME/.stuff --work-tree=$HOME stash drop;\
                       git --git-dir=$HOME/.stuff --work-tree=$HOME pull origin master'
alias stuff-push='git --git-dir=$HOME/.stuff --work-tree=$HOME add -u;\
                  git --git-dir=$HOME/.stuff --work-tree=$HOME commit -m update;\
                  git --git-dir=$HOME/.stuff --work-tree=$HOME push origin master'
alias stuff-forcepush='git --git-dir=$HOME/.stuff --work-tree=$HOME add -u;\
                       git --git-dir=$HOME/.stuff --work-tree=$HOME commit --amend;\
                       git --git-dir=$HOME/.stuff --work-tree=$HOME push origin master -f'

# Notes
alias notes-pull='git -C $HOME/Documents/notable pull origin master'
alias notes-push='git -C $HOME/Documents/notable add .;\
                  git -C $HOME/Documents/notable commit -m "update";\
                  git -C $HOME/Documents/notable push origin master'
alias notes-diff='git -C $HOME/Documents/notable diff HEAD'

# ls
alias l='lsd -lAh'
alias l.='lsd -d .*'
alias la='lsd -lah'
alias ll='lsd -lh'
alias ls='lsd'
