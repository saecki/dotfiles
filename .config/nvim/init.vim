"General
set number relativenumber
set linebreak
set showbreak=+++
set textwidth=0
set wrapmargin=0
set showmatch
 
set hlsearch
set smartcase
set ignorecase
set incsearch
 
set autoindent
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4

"Advanced
set ruler
 
set undolevels=1000
set backspace=indent,eol,start

"vim-plug
call plug#begin()
Plug 'Valloric/YouCompleteMe'
Plug 'rust-lang/rust.vim'
call plug#end()
