filetype plugin indent on
syntax on

call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ervandew/supertab'
Plug 'honza/vim-snippets'
Plug 'raimondi/delimitmate'
Plug 'scrooloose/syntastic'
Plug 'sheerun/vim-polyglot'
Plug 'sirver/ultisnips'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
Plug 'fsharp/vim-fsharp', {
      \ 'for': 'fsharp',
      \ 'do':  'make fsautocomplete',
      \}
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
Plug 'vimwiki/vimwiki'

call plug#end()

set number
set ruler
set textwidth=80
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
set copyindent
set expandtab
set shiftround

set wildmenu
set wildignore=*.o,*~,*.pyc

set splitbelow
set splitright

autocmd FileType haskell setlocal shiftwidth=2 softtabstop=2 tabstop=2
autocmd BufWritePre *[js|cpp|py|html|css|hs] %s/\s\+$//e

command Bd bp|bd #
command Vsp vsp|bp

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Custom colorscheme
" colorscheme slate
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

" Syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_python_checkers = ['pep8', 'pyflakes', 'python']

" Vimwiki
let g:vimwiki_list = [{
            \'path': '~/Documents/Wiki/vimwiki',
            \'path_html': '~/Documents/Wiki/vimwiki_html',
            \'template_path': '~/Documents/Wiki/templates',
            \'auto_export': 1,
            \'auto_tags': 1}]
