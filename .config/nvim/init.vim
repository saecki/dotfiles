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
Plug 'mbbill/undotree'

" Fuzzy finding
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf.vim'

" Multicursor
Plug 'terryma/vim-multiple-cursors'

" Semantic Language support
Plug 'neoclide/coc.nvim', {'branch': 'release'} 
"Plug 'ycm-core/YouCompleteMe'

" Syntactic Language support
Plug 'rust-lang/rust.vim'
Plug 'udalov/kotlin-vim'
Plug 'igankevich/mesonic'
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'plasticboy/vim-markdown'

" Miscellaneous
Plug 'dhruvasagar/vim-table-mode'
Plug '907th/vim-auto-save'
call plug#end()

" Set coc.nvim floating window background color to something reasonable
highlight CocFloating ctermbg=0

" Rust
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0

" Markdown
let g:vim_markdown_folding_disabled = 1

" ===================================================
" # Editor settings
" ===================================================

" General
set number relativenumber
set linebreak
set showbreak=..
set textwidth=0
set wrapmargin=0

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

" Undo
set undolevels=1000
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

" # coc.nvim
" ---------------------------------------------------

" Completion
inoremap <silent><expr> <C-Space> coc#refresh()

" Code action
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Quick fix
nmap <leader>f  <Plug>(coc-fix-current)

" GoTo Code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> g: <Plug>(coc-diagnostic-prev)
nmap <silent> g. <Plug>(coc-diagnostic-next)

" RefactorRename
nmap <silent> <Leader>r <Plug>(coc-rename)

" Documentation
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

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

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" # YouCompleteMe
" ---------------------------------------------------

" Documentation
"nnoremap <silent> K :YcmCompleter GetDoc<CR>

" GoTo Code navigation
"nmap <silent> gd :YcmCompleter GoTo
"nmap <silent> gy :YcmCompleter GoToType
"nmap <silent> gi :YcmCompleter GoToImplementation
"nmap <silent> gr :YcmCompleter GoToReference
"nmap <silent> g: <Plug>(coc-diagnostic-prev)
"nmap <silent> g. <Plug>(coc-diagnostic-next)

" RefactorRename
"nmap <silent> <Leader>r :YcmCompleter RefactorRename

" # FZF
" ---------------------------------------------------

" Search
noremap <Leader>s :Rg<CR>

" Open hotkeys
map <C-p> :Files<CR>
map <C-l> :GFiles<CR>
nmap <Leader>; :Buffers<CR>

" # Multicursor
" ---------------------------------------------------

let g:multi_cursor_start_word_key      = '<A-j>'
let g:multi_cursor_start_key           = 'g<A-j>'
let g:multi_cursor_next_key            = '<A-j>'
let g:multi_cursor_prev_key            = '<A-J>'

" # Undotree
" ---------------------------------------------------

" Toggle
nnoremap <F5> :UndotreeToggle<CR>:UndotreeFocus<CR>

" # General
" ---------------------------------------------------

" Quick save
nmap <Leader>w :w<CR>

" Text navigation
nnoremap j gj
nnoremap k gk

" Ctrl+h to stop searching
vnoremap <C-h> :nohlsearch<CR>
nnoremap <C-h> :nohlsearch<CR>

" Ctrl+c copies to system clipboard
vnoremap <C-c> "+y

" Toggle between buffers
nnoremap <Leader><Leader> <C-^>

" I don't need your help
map <F1> <Esc>
imap <F1> <Esc>

