" ============================================================
" # Editor settings
" ============================================================

set shell=/bin/bash
let mapleader = "\<space>"

" Visuals
set signcolumn=yes:2
set number relativenumber
set linebreak
let &showbreak = '⮡   '
set wrap
set scrolloff=3
set textwidth=0
set wrapmargin=0
set fillchars=vert:│
set cmdheight=1
set background=dark

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

" Completion
set completeopt=menuone,noselect,noinsert
set shortmess+=c

" Splits
set splitright
set splitbelow

" Undo
set undolevels=1000
set undodir=~/.local/share/nvim/undo
set undofile
set noswapfile

" Spell checking
set spelllang=en,de,es,nl

" Miscellaneous
set updatetime=300
set mouse=a
set hidden


" ============================================================
" # Key mappings
" ============================================================

" Text navigation
nnoremap j gj
nnoremap k gk

" Copy to the end of the line
nnoremap Y y$

" Resize
nmap <silent> <c-left>  :vertical resize -5<cr>
nmap <silent> <c-down>  :resize +5<cr>
nmap <silent> <c-up>    :resize -5<cr>
nmap <silent> <c-right> :vertical resize +5<cr>

" Quick save
nmap <silent> <leader>w :w<cr>

" stop searching
vnoremap <silent> <s-h> :nohlsearch<cr>
nnoremap <silent> <s-h> :nohlsearch<cr>

" Copy paste
vnoremap <c-c> "+y
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
    else
        let g:matchtrailingwhitespace = 0
    endif
    call HighlightTrailingWhitespace()
endfunction

function HighlightTrailingWhitespace()
    if g:matchtrailingwhitespace == 1
        let w:trailingwhitespaceid = matchadd('Error', '\s\+$')
    else
        call matchdelete(w:trailingwhitespaceid)
    endif
endfunction
autocmd WinEnter * silent! call HighlightTrailingWhitespace()

nnoremap <silent> <leader>hw :call ToggleTrailingWhitespace()<cr>

" Highlight yanked text
autocmd TextYankPost * silent! lua vim.highlight.on_yank { timeout = 250 }


" ============================================================
" # Plugins
" ============================================================

call plug#begin()
" Dependencies
Plug 'nvim-lua/plenary.nvim'

" Gui enhancements
Plug 'hoob3rt/lualine.nvim'

" Utilities
Plug 'preservim/nerdtree'
Plug 'mbbill/undotree'

" Multicursor
Plug 'terryma/vim-multiple-cursors'

" Fuzzy finding
Plug 'airblade/vim-rooter'
Plug 'nvim-telescope/telescope.nvim'

" Lists
Plug '~/Projects/trouble.nvim'
Plug 'folke/todo-comments.nvim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'

" Lsp
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/lsp-status.nvim'

" Completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/vim-vsnip'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/playground'

" Language tools
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'teal-language/vim-teal'
Plug 'rust-lang/rust.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug '~/Projects/crates.nvim'

" Miscellaneous
Plug 'farmergreg/vim-lastplace'
Plug '907th/vim-auto-save'

" Discord rich presence
Plug 'andweeb/presence.nvim'

" Browser Integration
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
call plug#end()

" ============================================================
" # Config
" ============================================================

lua require('globals')
lua require('mappings').setup()
lua require('colors').setup()


" ============================================================
" # Plugin config
" ============================================================

" # vim-markdown
" ------------------------------------------------------------
let g:vim_markdown_folding_level = 6
let g:vim_markdown_folding_style_pythonic = 6

" # rust.vim
" ------------------------------------------------------------
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_recommended_style = 0

" # crates.nvim
" ------------------------------------------------------------
nnoremap <silent> <leader>vt :lua require('crates').toggle()<cr>
nnoremap <silent> <leader>vr :lua require('crates').reload()<cr>
nnoremap <silent> <leader>vu :lua require('crates').update_crate()<cr>
vnoremap <silent> <leader>vu :lua require('crates').update_crates()<cr>
nnoremap <silent> <leader>va :lua require('crates').update_all_crates()<cr>
nnoremap <silent> <leader>vU :lua require('crates').upgrade_crate()<cr>
vnoremap <silent> <leader>vU :lua require('crates').upgrade_crates()<cr>
nnoremap <silent> <leader>vA :lua require('crates').upgrade_all_crates()<cr>

" # gitsigns.nvim
" ------------------------------------------------------------
lua require('config.gitsigns').setup()

" # nvim-cmp
" ------------------------------------------------------------
lua require('config.cmp').setup()

" # lspconfig
" ------------------------------------------------------------
lua require('config.lsp').setup()

" Diagnostics
sign define LspDiagnosticsSignError       text=  texthl=LspDiagnosticsSignError       linehl= numhl=
sign define LspDiagnosticsSignWarning     text=  texthl=LspDiagnosticsSignWarning     linehl= numhl=
sign define LspDiagnosticsSignHint        text=  texthl=LspDiagnosticsSignHint        linehl= numhl=
sign define LspDiagnosticsSignInformation text=  texthl=LspDiagnosticsSignInformation linehl= numhl=

" Highlight occurences
augroup LspOccurences
    autocmd!
    autocmd CursorHold  * silent lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved * silent lua vim.lsp.buf.clear_references()
augroup END

" # trouble.nvim
" ------------------------------------------------------------
lua require('config.trouble').setup()

" # todo-comments.nvim
" ------------------------------------------------------------
lua require('config.todo-comments').setup()

" # lsp_extensions
" ------------------------------------------------------------

" Show inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require('lsp_extensions').inlay_hints{ prefix = '', highlight = "NonText", enabled = {"TypeHint", "ChainingHint"} }

" # nvim-treesitter
" ------------------------------------------------------------
lua require('config.treesitter').setup()

" # telescope.nvim
" ------------------------------------------------------------
lua require('config.telescope').setup()

nmap <silent> <leader>s  :lua require('telescope.builtin').live_grep()<cr>
nmap <silent> <a-p>      :lua require('telescope.builtin').find_files { no_ignore = true }<cr>
nmap <silent> <c-p>      :lua require('telescope.builtin').find_files()<cr>
nmap <silent> <leader>;  :lua require('telescope.builtin').buffers()<cr>
nmap <silent> <leader>fh :lua require('telescope.builtin').help_tags()<cr>
nmap <silent> <leader>fc :lua require('telescope.builtin').commands()<cr>
nmap <silent> <leader>fm :lua require('telescope.builtin').keymaps()<cr>
nmap <silent> <leader>fi :lua require('telescope.builtin').highlights()<cr>

" # vim-multiple-cursors
" ------------------------------------------------------------
let g:multi_cursor_use_default_mapping = 0

let g:multi_cursor_start_word_key   = '<a-j>'
let g:multi_cursor_next_key         = '<a-j>'
let g:multi_cursor_skip_key         = '<a-s-j>'
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

