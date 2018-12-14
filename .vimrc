filetype plugin indent on
syntax on

call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ervandew/supertab'
Plug 'fisadev/vim-isort'
Plug 'honza/vim-snippets'
Plug 'majutsushi/tagbar'
Plug 'mattn/emmet-vim'
Plug 'raimondi/delimitmate'
Plug 'sheerun/vim-polyglot'
Plug 'sirtaj/vim-openscad'
Plug 'sirver/ultisnips'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
Plug 'vimwiki/vimwiki'
Plug 'wlangstroth/vim-racket'
Plug 'w0rp/ale'
Plug 'ryanoasis/vim-devicons'

call plug#end()

set encoding=UTF-8
set updatetime=100
set lazyredraw
set noswapfile
set noerrorbells

set number relativenumber
set laststatus=2
set mouse=a
set history=1000
set backspace=2
set scrolloff=10
set clipboard=unnamed
set confirm
set hidden

set showmatch
set nohlsearch
set incsearch

set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set copyindent
set expandtab
set shiftround

set wildmenu
set wildignore=*.o,*~,*.pyc,__pycache__/

set splitbelow
set splitright

autocmd FileType haskell,javascript,cpp setlocal shiftwidth=2 softtabstop=2 tabstop=2
autocmd BufWritePre *[js|cpp|py|html|css|hs] %s/\s\+$//e

augroup wrapper
    autocmd BufEnter * highlight OverLength ctermbg=darkblue ctermfg=white
    autocmd BufEnter * match OverLength /\%88v.*/
augroup END

command Bd bp|bd #
command Vsp vsp|bp
command Wq wq
command W w


map <Leader><TAB> <C-w>h
map <Leader><Leader> <C-w><C-w>

" Adds shift-enter for newline above
inoremap <S-CR> <Esc>O
imap ✠ <S-CR>

" Custom colorscheme
set background=light
highlight LineNr term=none cterm=none ctermfg=237
highlight ColorColumn ctermbg=none ctermfg=darkgray cterm=underline
highlight VertSplit cterm=none ctermfg=black
highlight MatchParen ctermbg=blue ctermfg=black
highlight SpellBad ctermbg=red ctermfg=white

" File Explorer
let g:netrw_liststyle = 3
let g:netrw_list_hide = '.*\.swp$,\~$,\.orig$,\.pyc$'

" CtrlP
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_max_files = 0
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_custom_ignore = '\v[\/](__pycache__|venv|node_modules|dist|target)|(\.(swp|git|svn|pyc))$'

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
let g:gitgutter_sign_added = '|+'
let g:gitgutter_sign_removed = '|-'
let g:gitgutter_sign_modified = '|~'
let g:gitgutter_max_signs = 1000

" Ale
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0

let g:ale_python_flake8_auto_pipenv= 1
let g:ale_python_flake8_options = "--max-line-length=88"
let g:ale_python_mypy_auto_pipenv = 1
let g:ale_python_mypy_options = "--ignore-missing-imports"
let g:ale_linters = {
    \ 'javascript': [],
    \ 'python': ['flake8', 'mypy'],
    \ 'cpp': ['clang-format'],
    \ 'rust': ['rls'],
    \ 'html': [],
    \}

let g:ale_javascript_prettier_options = '--single-quote'
let g:ale_scss_prettier_options = '--parser css'
let g:ale_python_black_auto_pipenv = 1
let g:ale_fixers = {
    \ 'javascript': ['prettier'],
    \ 'python': ['black', 'isort'],
    \ 'rust': ['rustfmt'],
    \ 'cpp': ['clang-format'],
    \ 'scss': ['prettier'],
    \}

" DelimitMate
let g:delimitMate_expand_cr = 2

" TagBar
nmap <F8> :TagbarToggle<CR>

" Ultisnips
let g:UltiSnipsExpandTrigger="<C-j>"
