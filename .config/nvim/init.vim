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

" Resize
nmap <silent> <c-left>  :vertical resize -5<cr>
nmap <silent> <c-down>  :resize          +5<cr>
nmap <silent> <c-up>    :resize          -5<cr>
nmap <silent> <c-right> :vertical resize +5<cr>

" Quick save
nmap <silent> <leader>w :w<cr>

" Text navigation
nnoremap j gj
nnoremap k gk

" stop searching
vnoremap <silent> <s-h> :nohlsearch<cr>
nnoremap <silent> <s-h> :nohlsearch<cr>

" Copy to system clipboard
vnoremap <c-c> "+y
" Paste system clipboard
inoremap <c-v> <c-r>+

" Toggle between buffers
nnoremap <leader><leader> <c-^>

" I don't need your help
map <F1> <esc>
imap <F1> <esc>

" Highlight trailing whitespace
let g:matchtrailingwhitespace = 0
function ToggleTrailingWhitespace()
    if g:matchtrailingwhitespace == 0
        let g:matchtrailingwhitespace = 1
        call matchadd('Error', '\s\+$', 10, 992387)
    else
        let g:matchtrailingwhitespace = 0
        call matchdelete(992387)
    endif
endfunction

nnoremap <silent> <leader>h :call ToggleTrailingWhitespace()<cr>

" Highlight yanked text
autocmd TextYankPost * silent! lua vim.highlight.on_yank { timeout = 250 }

" ============================================================
" # Plugins
" ============================================================

call plug#begin()
" Gui enhancements
Plug 'hoob3rt/lualine.nvim'

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
Plug 'nvim-lua/plenary.nvim' " Dependency for gitsigns
Plug 'lewis6991/gitsigns.nvim'

" Lsp
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'

Plug 'folke/trouble.nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/playground'
Plug 'romgrk/nvim-treesitter-context'

" Language tools
Plug 'teal-language/vim-teal'
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
lua require('colors').apply()


" ============================================================
" # Plugin config
" ============================================================

" # rust.vim
" ------------------------------------------------------------
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_recommended_style = 0

" # trouble.nvim
" ------------------------------------------------------------
lua << EOF
    require('trouble').setup {
        position = "right",
        icons = false,
        fold_open = "▼",
        fold_closed = "▶",
        use_lsp_diagnostic_signs = true,
    }
EOF

" Toggle
nnoremap <silent> <f7> :TroubleToggle<cr>

" # gitsigns.nvim
" ------------------------------------------------------------
lua require('config.gitsigns').setup()

" # nvim-compe
" ------------------------------------------------------------
lua require('config.compe').setup()

" # lspconfig
" ------------------------------------------------------------
lua require('config.lsp').setup()

" Diagnostics
sign define LspDiagnosticsSignError       text=  texthl=LspDiagnosticsSignError       linehl= numhl=
sign define LspDiagnosticsSignWarning     text=  texthl=LspDiagnosticsSignWarning     linehl= numhl=
sign define LspDiagnosticsSignHint        text=H  texthl=LspDiagnosticsSignHint        linehl= numhl=
sign define LspDiagnosticsSignInformation text=I  texthl=LspDiagnosticsSignInformation linehl= numhl=

" Highlight occurences
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

nnoremap <leader>c :TSContextToggle<cr>
autocmd CursorMoved * silent :TSContextDisable

" # FZF
" ------------------------------------------------------------
let g:fzf_layout = { 'window' : { 'width': 0.98, 'height': 0.8, 'highlight': 'Normal' } }
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" Search
noremap <silent> <leader>s :Rg<cr>

" Open hotkeys
map  <silent> <a-p>     :Files<cr>
map  <silent> <c-p>     :GFiles<cr>
nmap <silent> <leader>; :Buffers<cr>

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
nnoremap <silent> <f6> :NERDTreeToggle<cr>

" # undotree
" ------------------------------------------------------------

" Toggle
nnoremap <silent> <f5> :UndotreeToggle<cr>:UndotreeFocus<cr>

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

