" ============================================================
" # Editor settings
" ============================================================
set shell=/bin/bash
let mapleader = "\<space>"

" General
set number relativenumber
set linebreak
let &showbreak = '⮡   '
set wrap
set textwidth=0
set wrapmargin=0
set fillchars=vert:│
set mouse=a

" Indentation
set autoindent
set smartindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Search
set incsearch
set inccommand=nosplit
set ignorecase
set smartcase
set hlsearch
set showmatch
set gdefault

" Spell checking
set spelllang=en_us,de_de,es_es

" Completion
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
set completeopt=menuone,noinsert
" Avoid showing extra messages when using completion
set shortmess+=c

" Undo
set undolevels=1000
set undodir=~/.local/share/nvim/undo
set undofile

" Splits
set splitright
set splitbelow

" Miscellaneous
set updatetime=300
set cmdheight=1
set background=dark
if has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

" # Key mappings
" ------------------------------------------------------------

" Esc
set timeoutlen=500
inoremap jj <esc>

" Resize
nmap <c-left>  :vertical resize -5<cr>
nmap <c-down>  :resize          +5<cr>
nmap <c-up>    :resize          -5<cr>
nmap <c-right> :vertical resize +5<cr>

" Quick save
nmap <leader>w :w<cr>

" Text navigation
nnoremap j gj
nnoremap k gk

" Ctrl+h to stop searching
vnoremap <s-h> :nohlsearch<cr>
nnoremap <s-h> :nohlsearch<cr>

" Ctrl+c copies to system clipboard
vnoremap <c-c> "+y
" Ctrl+v pastes system clipboard
inoremap <c-v> <c-r>+

" Toggle between buffers
nnoremap <leader><leader> <c-^>

" I don't need your help
map <F1> <esc>
imap <F1> <esc>

" ============================================================
" # Plugins
" ============================================================

call plug#begin()
" Gui enhancements
Plug 'hoob3rt/lualine.nvim'
Plug 'machakann/vim-highlightedyank'

" Utilities
Plug 'preservim/nerdtree'
Plug 'mbbill/undotree'

" Fuzzy finding
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf.vim'

" Multicursor
Plug 'terryma/vim-multiple-cursors'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Semantic Language support
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'

" Syntactic Language support
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

" Language tools
Plug 'rust-lang/rust.vim'
Plug 'dhruvasagar/vim-table-mode'

" Miscellaneous
Plug 'farmergreg/vim-lastplace'
Plug '907th/vim-auto-save'

" Discord rich presence
Plug 'andweeb/presence.nvim'

" Browser Integration
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
call plug#end()


" # Colorscheme
" ------------------------------------------------------------
lua require('style').apply()


" ============================================================
" # Plugin config
" ============================================================

" # vim-gitgutter
" ------------------------------------------------------------
let g:gitgutter_diff_base = 'HEAD'
let g:gitgutter_sign_priority = 1

nmap g{ <Plug>(GitGutterPrevHunk)
nmap g} <Plug>(GitGutterNextHunk)
nmap gu <Plug>(GitGutterUndoHunk)
nmap gs <Plug>(GitGutterPreviewHunk)

" # rust.vim
" ------------------------------------------------------------
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_recommended_style = 0

" # nvim-compe
" ------------------------------------------------------------
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.resolve_timeout = 800
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:false
let g:compe.source.luasnip = v:false
let g:compe.source.emoji = v:false

inoremap <silent><expr> <c-space> compe#complete()
inoremap <silent><expr> <cr>      compe#confirm('<cr>')
inoremap <silent><expr> <c-e>     compe#close('<c-e>')
inoremap <silent><expr> <c-u>     compe#scroll({ 'delta': +4 }) " TODO fix
inoremap <silent><expr> <c-d>     compe#scroll({ 'delta': -4 }) " TODO fix

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <tab>   pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

" # lspconfig
" ------------------------------------------------------------

lua require('config.lsp').setup()

" Diagnostics
sign define LspDiagnosticsSignError       text=  texthl=LspDiagnosticsSignError       linehl= numhl=
sign define LspDiagnosticsSignWarning     text=  texthl=LspDiagnosticsSignWarning     linehl= numhl=
sign define LspDiagnosticsSignHint        text=H  texthl=LspDiagnosticsSignHint        linehl= numhl=
sign define LspDiagnosticsSignInformation text=I  texthl=LspDiagnosticsSignInformation linehl= numhl=

" Highlight references
autocmd CursorHold  * silent lua vim.lsp.buf.document_highlight()
autocmd CursorMoved * silent lua vim.lsp.buf.clear_references()

" Show info popup
nnoremap <silent> K :call <SID>show_documentation()<cr>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    lua vim.lsp.buf.hover()
  endif
endfunction

" Show diagnostic popup
nnoremap <silent> <c-k> <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>

" Code actions
nnoremap <silent> <leader>a <cmd>lua vim.lsp.buf.code_action()<cr>
vnoremap <silent> <leader>a <cmd>lua vim.lsp.buf.code_action()<cr>
nnoremap <silent> <leader>r <cmd>lua vim.lsp.buf.rename()<cr>

" Goto actions
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<cr>
nnoremap <silent> gy <cmd>lua vim.lsp.buf.type_definition()<cr>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<cr>
nnoremap <silent> gw <cmd>lua vim.lsp.buf.document_symbol()<cr>
nnoremap <silent> gW <cmd>lua vim.lsp.buf.workspace_symbol()<cr>
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<cr>

" signature help
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<cr>

" # lsp_extensions
" ------------------------------------------------------------

" Show inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require('lsp_extensions').inlay_hints{ prefix = '', highlight = "NonText", enabled = {"TypeHint", "ChainingHint"} }

" # nvim-treesitter
" ------------------------------------------------------------
lua require('config.treesitter').setup()

" # FZF
" ------------------------------------------------------------
let g:fzf_layout = { 'window' : { 'width': 0.98, 'height': 0.8, 'highlight': 'Normal' } }
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" Search
noremap <leader>s :Rg<cr>

" Open hotkeys
map  <a-p>     :Files<cr>
map  <c-p>     :GFiles<cr>
nmap <leader>; :Buffers<cr>

" # Multicursor
" ------------------------------------------------------------
let g:multi_cursor_use_default_mapping = 0

let g:multi_cursor_start_word_key   = '<a-j>'
let g:multi_cursor_next_key         = '<a-j>'
let g:multi_cursor_skip_key         = '<c-a-j>'
let g:multi_cursor_prev_key         = '<a-k>'
let g:multi_cursor_quit_key         = '<esc>'

" # nerdtree
" ------------------------------------------------------------

" Toggle
nnoremap <f6> :NERDTreeToggle<cr>

" # undotree
" ------------------------------------------------------------

" Toggle
nnoremap <f5> :UndotreeToggle<cr>:UndotreeFocus<cr>

" # firenvim
" ------------------------------------------------------------
let g:firenvim_config = {
    \ 'globalSettings': {
        \ 'alt': 'all',
    \  },
    \ 'localSettings': {
        \ '.*': {
            \ 'cmdline': 'neovim',
            \ 'content': 'text',
            \ 'priority': 0,
            \ 'selector': 'textarea',
            \ 'takeover': 'never',
        \ },
    \ }
\ }

if exists('g:started_by_firenvim')
  set guifont=Monospace:h8
endif

