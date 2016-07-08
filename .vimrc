set nocompatible
filetype plugin indent on
syntax on

" Vim plug setup
call plug#begin('~/.vim/plugged')

Plug 'bling/vim-airline'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'pangloss/vim-javascript'

call plug#end()

set number
set relativenumber
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
set scrolloff=5
set autoindent
set softtabstop=2
set shiftwidth=2
set tabstop=2
set copyindent
set shiftround
set expandtab

let g:netrw_liststyle=3

" Airline preferences
let g:airline_powerline_fonts=1
