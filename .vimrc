set nocompatible
filetype plugin indent on
syntax on

" Vim plug setup
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mileszs/ack.vim'
Plug 'scrooloose/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'sheerun/vim-polyglot'

call plug#end()

set number
set ruler
set textwidth=80
set colorcolumn=+1
set showcmd
set cursorline
set wildmenu
set lazyredraw
set showmatch
set noswapfile
set noerrorbells
set laststatus=2
set mouse=a
set history=1000
set backspace=2
set nohlsearch
set incsearch
set scrolloff=10
set clipboard=unnamed
set confirm

" Intendation
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set copyindent
set shiftround

autocmd FileType python setlocal shiftwidth=4 softtabstop=4 tabstop=4
autocmd FileType haskell setlocal shiftwidth=2 softtabstop=2 tabstop=2

set wildignore=*.o,*~,*.pyc

" iTerm cursor changes
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" Remove trailing whitespace on save
autocmd BufWritePre *[js|cpp|py|html|css] %s/\s\+$//e

" Gitgutter
let g:gitgutter_realtime = 1

" Crypto
set cryptmethod=blowfish2

" Splits
set splitbelow
set splitright

" File explorer
let g:netrw_liststyle=3
let g:netrw_altv=1
let g:netrw_preview=1
let g:netrw_liststyle=3

" Airline preferences
set hidden
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_python_checkers = ['pep8', 'pyflakes', 'python']

" CtrlP
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_max_files = 0
let g:ctrlp_custom_ignore = '\v[\/](node_modules|dist)|(\.(swp|git|svn))$'

" Color scheme
set t_Co=256
highlight Normal ctermbg=black
highlight LineNr ctermfg=darkgray
highlight ColorColumn ctermbg=none cterm=underline
highlight VertSplit cterm=none ctermfg=darkgray

