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

" Set coc.nvim floating window background color to something sane
highlight CocFloating ctermbg=0

" ===================================================
" # Editor settings
" ===================================================

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

" Miscellaneous
set updatetime=300
set cmdheight=2
set background=dark
set signcolumn=yes

" ===================================================
" # Keyboard shortcuts
" ===================================================

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" GoTo Code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Documentation
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Text navigation
nnoremap j gj
nnoremap k gk

" Completion
inoremap <silent><expr> <C-Space> coc#refresh()

" Search
noremap <Leader>s :Rg 
noremap <Leader>f :Rg<CR>

" Open hotkeys
map <C-p> :Files<CR>
map <C-l> :GFiles<CR>
nmap <Leader>; :Buffers<CR>

" Quick save
nmap <Leader>w :w<CR>

" Ctrl+c copies to system clipboard
vnoremap <C-c> "+y

" Ctrl+h to stop searching
vnoremap <C-h> :nohlsearch<CR>
nnoremap <C-h> :nohlsearch<CR>

" Toggle between buffers
nnoremap <Leader><Leader> <C-^>

" I don't need your help
map <F1> <Esc>
imap <F1> <Esc>

