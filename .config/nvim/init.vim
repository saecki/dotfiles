set shell=/bin/bash
let mapleader = "\<Space>"

" ===================================================
" # Plugins
" ===================================================

call plug#begin()
" Gui enhancements
Plug 'vim-airline/vim-airline'
Plug 'machakann/vim-highlightedyank'
Plug 'preservim/nerdtree'

" Fuzzy finding
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Language support
Plug 'neoclide/coc.nvim', {'branch': 'release'} 

Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'udalov/kotlin-vim'
Plug 'igankevich/mesonic'
Plug 'plasticboy/vim-markdown'

" Miscellaneous
Plug 'dhruvasagar/vim-table-mode'
Plug '907th/vim-auto-save'
call plug#end()

" ===================================================
" # Editor settings
" ===================================================

" Colors
set background=dark

" General
set number relativenumber
set linebreak
set showbreak=..
set textwidth=0
set wrapmargin=0
set undolevels=1000

" Indentation
set autoindent
set smartindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set backspace=indent,eol,start

" Search
set incsearch
set ignorecase
set smartcase
set hlsearch
set showmatch
set gdefault

" Spell checking
set spelllang=en_us,de_de,es_es

" Permanent undo
set undodir=~/.vimdid
set undofile

" Splits
set splitright
set splitbelow

" ===================================================
" # Keyboard shortcuts
" ===================================================

" Search
noremap <Leader>s :Rg

" Open hotkeys
map <C-p> :Files<CR>
nmap <Leader>; :Buffers<CR>

" Quick save
nmap <Leader>w :w<CR>

" Ctrl+c copies to system clipboard
vnoremap <C-c> "+y

" Ctrl+h to stop searching
vnoremap <C-h> :nohlsearch<cr>
nnoremap <C-h> :nohlsearch<cr>

" Toggle between buffers
nnoremap <Leader><Leader> <C-^>

" I don't need your help
map <F1> <Esc>
imap <F1> <Esc>

