" Author: Wasim Lorgat
" Source: http://github.com/seem/dotfiles/vim/.vimrc
" TODO: Remove most plugins...
" TODO: Add mapping to :Grep for word under cursor
" TODO: Modify tagging to exclude imports, only include lines starting with
"       class, def, etc.
" TODO: Modify pymode pydoc to use python -m pydoc which is aware of current
"       venv.
" TODO: Why does surround plugin add spaces inside of square brackets in
"       python?

" General {{{

" Basics {{{

" set nomodeline

set hidden
set ttyfast
set lazyredraw

" Windows.
" Set focus to the newly splitted window when using :sp or :vsp.
set splitbelow
set splitright

" Allow backspacing over these symbols (sane behaviour)
set backspace=indent,eol,start

set showcmd
set ruler
set laststatus=2

" Line numbers
set number relativenumber
set numberwidth=5

" TODO: Keep autowrite and autoread?
" set autowrite

" Reload files that are edited externally.
set autoread
au FocusGained,BufEnter * :silent! !

" Auto save files on focus lost.
" au FocusLost,WinLeave * :silent! noautocmd w

" " set shiftround
" set title
" set linebreak
" set colorcolumn=+1
" set diffopt+=vertical
" " TODO: longest?
" set completeopt=longest,menuone
" " TODO: Needed?
" set nostartofline              " avoid going to start of line on certain commands
" set signcolumn=yes
" set path=.,**

set tags+=.tags

" }}}
" Wildmenu completion {{{

set wildmenu
set wildignorecase
" set wildcharm=<C-z>
set wildmode=full

" Ignores
" -------
" MacOS
set wildignore+=*.DS_Store
" Python cache
set wildignore+=*__pycache__/*
set wildignore+=*.mypy_cache/*
set wildignore+=*.pyc
" Python venvs
set wildignore+=*.env/*,*.venv/*,*env/*,*venv/*
" Version control
set wildignore+=*.git/*
" IDEs
set wildignore+=*.vscode/*
set wildignore+=*.idea/*

" }}}
" Mouse {{{

" Enable mouse for all modes
if has('mouse')
    set mouse=a                    
endif

" Fix mouse pane resizing inside tmux.
" See: https://superuser.com/questions/549930/cant-resize-vim-splits-inside-tmux
if &term =~ '^screen'
    set ttymouse=xterm2
endif

" }}}
" Backups {{{

" Persist undo history 
set undofile
set backup
set swapfile

set undodir=~/.vim/tmp/undo//
set backupdir=~/.vim/tmp/backup//
set directory=~/.vim/tmp/swap//

" Make above folders automatically if they don't already exist
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
" Indentation {{{

" Indent (>>) and dedent (<<) with 4 spaces.
set shiftwidth=4
" <Tab> and <BS> are worth 'shiftwidth' spaces.
let &softtabstop = &shiftwidth
" Disable conversion of 'tabstop' spaces to a \t character, they remain spaces.
set expandtab

" }}}
" Wrapping {{{

" Disable soft wrapping.
set nowrap
" Side-scroll 5 columns at a time for long lines
set sidescroll=5

" TODO: format options
set formatoptions=qrn1j

" }}}
" Search {{{

set incsearch
set hlsearch

" }}}

" }}}
" Keys {{{
" nnoremap <leader>f :Files .<CR>
" nnoremap <leader>b :Buffers<CR>
" From: https://romainl.github.io/the-patient-vimmer/3.html
let mapleader = "\<Space>"
set path=.,**
nnoremap <leader>e :edit **/*
nnoremap <leader>f :find *
nnoremap <leader>b :buffer *
nnoremap gb :ls<CR>:b<Space>
nnoremap <C-p> :FZF<CR>
" }}}
" Plugins {{{

call plug#begin('~/.vim/plugged')

" Basics {{{

Plug 'tpope/vim-sensible'               " 'Defaults everyone can agree on'
Plug 'tpope/vim-surround'               " s is a text-object for delimiters; ss linewise; ys to add surround
Plug 'tpope/vim-commentary'             " gc is an operator to toggle comments; gcc linewise
Plug 'tpope/vim-repeat'                 " make vim-commentary and vim-surround work with `.`
Plug 'tpope/vim-vinegar'                " enhance the built-in netrw file explorer
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-rsi'
Plug 'romainl/vim-cool'                 " only highlight search while typing
Plug 'christoomey/vim-tmux-navigator'

" }}}
" Languages {{{

" Plug 'Vimjas/vim-python-pep8-indent'
" Plug 'fs111/pydoc.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'saltstack/salt-vim'

" }}}
" Features {{{

Plug 'tpope/vim-fugitive'
Plug 'jpalardy/vim-slime'               " sending text between terminals
" TODO: Ultisnips?
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
Plug 'dense-analysis/ale'

" }}}
" Colors {{{

Plug 'cocopon/iceberg.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'romainl/Apprentice'

" }}}

call plug#end()

" Plugin Settings
let g:pymode_lint_cwindow = 0
let g:pymode_options_max_line_length = 100
let g:pymode_python = 'python3'
let g:pymode_breakpoint_bind = '<leader>d'
" Disable pymode linting in favour of ALE
let g:pymode_lint = 0
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:slime_default_config = {"socket_name": "default", "target_pane": ":.2"}
let g:slime_dont_ask_default = 1
let g:slime_target = 'tmux'

" }}}
" Visual {{{

" True color support
" See: https://github.com/vim/vim/issues/993#issuecomment-255651605
" Set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

syntax on
set background=dark
colorscheme Apprentice

" Highlight git merge conflict markers using the ErrorMsg highlight group
" TODO: Cause slow down?...
" match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Highlight current line, bold current line number
set cursorline
highlight CursorLineNR cterm=bold gui=bold

" Precede a long line with '<', end a long line with '>'
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set list
let &showbreak="↪ "

" Bold Todo instead of standout.
highlight Todo cterm=bold gui=bold

" TODO: Testing...
" highlight Include cterm=bold gui=bold
highlight Statement cterm=bold gui=bold

" Status line. From: https://romainl.github.io/the-patient-vimmer/1.html
set statusline=%<\ %f\ %m%r%y%w%=\ L:\ \%l\/\%L\ C:\ \%c\ 

" }}}
" GUI {{{

set guifont=Menlo:h12

" Disable scrollbars
set guioptions=

" Disable cursor blinking
set guicursor+=n-v-c:blinkon0

" }}}
" Grep {{{
" Source: https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
if executable('ag')
    set grepprg=ag\ --vimgrep\ --case-sensitive
else
    set grepprg=git\ grep\ -n\ --column
endif

function! Grep(args)
    let args = split(a:args, ' ')
    return system(join([&grepprg, shellescape(args[0]), len(args) > 1 ? join(args[1:-1], ' ') : ''], ' '))
endfunction

command! -nargs=+ -complete=tag_listfiles -bar Grep  cgetexpr Grep(<q-args>)
command! -nargs=+ -complete=tag_listfiles -bar LGrep lgetexpr Grep(<q-args>)

" Automatically open the quickfix/location list window on c/lgetexpr.
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost cgetexpr cwindow
    autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

" }}}
" Git Blame {{{

" From: https://gist.github.com/romainl/5b827f4aafa7ee29bdc70282ecc31640
command! -range GB echo join(systemlist("git -C " . shellescape(expand('%:p:h')) . " blame -L <line1>,<line2> " . expand('%:t')), "\n")

" }}}
" Misc {{{

" Cat selection to terminal so we can copy with mouse selection on remote
" servers.
function! CatSelection() range
    execute("!sed -n '" . a:firstline . "," . a:lastline . "p;" . (a:lastline + 1) . "q' %")
endfunction

nnoremap <leader>c :call CatSelection()<cr>
vnoremap <leader>c :call CatSelection()<cr>

" Word count
function! EchoWordCount()
    let word_count = system("wc -w " . @% . " | awk '{ print $1}'")[:-2]
    echo("Word count: " . word_count)
endfunction

command! -nargs=0 WC call EchoWordCount()

" }}}

" smooth searching
" cnoremap <expr> <Tab>   getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>/<C-r>/" : "<C-z>"
" cnoremap <expr> <S-Tab> getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>?<C-r>/" : "<S-Tab>"
" silent! source .vimlocal

" vim: foldmethod=marker:foldlevel=0
