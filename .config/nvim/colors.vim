if filereadable(expand("~/.config/alacritty/colors/current/minelight.yml"))
    colorscheme minelight
elseif filereadable(expand("~/.config/alacritty/colors/current/minedark.yml"))
    colorscheme minedark
endif
