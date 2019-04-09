" Wasim Lorgat
" Basic Setup {{{
syntax on
filetype plugin on             " enable filetype-specific plugins
set nowrap                     " disable line wrapping
set number                     " enable line numbering
set colorcolumn=79             " color 79th column
set modeline
let mapleader = ","
let maplocalleader = ","
set expandtab                  " expand tabs to spaces
set shiftwidth=4               " number of spaces to expand a tab to
set tabstop=4                  " an indent every 4 spaces
set softtabstop=4              " let backspace delete indent
set nostartofline              " avoid going to start of line on certain commands

" Maintain undo history between sessions
set undofile
set undodir=~/.vim/.undo
set noswapfile
" }}}
" Ignore {{{
set wildignore+=.DS_Store
set wildignore+=__pycache__/
set wildignore+=.mypy_cache/
set wildignore+=.git/
set wildignore+=.gitignore
set wildignore+=.vscode/
set wildignore+=venv/
" }}}
" Line numbers {{{
" hybrid line numbers, i.e., all relative except current line
set number relativenumber
" Use absolute numbers in insert mode and relative numbers in normal mode
" augroup numbertoggle
"   autocmd!
"   autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"   autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
" augroup END
" Always use 4 columns for the line numbers
set numberwidth=4
" }}}
" Panes {{{
" easy pane movement
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" new panes open below or right - more natural
set splitbelow
set splitright
" }}}
" Plugins {{{
" Download vim-plug if necessary
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" General
Plug 'tpope/vim-sensible'               " sensible vim defaults

" New features
Plug 'tpope/vim-vinegar'                " enhance the built-in netrw file explorer
Plug 'tpope/vim-fugitive'
Plug 'lambdalisue/gina.vim'             " async git required by statusline
Plug 'jpalardy/vim-slime'               " sending text between terminals
" Plug 'Valloric/YouCompleteMe'           " asynchronous autocompletion
Plug 'w0rp/ale'                         " asynchronous lint engine
Plug 'ervandew/supertab'                " autocomplete with Tab
Plug 'christoomey/vim-tmux-navigator'   " seamless vim-tmux pane movement
" Plug 'vimwiki/vimwiki', { 'branch': 'dev' }    " cool for note-taking
Plug 'kien/ctrlp.vim'
" Plug 'ajh17/VimCompletesMe'             " built-in vim autocompletion on words and paths

" Language-specific
Plug 'tmhedberg/SimpylFold'             " better python code folding
Plug 'Vimjas/vim-python-pep8-indent'    " better python indenting
Plug 'hdima/python-syntax'              " better python syntax colors
Plug 'freitass/todo.txt-vim'            " todo.txt functionality
Plug 'davidoc/taskpaper.vim'

" Visual
Plug 'cocopon/iceberg.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'Yggdroot/indentLine'

" Editing
Plug 'tpope/vim-surround'               " s is a text-object for delimiters; ss linewise; ys to add surround
Plug 'tpope/vim-commentary'             " gc is an operator to toggle comments; gcc linewise
Plug 'tpope/vim-repeat'                 " make vim-commentary and vim-surround work with `.`
Plug 'AndrewRadev/splitjoin.vim'        " split / join multi / single lines
Plug 'vim-scripts/ReplaceWithRegister'  " add verb to replace with register
call plug#end()
" }}}
" Plugin Settings {{{
let g:slime_target = 'tmux'
let g:slime_paste_file = tempname()
let g:slime_python_ipython = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ale_python_mypy_options = '--ignore-missing-imports'    " '--warn-no-return' may also be useful in future
let g:python_highlight_all = 1
" vimwiki
let wiki = {}
let wiki.path = '~/Dropbox/notes/'
let wiki.nested_syntaxes = {'python': 'python'}
let g:vimwiki_list = [wiki]
" CtrlP
let g:ctrlp_custom_ignore = '\v[\/](\.git|venv)$'
" indentLine
let g:indentLine_char = '▏'
" supertab
let g:SuperTabDefaultCompletionType = "context"
" }}}
" Keymaps {{{
noremap <Leader>w :update<CR>    " Quick save
" Buffers
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>
nnoremap \b :CtrlPBuffer<cr>
" Tabs
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>
" Lines
nnoremap \l :CtrlPLine<cr>
" }}}
" Mouse {{{
set mouse=a                    " enable mouse for all modes
" fix mouse pane resizing inside tmux: https://superuser.com/questions/549930/cant-resize-vim-splits-inside-tmux
if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif
" }}}
" Colors {{{
syntax enable                  " enable syntax highlighting
set background=dark
colorscheme iceberg

let g:python_highlight_all = 1

" True color support
" https://github.com/vim/vim/issues/993
" Set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

" Highlight current line, bold current line number
set cursorline
highlight CursorLineNR cterm=bold

" Customization of status line colors for iceberg theme
" if g:colors_name == 'iceberg'
"     highlight StatusLine guibg=#818596 guifg=#1e2132
"     highlight StatusLineNC guibg=#3e445e guifg=#1e2132
" endif
" }}}
" vim: foldmethod=marker:foldlevel=0
