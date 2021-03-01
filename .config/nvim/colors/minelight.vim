" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:    Ron Aaron <ron@ronware.org>
" Last Change:    2003 May 02

hi clear
set background=light
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "minelight"

highlight SignColumn    ctermbg=none
highlight LineNr        ctermfg=214
highlight CursorLineNr  ctermfg=214
highlight CursorColumn  ctermbg=189
highlight Pmenu         ctermfg=0     ctermbg=255
highlight PmenuSel      ctermfg=15    ctermbg=240   cterm=bold
highlight PmenuSBar                   ctermbg=253
highlight PmenuThumb                  ctermbg=248
highlight Visual                      ctermbg=253

highlight Comment       ctermfg=8
highlight Constant      ctermfg=162                 cterm=none
highlight Identifier    ctermfg=72                  cterm=bold
highlight Statement     ctermfg=214
highlight PreProc       ctermfg=33
highlight Type          ctermfg=43
highlight Special       ctermfg=8
highlight Error                       ctermbg=9
highlight Todo          ctermfg=40    ctermbg=none  cterm=bold
highlight Directory     ctermfg=2
highlight StatusLine    ctermfg=11    ctermbg=12    cterm=none
highlight Normal                                    cterm=none
highlight Search                      ctermbg=11

