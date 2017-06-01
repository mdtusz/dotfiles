filetype plugin indent on
syntax on

call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ervandew/supertab'
Plug 'mattn/emmet-vim'
Plug 'raimondi/delimitmate'
Plug 'sbdchd/neoformat'
Plug 'sheerun/vim-polyglot'
Plug 'sirtaj/vim-openscad'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'valloric/youcompleteme'
Plug 'vim-airline/vim-airline'
Plug 'vimwiki/vimwiki'
Plug 'w0rp/ale'

call plug#end()

set updatetime=100

set number
set ruler
set textwidth=0
set colorcolumn=+1
set laststatus=2
set showcmd
set cursorline
set lazyredraw
set showmatch
set noswapfile
set noerrorbells
set mouse=a
set history=1000
set backspace=2
set scrolloff=10
set clipboard=unnamed
set confirm
set hidden

set nohlsearch
set incsearch

set relativenumber
set number

set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set copyindent
set expandtab
set shiftround

set wildmenu
set wildignore=*.o,*~,*.pyc

set splitbelow
set splitright


autocmd FileType haskell,javascript setlocal shiftwidth=2 softtabstop=2 tabstop=2
autocmd BufWritePre *[js|cpp|py|html|css|hs] %s/\s\+$//e

augroup fmt
  autocmd!
  autocmd BufWritePre * Neoformat
augroup END

augroup wrapper
    autocmd BufEnter * highlight OverLength ctermbg=blue ctermfg=black
    autocmd BufEnter * match OverLength /\%81v.*/
augroup END

command Bd bp|bd #
command Vsp vsp|bp

let mapleader = "\<Space>"
map <Leader><TAB> <C-w><C-w>

inoremap <S-CR> <Esc>O
imap ✠ <S-CR>


" Custom colorscheme
set background=light
highlight LineNr ctermfg=darkgray
highlight ColorColumn ctermbg=none ctermfg=darkgray cterm=underline
highlight VertSplit cterm=none ctermfg=darkgray
highlight MatchParen ctermbg=blue ctermfg=black

" File Explorer
let g:netrw_liststyle = 3
let g:netrw_list_hide = '.*\.swp$,\~$,\.orig$,\.pyc$'

" CtrlP
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_max_files = 0
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_custom_ignore = '\v[\/](node_modules|dist)|(\.(swp|git|svn))$'

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" Vimwiki
let g:vimwiki_list = [{
            \'path': '~/Documents/Wiki/vimwiki',
            \'path_html': '~/Documents/Wiki/vimwiki_html',
            \'template_path': '~/Documents/Wiki/templates',
            \'auto_export': 1,
            \'auto_tags': 1}]

" Gitgutter
let g:gitgutter_realtime = 1
let g:gitgutter_async = 1

" Neoformat
let g:neoformat_enabled_html = []
let g:neoformat_python_yapf = {
    \ 'exe': 'yapf',
    \ 'args': ['--style', 'google']
    \ }
let g:neoformat_enabled_python = ['yapf']
let g:neoformat_enabled_javascript = ['prettier']

" Ale
let g:ale_sign_column_always = 1
let g:ale_linters = {
    \ 'javascript': ['eslint'],
    \ 'python': ['flake8'],
    \ 'html': [],
    \}

" YCM
let g:ycm_autoclose_preview_window_after_completion = 1

" DelimitMate
let g:delimitMate_expand_cr = 2

