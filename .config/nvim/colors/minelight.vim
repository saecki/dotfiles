" Vim color file
"  _     _       _     _
" | |   (_) __ _| |__ | |_
" | |   | |/ _` | '_ \| __|
" | |___| | (_| | | | | |_
" |_____|_|\__, |_| |_|\__|
"          |___/

hi clear
set background=light
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "minelight"

highlight SignColumn                     ctermbg=none
highlight LineNr           ctermfg=208
highlight CursorLineNr     ctermfg=208
highlight CursorColumn                   ctermbg=189
highlight Pmenu            ctermfg=0     ctermbg=255
highlight PmenuSel         ctermfg=15    ctermbg=240   cterm=bold
highlight PmenuSBar                      ctermbg=253
highlight PmenuThumb                     ctermbg=248
highlight Visual                         ctermbg=253
highlight VertSplit        none

highlight Comment          ctermfg=8
highlight Constant         ctermfg=168                 cterm=none
highlight Identifier       ctermfg=71                  cterm=bold
highlight Statement        ctermfg=208
highlight PreProc          ctermfg=33
highlight Type             ctermfg=43
highlight Special          ctermfg=98
highlight Error                          ctermbg=9
highlight Todo             ctermfg=40    ctermbg=none  cterm=bold
highlight Directory        ctermfg=2
highlight StatusLine       ctermfg=11    ctermbg=12    cterm=none
highlight Normal                                       cterm=none
highlight Search           ctermfg=255   ctermbg=208

highlight diffAdded        ctermfg=2
highlight diffRemoved      ctermfg=1
highlight GitGutterAdd     ctermfg=0     ctermbg=193
highlight GitGutterChange  ctermfg=0     ctermbg=146
highlight GitGutterDelete  ctermfg=0     ctermbg=209


highlight LspReferenceText               ctermbg=189
highlight LspReferenceRead               ctermbg=189
highlight LspReferenceWrite              ctermbg=189

highlight LspDiagnosticsVirtualTextError     ctermfg=1
highlight LspDiagnosticsVirtualTextWarning   ctermfg=3
highlight LspDiagnosticsVirtualTextHint      ctermfg=12
highlight LspDiagnosticsVirtualTextInfo      ctermfg=12

highlight LspDiagnosticsSignError     cterm=bold  ctermfg=1
highlight LspDiagnosticsSignWarning   cterm=bold  ctermfg=3
highlight LspDiagnosticsSignHint      cterm=bold  ctermfg=12
highlight LspDiagnosticsSignInfo      cterm=bold  ctermfg=12

highlight LspDiagnosticsFloatingError     ctermfg=1
highlight LspDiagnosticsFloatingWarning   ctermfg=3
highlight LspDiagnosticsFloatingHint      ctermfg=12
highlight LspDiagnosticsFloatingInfo      ctermfg=12

highlight LspDiagnosticsUnderlineError     cterm=undercurl  ctermfg=1   gui=undercurl
highlight LspDiagnosticsUnderlineWarning   cterm=undercurl  ctermfg=3   gui=undercurl
highlight LspDiagnosticsUnderlineHint      cterm=undercurl  ctermfg=12  gui=undercurl
highlight LspDiagnosticsUnderlineInfo      cterm=undercurl  ctermfg=12  gui=undercurl
