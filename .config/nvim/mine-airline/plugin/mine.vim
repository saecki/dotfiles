if $DARKMODE == "true"
    echo "minedark"
    let g:airline_theme = 'minedark'
else
    echo "minelight"
    let g:airline_theme = 'minelight'
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
