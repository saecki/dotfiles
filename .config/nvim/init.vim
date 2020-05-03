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
set backspace=indent,eol,start
 
set undolevels=1000

"Spell checking
set spelllang=en_us,de_de,es_es

"Plugins
call plug#begin()
"Theme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Tools
Plug 'Valloric/YouCompleteMe'
Plug 'rust-lang/rust.vim'
call plug#end()
