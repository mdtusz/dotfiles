filetype plugin indent on
syntax on

call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dense-analysis/ale'
Plug 'ervandew/supertab'
Plug 'fisadev/vim-isort'
Plug 'github/copilot.vim'
Plug 'honza/vim-snippets'
Plug 'majutsushi/tagbar'
Plug 'mattn/emmet-vim'
Plug 'raimondi/delimitmate'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'sirtaj/vim-openscad'
Plug 'sirver/ultisnips'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vimwiki/vimwiki'

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
set nofoldenable
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
autocmd FileType python setlocal foldmethod=indent
autocmd BufWritePre *[js|ts|jsx|tsx|c|cpp|h|py|html|css|hs|md] %s/\s\+$//e

command Bd bp|bd #
command Vsp vsp|bp
command Wq wq
command W w

command Q qa

map <Leader><TAB> :bn<CR>
map <Leader><Leader> <C-w><C-w>

map <Leader>} <C-w>}
map <Leader>z <C-w>z

map gd :ALEGoToDefinition<CR>

" Adds shift-enter for newline above
inoremap <S-CR> <Esc>O
imap ✠ <S-CR>

" Override filetypes for certain files
augroup filetypedetect
  autocmd! BufNewFile,BufRead *.frag setfiletype glsl
  autocmd! BufNewFile,BufRead *.vert setfiletype glsl
augroup END

" Custom colorscheme
set background=light
" set termguicolors
highlight SignColumn cterm=none ctermbg=none
highlight CursorLineNr term=none cterm=none ctermfg=blue
highlight LineNr term=none cterm=none ctermfg=237
highlight ColorColumn ctermbg=none ctermfg=240 cterm=none guibg=bg
highlight VertSplit cterm=none ctermfg=black
highlight MatchParen ctermbg=blue ctermfg=black
highlight SpellBad ctermbg=red ctermfg=white
highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=yellow
highlight GitGutterDelete ctermfg=red
highlight GitGutterChangeDelete ctermfg=blue
highlight Folded ctermfg=yellow ctermbg=black

highlight DiffAdd term=bold ctermbg=22 ctermfg=white
highlight DiffDelete term=bold ctermbg=88 ctermfg=white
highlight DiffChange term=bold ctermbg=3 ctermfg=black
highlight DiffText term=bold  ctermbg=none ctermfg=black

highlight ALEVirtualTextError ctermbg=none ctermfg=red
highlight ALEVirtualTextWarning ctermbg=none ctermfg=yellow
highlight ALEVirtualTextInfo ctermbg=none ctermfg=grey

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
let g:ctrlp_custom_ignore = '\v[\/](__pycache__|venv|node_modules|dist|target|build)/|(\.(swp|git|svn|pyc|mypy_cache))$'

" Airline
let g:airline_powerline_fonts = 1
let g:airline_inactive_collapse = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#formatter = 'jsformatter'
let g:airline#extensions#tagbar#enabled = 0

" Vimwiki
let g:vimwiki_list = [{
        \'path': '~/documents/wiki/vimwiki',
        \'path_html': '~/documents/wiki/vimwiki_html',
        \'template_path': '~/documents/wiki/templates',
        \'auto_export': 1,
        \'auto_tags': 1
    \ }]

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
let g:ale_hover_to_preview = 1
let g:ale_floating_preview = 1
let g:ale_set_balloons = 1
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 1
let g:ale_close_preview_on_insert = 1
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
let g:ale_sign_priority = 100
let g:ale_virtualtext_cursor = 0
let g:ale_virtualtext_prefix = "%severity%: "

let g:ale_python_auto_pipenv = 1
let g:ale_python_black_auto_pipenv = 1
let g:ale_python_flake8_auto_pipenv = 1
let g:ale_python_mypy_auto_pipenv = 1
let g:ale_python_mypy_options = "--ignore-missing-imports"

let g:ale_scss_prettier_options = '--parser css'

let g:ale_linters = {
    \ 'javascript': ['prettier', 'eslint', 'tsserver'],
    \ 'typescript': ['prettier', 'tsserver', 'eslint'],
    \ 'typescriptreact': ['prettier', 'tsserver', 'eslint'],
    \ 'python': ['pyls', 'flake8', 'mypy'],
    \ 'cpp': ['ccls'],
    \ 'rust': ['analyzer'],
    \ 'html': [],
    \ 'shell': ['shellcheck'],
\}

let g:ale_rust_cargo_use_clippy = 0

let g:ale_fixers = {
    \ 'javascript': ['prettier', 'eslint'],
    \ 'typescript': ['prettier', 'eslint'],
    \ 'typescriptreact': ['prettier', 'eslint'],
    \ 'json': ['prettier'],
    \ 'python': ['black', 'isort'],
    \ 'rust': ['rustfmt'],
    \ 'cpp': ['clang-format'],
    \ 'scss': ['prettier'],
    \ 'css': ['prettier'],
\}

" DelimitMate
let g:delimitMate_expand_cr = 2

" TagBar
nmap <F8> :TagbarToggle<CR>

" Ultisnips
" let g:UltiSnipsExpandTrigger="<Tab>"
" let g:UltiSnipsJumpForwardTrigger="<Tab>"
" let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
" let g:UltiSnipsSnippetDirectories=[$HOME.'/code/snippets']

" Supertab
let g:SuperTabDefaultCompletionType="<C-n>"

" Hexokinase
let g:Hexokinase_highlighters = ['foreground']
let g:Hexokinase_optInPatterns = 'full_hex,triple_hex,rgb,rgba,hsl,hsla'

" Vim Markdown
let g:vim_markdown_follow_anchor = 1
