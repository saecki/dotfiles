# ===================================================
# Environment variables
# ===================================================

# Zsh
export HISTFILE=$HOME/.cache/zsh/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# Editor
export EDITOR='nvim'

# Manpager
export MANPAGER='nvim +Man!'

# ===================================================
# Settings
# ===================================================

# Syntax highlighting
# !! has to be souced before manydots-magic
source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Auto suggestions
source "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Completion
fpath=("$ZDOTDIR/functions" "/usr/share/zsh/vendor-completions" $fpath)
autoload -Uz compinit; compinit
# TODO: fix autosuggestions breaking manydots magic
# autoload -Uz manydots-magic; manydots-magic
_comp_options+=(globdots)

# Completion style
eval "$(dircolors)"
zstyle ':completion:*:*:*:default' menu yes select
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:approximate"*' max-errors 5 numeric
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# History
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_VERIFY

# Miscellaneous
setopt menucomplete
setopt autocd
setopt ignore_eof

# Vi-mode
bindkey -v
export KEYTIMEOUT=1
zmodload zsh/complist

# Make underscore work as expected
bindkey -M vicmd '_' beginning-of-line
# Make backspace work as expected then appending
bindkey -v '^?' backward-delete-char

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

bindkey -M vicmd '^U' up-history
bindkey -M vicmd '^D' down-history
bindkey -M vicmd '^P' history-beginning-search-backward
bindkey -M vicmd '^N' history-beginning-search-forward
bindkey -M viins '^P' history-beginning-search-backward
bindkey -M viins '^N' history-beginning-search-forward

bindkey -M viins '^ ' autosuggest-accept

# Edit command in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd '^F' edit-command-line
bindkey -M viins '^F' edit-command-line

# ===================================================
# Miscellaneous
# ===================================================

# Change cursor shape for different vi modes.
zle-keymap-select() {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]] then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] ||
        [[ ${KEYMAP} == viins ]] ||
        [[ ${KEYMAP} = '' ]] ||
        [[ $1 = 'beam' ]]
    then
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

# the fuck
eval "$(thefuck --alias)"

# ===================================================
# Aliases
# ===================================================

# Reloas config
alias reload='source $ZDOTDIR/.zshrc'

alias chmox='chmod +x'

# ls
alias l.='exa -d .*'
alias l='exa -lah --git'
alias la='ls -ah --git --git-ignore'
alias lg='ls -lah --git --git-ignore'
alias ll='exa -lh --git'
alias ls='exa --git'
alias tree='exa --tree --sort type'
alias tree-git='exa --tree --sort type --git-ignore'

# Editor
alias v='$EDITOR'
alias vo='file=$(fzf-tmux); if [ "$file" != "" ]; then; $EDITOR -o $file; fi'

# Cd
alias cdp='cd ~/Projects'
alias cdn='cd ~/Documents/notes'

alias cdz='cd ~/.config/zsh'
alias cdnv='cd ~/.config/nvim'
alias cdnp='cd ~/.local/share/nvim/lazy'
alias cdal='cd ~/.config/alacritty'
alias cdkt='cd ~/.config/kitty'
alias cdtm='cd ~/.config/tmux'
alias cdst='cd ~/.config/starship'
alias cdzt='cd ~/.config/zathura'

# Config
alias cfz='(cd ~/.config/zsh && $EDITOR ~/.config/zsh/.zshrc)'
alias cfnv='(cd ~/.config/nvim && $EDITOR ~/.config/nvim/init.lua)'
alias cfiv='(cd ~/.config/ideavim && $EDITOR ~/.config/ideavim/ideavimrc)'
alias cfal='(cd ~/.config/alacritty && $EDITOR ~/.config/alacritty/alacritty.yml.in)'
alias cfkt='(cd ~/.config/kitty && $EDITOR ~/.config/kitty/kitty.conf)'
alias cftm='(cd ~/.config/tmux && $EDITOR ~/.tmux.conf)'
alias cfst='(cd ~/.config/starship && $EDITOR ~/.config/starship/starship.toml.in)'
alias cfzt='(cd ~/.config/zathura && $EDITOR ~/.config/zathura/zathurarc)'

# Git
alias ga='git add'
alias gb='git branch'
alias gbD='git branch -D'
alias gbd='git branch -d'
alias gbl='git branch -a'
alias gbm='git branch --move'
alias gbu='git branch --set-upstream-to'
alias gc='git commit --verbose'
alias gca='git commit --verbose --amend'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcl='git clone --recursive'
alias gd='git diff'
alias gdh='git diff HEAD'
alias gdhh='git diff HEAD^'
alias gdhhh='git diff HEAD^^'
alias gdhhhh='git diff HEAD^^^'
alias gdi='git diff-index --stat'
alias gf='git fetch'
alias gfp='git fetch --prune'
alias ggpull='git pull origin "$(git branch --show-current)"'
alias ggpush='git push origin "$(git branch --show-current)"'
alias gl='git log'
alias glg='git log --graph'
alias glo='git log --oneline'
alias glog='git log --oneline --graph'
alias gls='git log --stat'
alias glsg='git log --stat --graph'
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gpl='git pull'
alias gps='git push'
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias gri='git rebase --interactive'
alias gris='git rebase --interactive --autosquash'
alias grt='git restore'
alias grts='git restore --staged'
alias grs='git reset'
alias grsh='git reset --hard'
alias grss='git reset --soft'
alias grsu='git reset --'
alias gs='git status'
alias gsh='git show'
alias gsd='git stash drop'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gss='git stash push'

alias ggc='git reflog expire --expire=now --all && git gc --prune=now --aggressive'
alias gdu="git rev-list --objects --all \
         | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
         | sed -n 's/^blob //p' \
         | sort --numeric-sort --key=2 \
         | cut -c 1-12,41- \
         | $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest"

ghcl() {
    gcl "git@github.com:$1"
}

# Bare repos
alias dotfiles="git --git-dir=$HOME/.config/dotfiles --work-tree=$HOME"
alias stuff="git --git-dir=$HOME/.config/stuff --work-tree=$HOME"
alias csgo-config="git --git-dir $HOME/.config/csgo-config --work-tree '$HOME/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/csgo/cfg'"

# Music
update-cmus-lib() {
    cmus-remote -l -c ~/Music
}
update-cmus-playlist() {
    playlist-localizer \
        -m ~/Music \
        -o ~/.config/cmus/playlists
}
alias music='update-cmus-playlist; cmus'

# Delete impatient.nvim luacache file
alias clean-lua-cache='rm ~/.cache/nvim/luacache'

# Systemd reboot
alias sysreboot='systemctl reboot -i'

# 255 Colors
print-color-table() {
    for i in {0..255}; do
        print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'};
    done
}

# Youtube-dl
music-dl() {
    yt-dlp --get-id "$@" | xargs -P 8 -i yt-dlp -xf 140 -o "%(title)s.%(ext)s" "https://youtube.com/watch?v={}"
}

dotfiles-fix() {
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"
    git clone ~/.config/dotfiles
    cd dotfiles
    git remote add upstream git@github.com:saecki/dotfiles
    git fetch upstream main
    git branch main -u upstream/main
}

# Clean latex files
latex-clean() {
    rm -f *.aux
    rm -f *.dvi
    rm -f *.fdb_latexmk
    rm -f *.fls
    rm -f *.log
    rm -f *.xdv
    rm -f *.synctex.gz
    rm -f *.pdf
}

# Starship prompt
if [ -x "$(which starship)" ]; then
    eval "$(starship init zsh)"
else
    echo "starship prompt is not installed"
fi
