" Vim color file

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "minedark"

highlight SignColumn    ctermbg=none
highlight LineNr        ctermfg=11
highlight CursorLineNr  ctermfg=11
highlight CursorColumn  ctermbg=60
highlight Pmenu         ctermfg=15    ctermbg=235
highlight PmenuSel      ctermfg=0     ctermbg=248   cterm=bold
highlight PmenuSBar                   ctermbg=237
highlight PmenuThumb                  ctermbg=242
highlight Visual                      ctermbg=240

highlight Comment       ctermfg=7
highlight Constant      ctermfg=13                  cterm=none
highlight Identifier    ctermfg=14                  cterm=bold
highlight Statement     ctermfg=11
highlight PreProc       ctermfg=39
highlight Type          ctermfg=79
highlight Special       ctermfg=147
highlight Error                       ctermbg=9
highlight Todo          ctermfg=154   ctermbg=none  cterm=bold
highlight Directory     ctermfg=2
highlight StatusLine    ctermfg=11    ctermbg=12    cterm=none
highlight Normal                                    cterm=none
highlight Search        ctermfg=0     ctermbg=11

highlight diffAdded                   ctermfg=2
highlight diffRemoved                 ctermfg=1

highlight DiffAdd       ctermbg=65    ctermfg=15
highlight DiffChange    ctermbg=60    ctermfg=15
highlight DiffRemove    ctermbg=131   ctermfg=15
highlight DiffDelete    ctermbg=131   ctermfg=15

