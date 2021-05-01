" Vim color file

hi clear
set background=light
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "minelight"

highlight SignColumn    ctermbg=none
highlight LineNr        ctermfg=208
highlight CursorLineNr  ctermfg=208
highlight CursorColumn  ctermbg=189
highlight Pmenu         ctermfg=0     ctermbg=255
highlight PmenuSel      ctermfg=15    ctermbg=240   cterm=bold
highlight PmenuSBar                   ctermbg=253
highlight PmenuThumb                  ctermbg=248
highlight Visual                      ctermbg=253

highlight Comment       ctermfg=8
highlight Constant      ctermfg=168                 cterm=none
highlight Identifier    ctermfg=71                  cterm=bold
highlight Statement     ctermfg=208
highlight PreProc       ctermfg=33
highlight Type          ctermfg=43
highlight Special       ctermfg=98
highlight Error                       ctermbg=9
highlight Todo          ctermfg=40    ctermbg=none  cterm=bold
highlight Directory     ctermfg=2
highlight StatusLine    ctermfg=11    ctermbg=12    cterm=none
highlight Normal                                    cterm=none
highlight Search        ctermfg=255   ctermbg=208

highlight diffAdded                   ctermfg=2
highlight diffRemoved                 ctermfg=1

highlight DiffAdd       ctermbg=193   ctermfg=0
highlight DiffChange    ctermbg=146   ctermfg=0
highlight DiffRemove    ctermbg=209   ctermfg=0
highlight DiffDelete    ctermbg=209   ctermfg=0

