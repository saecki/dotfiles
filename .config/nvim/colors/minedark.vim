" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:    Ron Aaron <ron@ronware.org>
" Last Change:    2003 May 02

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "minedark"

highlight SignColumn    ctermbg=none
highlight CursorColumn  ctermbg=60
highlight Pmenu         ctermfg=15    ctermbg=235
highlight PmenuSel      ctermfg=0     ctermbg=248   cterm=bold
highlight PmenuSBar                   ctermbg=237
highlight PmenuThumb                  ctermbg=242
highlight Visual                      ctermbg=240

highlight Comment     ctermfg=7
highlight Constant    ctermfg=13                  cterm=none 
highlight Identifier  ctermfg=14
highlight Statement   ctermfg=11
highlight PreProc     ctermfg=12
highlight Type        ctermfg=10
highlight Special     ctermfg=7
highlight Error                     ctermbg=9
highlight Todo        ctermfg=10    ctermbg=none  cterm=bold
highlight Directory   ctermfg=2
highlight StatusLine  ctermfg=11    ctermbg=12    cterm=none
highlight Normal                                  cterm=none
highlight Search                    ctermbg=3

