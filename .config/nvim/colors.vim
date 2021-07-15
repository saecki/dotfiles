" Colorscheme
if filereadable(expand("~/.config/alacritty/colors/current/minelight.yml"))
    colorscheme minelight
elseif filereadable(expand("~/.config/alacritty/colors/current/minedark.yml"))
    colorscheme minedark
endif

" Lsp Diagnostics
sign define LspDiagnosticsSignError       text=E texthl=LspDiagnosticsSignError       linehl= numhl=
sign define LspDiagnosticsSignWarning     text=W texthl=LspDiagnosticsSignWarning     linehl= numhl=
sign define LspDiagnosticsSignHint        text=H texthl=LspDiagnosticsSignHint        linehl= numhl=
sign define LspDiagnosticsSignInformation text=I texthl=LspDiagnosticsSignInformation linehl= numhl=

" Airline
if filereadable(expand("~/.config/alacritty/colors/current/minelight.yml"))
    let g:airline_theme = 'minelight'
elseif filereadable(expand("~/.config/alacritty/colors/current/minedark.yml"))
    let g:airline_theme = 'minedark'
endif

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

let g:airline_mode_map = {
    \ '__' : '--',
    \ 'n'  : 'N',
    \ 'i'  : 'I',
    \ 'R'  : 'R',
    \ 'c'  : 'C',
    \ 'v'  : 'V',
    \ 'V'  : 'V-L',
    \ '' : 'V-B',
    \ 's'  : 'S',
    \ 'S'  : 'S-L',
    \ '' : 'S-B',
    \ 't'  : 'T',
    \ }
