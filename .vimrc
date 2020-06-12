filetype plugin indent on
syntax on

call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dense-analysis/ale'
Plug 'ervandew/supertab'
Plug 'fisadev/vim-isort'
Plug 'honza/vim-snippets'
Plug 'ledger/vim-ledger'
Plug 'majutsushi/tagbar'
Plug 'mattn/emmet-vim'
Plug 'raimondi/delimitmate'
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'sirtaj/vim-openscad'
Plug 'sirver/ultisnips'
Plug 'terryma/vim-multiple-cursors'
Plug 'thaerkh/vim-workspace'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vimwiki/vimwiki'
Plug 'wakatime/vim-wakatime'

call plug#end()

set encoding=UTF-8
set updatetime=100
set lazyredraw
set noswapfile
set noerrorbells

set number relativenumber
set laststatus=2
set mouse=a
set ttymouse=xterm
set history=1000
set backspace=2
set scrolloff=10
set clipboard=unnamed
set confirm
set hidden
set signcolumn=yes

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
set foldmethod=syntax
set foldlevelstart=8
set colorcolumn=80

set wildmenu
set wildignore=*.o,*~,*.pyc,__pycache__/

set splitbelow
set splitright

set completeopt+=preview
set completeopt+=menuone
set completeopt+=noinsert
set completeopt+=noselect

autocmd FileType haskell,javascript,typescript,typescriptreact,json,cpp,css,scss setlocal shiftwidth=2 softtabstop=2 tabstop=2
autocmd BufWritePre *[js|ts|tsx|c|cpp|h|py|html|css|hs|md] %s/\s\+$//e

" " Grayout sections of C/C++ code that have falsy ifdef macros.
" augroup grayout
"     autocmd BufEnter *\.[cpp|hpp|c|h] GrayoutUpdate
" augroup END

command Bd bp|bd #
command Vsp vsp|bp
command Wq wq
command W w

command Q qa

map <Leader><TAB> :bn<CR>
map <Leader><Leader> <C-w><C-w>

map <Leader>} <C-w>}
map <Leader>z <C-w>z

map <C-]> :ALEGoToDefinition<CR>

" Adds shift-enter for newline above
inoremap <S-CR> <Esc>O
imap ✠ <S-CR>


" Custom colorscheme
set background=dark
highlight SignColumn cterm=none ctermbg=none
highlight CursorLineNr term=none cterm=none ctermfg=blue
highlight LineNr term=none cterm=none ctermfg=237
highlight ColorColumn ctermbg=none ctermfg=240 cterm=none
highlight VertSplit cterm=none ctermfg=black
highlight MatchParen ctermbg=blue ctermfg=black
highlight SpellBad ctermbg=red ctermfg=white
highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=yellow
highlight GitGutterDelete ctermfg=red
highlight GitGutterChangeDelete ctermfg=blue

highlight DiffAdd term=bold ctermbg=22 ctermfg=white
highlight DiffDelete term=bold ctermbg=88 ctermfg=white
highlight DiffChange term=bold ctermbg=3 ctermfg=black
highlight DiffText term=bold  ctermbg=none ctermfg=black

highlight Pmenu ctermbg=black ctermfg=gray
highlight PmenuSel ctermbg=black ctermfg=blue

" File Explorer
let g:netrw_liststyle = 3
let g:netrw_list_hide = '.*\.swp$,\~$,\.orig$,\.pyc$'

" CtrlP
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'ET'
let g:ctrlp_max_files = 0
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_custom_ignore = '\v[\/](__pycache__|venv|node_modules|dist|target)|(\.(swp|git|svn|pyc))$'

" Airline
let g:airline_theme = 'base16_atelierlakeside'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" Vimwiki
let g:vimwiki_list = [{
        \'path': '~/Documents/Wiki/vimwiki',
        \'path_html': '~/Documents/Wiki/vimwiki_html',
        \'template_path': '~/Documents/Wiki/templates',
        \'auto_export': 1,
        \'auto_tags': 1
    \ }, {
        \'path': '~/Documents/Wiki/aonwiki',
        \'path_html': '~/Documents/Wiki/aonwiki_html',
        \'template_path': '~/Documents/Wiki/templates',
        \'auto_export': 1,
        \'auto_tags': 1
    \ }
\]

" Gitgutter
let g:gitgutter_realtime = 1
let g:gitgutter_async = 1
let g:gitgutter_sign_added = ' +'
let g:gitgutter_sign_removed = ' -'
let g:gitgutter_sign_modified = ' ~'
let g:gitgutter_sign_modified_removed = ' <'
let g:gitgutter_max_signs = 1000
let g:gitgutter_sign_priority = 1

" Ale
" let g:ale_hover_to_preview = 1
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_close_preview_on_insert = 1
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
let g:ale_sign_priority = 100

let g:ale_python_auto_pipenv= 1
let g:ale_python_black_auto_pipenv = 1
let g:ale_python_flake8_auto_pipenv= 1
let g:ale_python_mypy_auto_pipenv = 1
let g:ale_python_mypy_options = "--ignore-missing-imports"

let g:ale_scss_prettier_options = '--parser css'

" let g:ale_rust_rls_executable = "rust-analyzer"

let g:ale_linters = {
    \ 'javascript': ['prettier', 'eslint'],
    \ 'typescript': ['tsserver', 'prettier', 'eslint'],
    \ 'python': ['pyls', 'flake8', 'mypy'],
    \ 'cpp': ['ccls'],
    \ 'rust': ['rls'],
    \ 'html': [],
    \ 'shell': ['shellcheck'],
\}

let g:ale_fixers = {
    \ 'javascript': ['prettier'],
    \ 'typescript': ['prettier'],
    \ 'typescriptreact': ['prettier'],
    \ 'json': ['prettier'],
    \ 'python': ['black', 'isort'],
    \ 'rust': ['rustfmt'],
    \ 'cpp': ['clang-format'],
    \ 'scss': ['prettier'],
    \ 'css': ['prettier'],
    \ 'go': ['gofmt']
\}

" DelimitMate
let g:delimitMate_expand_cr = 2

" TagBar
nmap <C-F8> :TagbarToggle<CR>
nmap <F8> :TagbarOpenAutoClose<CR>

" Ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
let g:UltiSnipsSnippetDirectories=[$HOME.'/Code/snippets']

" Supertab
let g:SuperTabDefaultCompletionType="<C-n>"

" Workspaces
let g:workspace_autosave = 0

