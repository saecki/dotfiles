" Vim color file
"  ____             _
" |  _ \  __ _ _ __| | __
" | | | |/ _` | '__| |/ /
" | |_| | (_| | |  |   <
" |____/ \__,_|_|  |_|\_\
"

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "minedark"

highlight SignColumn                     ctermbg=none
highlight LineNr           ctermfg=11
highlight CursorLineNr     ctermfg=11
highlight CursorColumn                   ctermbg=60
highlight Pmenu            ctermfg=15    ctermbg=235
highlight PmenuSel         ctermfg=0     ctermbg=248   cterm=bold
highlight PmenuSBar                      ctermbg=237
highlight PmenuThumb                     ctermbg=242
highlight Visual                         ctermbg=240
highlight VertSplit        none

highlight Comment          ctermfg=7
highlight Constant         ctermfg=13                  cterm=none
highlight Identifier       ctermfg=14                  cterm=bold
highlight Statement        ctermfg=11
highlight PreProc          ctermfg=39
highlight Type             ctermfg=79
highlight Special          ctermfg=147
highlight Error                          ctermbg=9
highlight Todo             ctermfg=154   ctermbg=none  cterm=bold
highlight Directory        ctermfg=2
highlight StatusLine       ctermfg=11    ctermbg=12    cterm=none
highlight Normal                                       cterm=none
highlight Search           ctermfg=0     ctermbg=11

highlight diffAdded        ctermfg=2
highlight diffRemoved      ctermfg=1
highlight GitGutterAdd     ctermfg=15    ctermbg=65
highlight GitGutterChange  ctermfg=15    ctermbg=60
highlight GitGutterDelete  ctermfg=15    ctermbg=131


highlight LspReferenceText               ctermbg=60
highlight LspReferenceRead               ctermbg=60
highlight LspReferenceWrite              ctermbg=60

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

highlight LspDiagnosticsUnderlineError     cterm=undercurl  ctermfg=1
highlight LspDiagnosticsUnderlineWarning   cterm=undercurl  ctermfg=3
highlight LspDiagnosticsUnderlineHint      cterm=undercurl  ctermfg=12
highlight LspDiagnosticsUnderlineInfo      cterm=undercurl  ctermfg=12
