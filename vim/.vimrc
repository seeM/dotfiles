" Author: Wasim Lorgat
" Source: http://github.com/seem/dotfiles/vim/.vimrc

" Basic setup -------------------------------------------------------------- {{{

" set nomodeline
" TODO: Needed?
" set filetype plugin indent on
set hidden
set ttyfast
set lazyredraw
set autoindent
set backspace=indent,eol,start
set showcmd
set ruler
set laststatus=2
set number relativenumber
set numberwidth=5
set history=1000
" TODO: Needed?
set splitbelow
set splitright
" TODO: Keep autowrite and autoread?
set autowrite
set autoread
" set shiftround
set title
set linebreak
set showbreak=↪
set colorcolumn=+1
set diffopt+=vertical
" TODO: longest?
set completeopt=longest,menuone
" TODO: Needed?
set nostartofline              " avoid going to start of line on certain commands
set signcolumn=yes
set path=.,**

" TODO: Needed?
" set list
" set listchars=tab:▸\ ,extends:❯,precedes:❮
" augroup trailing
"     au!
"     au InsertEnter * :set listchars-=trail:⌴
"     au InsertLeave * :set listchars+=trail:⌴
" augroup END

" Wildmenu completion {{{

set wildmenu
set wildignorecase
set wildmode=list:full                               " Bash-like completion

set wildignore+=.DS_Store                            " MacOS
set wildignore+=__pycache__,mypy_cache,venv,*.pyc    " Python
set wildignore+=.git                                 " Version control
set wildignore+=.vscode                              " VSCode

" }}}
" Line Return {{{

" TODO: Exclude git commit files

" Make sure Vim returns to the same line when you reopen a file.
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" }}}
" Tabs, spaces, wrapping {{{

" set tabstop=4
" Indent (>>) and dedent (<<) with 4 spaces.
set shiftwidth=4
" <Tab> and <BS> are worth 'shiftwidth' spaces.
let &softtabstop = &shiftwidth
" Disable conversion of 'tabstop' spaces to a \t character, they remain spaces.
set expandtab

set nowrap
set textwidth=80
" TODO: format options
set formatoptions=qrn1j
set colorcolumn=+1

" }}}
" Backups {{{

set undofile
set backup
set noswapfile

set undodir=~/.vim/tmp/undo//
set backupdir=~/.vim/tmp/backup//
set directory=~/.vim/tmp/swap//

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" }}}
" Mouse {{{
set mouse=a                    " enable mouse for all modes
" Fix mouse pane resizing inside tmux.
" See: https://superuser.com/questions/549930/cant-resize-vim-splits-inside-tmux
if &term =~ '^screen'
    set ttymouse=xterm2
endif
" }}}
" }}}
" Keys {{{

let mapleader = "\<Space>"
" let maplocalleader = ","

" Start commands with ; so we don't need the extra shift press each time.
noremap ; :

" Quick save.
noremap <silent> <leader>w :update<cr>
" Exit without escape key
inoremap jk <esc>
" TODO: Keep?
" Enter in normal mode creates a new line
" nnoremap <cr> o<esc>
" Tab for toggling selected fold
" TODO: Unfortunately this breaks Ctrl-i, which is somehow linked to <tab>.
"       Would love a solution to this.
" nnoremap <tab> za
" Shift Tab for toggling all folds
" TODO: Does not work
" nnoremap <S-tab> &foldlevel ? 'zM' :'zR'
" TODO: <C-l> toggle between zz zt zb?
" noremap <C-l> zz

" Keep blocks selected after indenting
vnoremap > >gv
vnoremap < <gv
nmap >> V>
nmap << V<

" Color scheme swapping:
" theme - dark
noremap <leader>ts :colorscheme 
noremap <leader>td :colorscheme iceberg<cr>:set background=dark<cr>
noremap <leader>tl :colorscheme solarized8<cr>:set background=light<cr>

" Wrap the current paragraph, don't use default Q binding anyway.
nnoremap Q gqip
xnoremap Q gq

" }}}
" Search ------------------------------------------------------------------- {{{

" set ignorecase
" set smartcase
set incsearch
set showmatch
" set gdefault
set hlsearch

" Clear search highlight.
" TODO: Fix not working, disabling for now
" nnoremap <silent> <CR> :nohlsearch<CR>
nnoremap <silent> // :nohlsearch<CR>
" Above mapping breaks <cr> behaviour in history and quickfix lists.
" Below two lines fix that.
" autocmd CmdwinEnter * nnoremap <CR> <CR>
" autocmd BufReadPost quickfix nnoremap <CR> <CR>

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

"}}}
" Navigation --------------------------------------------------------------- {{{

" Navigate through wrapped lines.
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Easy window movement.
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" TODO: Needed?
" Navigate by window number.
let i = 1
while i <= 9
    execute 'nnoremap <silent> <leader>' . i . ' :' . i . 'wincmd w<CR>'
    let i = i + 1
endwhile
" nnoremap <Leader>w <c-w>

" Buffers:
" [b]uffers
nnoremap <leader>bb :CtrlPBuffer<cr>
" Quick swap buffers.
noremap <leader><tab> <C-^>
" [f]iles
" nnoremap <leader>ff :CtrlP<cr>
nnoremap <leader>e :edit **/*
nnoremap <leader>f :find *
" Project [T]ree
" noremap <leader>t :NERDTreeFind<cr>
" }}}
" Plugins {{{

" TODO Include a version in git repo?
" " Download vim-plug if necessary
" if empty(glob('~/.vim/autoload/plug.vim'))
"   silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
" endif

call plug#begin('~/.vim/plugged')

" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/deoplete.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif

" Basics
Plug 'tpope/vim-surround'               " s is a text-object for delimiters; ss linewise; ys to add surround
Plug 'tpope/vim-commentary'             " gc is an operator to toggle comments; gcc linewise
Plug 'tpope/vim-repeat'                 " make vim-commentary and vim-surround work with `.`
Plug 'tpope/vim-vinegar'                " enhance the built-in netrw file explorer
Plug 'AndrewRadev/splitjoin.vim'        " split / join multi / single lines
" Plug 'vim-scripts/ReplaceWithRegister'  " add verb to replace with register

" New features
Plug 'tpope/vim-fugitive'
Plug 'jpalardy/vim-slime'               " sending text between terminals
" Plug 'Valloric/YouCompleteMe'           " asynchronous autocompletion
Plug 'w0rp/ale'                         " asynchronous lint engine
" Plug 'ervandew/supertab'                " autocomplete with Tab
Plug 'christoomey/vim-tmux-navigator'   " seamless vim-tmux pane movement
" Plug 'kien/ctrlp.vim'
" Plug 'scrooloose/nerdtree'              " file browser in the sidebar
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'maralla/completor.vim'

" Plug 'ervandew/supertab'
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'

" Language-specific
" Plug 'python-mode/python-mode', { 'branch': 'develop' }
" Plug 'tmhedberg/SimpylFold'             " better python code folding
Plug 'Vimjas/vim-python-pep8-indent'    " better python indenting
" Plug 'hdima/python-syntax'              " better python syntax colors
Plug 'davidhalter/jedi-vim'
" Plug 'freitass/todo.txt-vim'            " todo.txt functionality
" Plug 'davidoc/taskpaper.vim'
" Plug 'masukomi/vim-markdown-folding'

" Colorschemes {{{
" TODO: Include color files in dotfiles instead of plugin?
Plug 'cocopon/iceberg.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'NLKNguyen/papercolor-theme'
Plug 'w0ng/vim-hybrid'
" }}}

call plug#end()
" }}}
" Plugin Settings {{{

" Autocompletion {{{

" " make YCM compatible with UltiSnips (using supertab)
" let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
" let g:SuperTabDefaultCompletionType = '<C-n>'

" " better key bindings for UltiSnipsExpandTrigger
" let g:UltiSnipsExpandTrigger = "<tab>"
" let g:UltiSnipsJumpForwardTrigger = "<tab>"
" let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" }}}

" Git {{{

noremap <leader>gs :Gstatus<cr>

" }}}
" let g:python3_host_prog = '$PWD/venv/bin/python3'
let g:deoplete#enable_at_startup = 1
" Using a custom version of this in ftype plugin
let g:jedi#documentation_command = ""

let g:jedi#documentation_command = ""
let g:jedi#popup_on_dot = 0

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"
" let g:jedi#completions_enabled = 0
let g:ale_lint_on_text_changed = 'never'
let g:deoplete#enable_at_startup = 1
let g:slime_target = 'tmux'
let g:slime_paste_file = tempname()
let g:slime_python_ipython = 1
" let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ale_python_mypy_options = '--ignore-missing-imports'    " '--warn-no-return' may also be useful in future
let g:python_highlight_all = 1
" CtrlP
let g:ctrlp_custom_ignore = '\v[\/](\.git|venv)$'
" indentLine
" let g:indentLine_char = '▏'
" supertab
" let g:SuperTabDefaultCompletionType = "context"
" NERDTree
let g:NERDTreeRespectWildIgnore = 1
" }}}
" Color scheme {{{

syntax on
set background=dark
colorscheme iceberg

" TODO: Needed?
" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" TODO: Move to plugin settings.
" let g:python_highlight_all = 1

" True color support
" See: https://github.com/vim/vim/issues/993
" Set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

" Highlight current line, bold current line number
set cursorline
highlight CursorLineNR cterm=bold
" }}}
" GUI {{{

set guifont=Menlo:h12

" Disable scrollbars
set guioptions=

" Disable cursor blinking
set guicursor+=n-v-c:blinkon0

" }}}

" vim: foldmethod=marker:foldlevel=0
