set shell=/bin/bash
let mapleader = "\<space>"

" ============================================================
" # Plugins
" ============================================================

call plug#begin()
" Gui enhancements
Plug 'vim-airline/vim-airline'
Plug '~/.config/nvim/mine-airline' " Load custom airline themes
Plug 'vim-airline/vim-airline-themes'
" Wait for 0.5.0
"Plug 'wfxr/minimap.vim', {'do': ':!cargo install --locked code-minimap'}

Plug 'machakann/vim-highlightedyank'
Plug 'preservim/nerdtree'
Plug 'mbbill/undotree'

" Fuzzy finding
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf.vim'

" Multicursor
Plug 'terryma/vim-multiple-cursors'

" Git
Plug 'tpope/vim-fugitive'

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
Plug 'farmergreg/vim-lastplace'

" Browser Integration
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
call plug#end()

" Coc-extensions
let g:coc_global_extensions = ['coc-rust-analyzer', 'coc-json', 'coc-git']

" Rust
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0

let g:rust_recommended_style = 0

" Markdown
let g:vim_markdown_folding_disabled = 1

" ============================================================
" # Editor settings
" ============================================================

" General
set number relativenumber
set linebreak
set showbreak=
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
set undodir=~/.config/nvim/vimdid
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

" ============================================================
" # Colorscheme
" ============================================================

runtime! colors.vim

" ============================================================
" # Keyboard shortcuts
" ============================================================

" # coc.nvim
" ------------------------------------------------------------

" Completion
inoremap <silent><expr> <c-space> coc#refresh()

" Code action
nmap <leader>a <Plug>(coc-codeaction-selected)

" Quick fix
nmap <leader>f <Plug>(coc-fix-current)

" GoTo Code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> g[  <Plug>(coc-diagnostic-prev)
nmap <silent> g]  <Plug>(coc-diagnostic-next)

" Floating window scrolling
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1, 8) : "\<C-d>"
  nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0, 8) : "\<C-u>"
  inoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, 8)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, 8)\<cr>" : "\<Left>"
endif


" RefactorRename
nmap <silent> <leader>r <Plug>(coc-rename)

" Documentation
nnoremap <silent> K :call <SID>show_documentation()<cr>
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
      \ pumvisible() ? "\<c-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<c-p>" : "\<c-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make enter select the first completion item
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"


" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" coc-git
nmap g{ <Plug>(coc-git-prevchunk)
nmap g} <Plug>(coc-git-nextchunk)
nmap gs <plug>(coc-git-chunkinfo)
nmap gu :CocCommand git.chunkUndo<cr>

" # YouCompleteMe
" ------------------------------------------------------------

" Documentation
"nnoremap <silent> K :YcmCompleter GetDoc<cr>

" GoTo Code navigation
"nmap <silent> gd :YcmCompleter GoTo
"nmap <silent> gy :YcmCompleter GoToType
"nmap <silent> gi :YcmCompleter GoToImplementation
"nmap <silent> gr :YcmCompleter GoToReference
"nmap <silent> g: <Plug>(coc-diagnostic-prev)
"nmap <silent> g. <Plug>(coc-diagnostic-next)

" RefactorRename
"nmap <silent> <leader>r :YcmCompleter RefactorRename

" # FZF
" ------------------------------------------------------------

" Search
noremap <leader>s :Rg<cr>

" Open hotkeys
map <a-p>      :Files<cr>
map <c-p>      :GFiles<cr>
nmap <leader>; :Buffers<cr>

" # Multicursor
" ------------------------------------------------------------
let g:multi_cursor_use_default_mapping = 0

let g:multi_cursor_start_word_key   = '<a-j>'
let g:multi_cursor_next_key         = '<a-j>'
let g:multi_cursor_skip_key         = '<c-a-j>'
let g:multi_cursor_prev_key         = '<a-k>'
let g:multi_cursor_quit_key         = '<esc>'

" # Undotree
" ------------------------------------------------------------

" Toggle
nnoremap <f5> :UndotreeToggle<cr>:UndotreeFocus<cr>

" # General
" ------------------------------------------------------------

" Resize
nmap <c-left> :vertical resize -5<cr>
nmap <c-down> :resize +5<cr>
nmap <c-up> :resize -5<cr>
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


" Firenvim config
if exists('g:started_by_firenvim')
  set guifont=Monospace:h8
endif
