"General
set number relativenumber
set linebreak
set showbreak=..
set textwidth=0
set wrapmargin=0
set showmatch
 
set autoindent
set shiftwidth=4
set smartindent
set expandtab
set softtabstop=4
set backspace=indent,eol,start
 
set undolevels=1000

"Search
set hlsearch
set smartcase
set ignorecase
set incsearch

"Spell checking
set spelllang=en_us,de_de,es_es

"Copy pasta
vnoremap <C-c> "+y

"Plugins
call plug#begin()
"Theme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Tools
Plug 'Valloric/YouCompleteMe'
Plug 'preservim/nerdtree'
Plug '907th/vim-auto-save'
"Build Tools
Plug 'igankevich/mesonic'
"Languages
Plug 'rust-lang/rust.vim'
Plug 'udalov/kotlin-vim'
Plug 'dhruvasagar/vim-table-mode'
call plug#end()

"NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
