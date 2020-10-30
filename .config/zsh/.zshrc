# ===================================================
# Settings
# ===================================================

# Syntax highlighting
# !! has to be souced before manydots-magic
source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 

# Completion
fpath=("$ZDOTDIR/functions" $fpath)
autoload -Uz compinit; compinit
autoload -Uz manydots-magic; manydots-magic
_comp_options+=(globdots)

# Completion style
eval "$(dircolors)"
zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# History
setopt HIST_SAVE_NO_DUPS
setopt menucomplete
setopt autocd

# Vi-mode
bindkey -v
export KEYTIMEOUT=1
zmodload zsh/complist

bindkey -v '^?' backward-delete-char

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Edit command in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd e edit-command-line

# ===================================================
# Miscellaneous
# ===================================================

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# p10k theme
source $ZDOTDIR/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh

# thefuck
eval $(thefuck --alias)

# bash insulter
if [ -f $HOME/.local/etc/bash.command-not-found ]; then
    . $HOME/.local/etc/bash.command-not-found
fi

# ===================================================
# Aliases
# ===================================================

# Reloas config
alias reload='source $ZDOTDIR/.zshrc'

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
alias ga='git add'
alias gbl='git branch --list'
alias gc='git commit'
alias gcb='git checkout -b'
alias gch='git checkout'
alias gd='gid diff'
alias gdh='gid diff HEAD'
alias ggpull='git pull origin "$(git branch --show-current)"'
alias ggpush='git push origin "$(git branch --show-current)"'
alias glg='git log --graph --stat'
alias glo='git log --oneline'
alias gs='git status'

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
alias l='exa -lah'
alias l.='exa -d .*'
alias lg='ls -lah --git-ignore'
alias ll='exa -lh'
alias ls='exa'

