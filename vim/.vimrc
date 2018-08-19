" Wasim Lorgat
" Basic Setup {{{
syntax on
filetype plugin on             " enable filetype-specific plugins
set nowrap                     " disable line wrapping
set number                     " enable line numbering
set colorcolumn=79             " color 79th column
set modeline
let mapleader = ","
set expandtab                  " expand tabs to spaces
set shiftwidth=4               " number of spaces to expand a tab to
set softtabstop=4              " ???
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
Plug 'tpope/vim-sensible'               " sensible vim defaults
Plug 'tpope/vim-surround'               " s is a text-object for delimiters; ss linewise; ys to add surround
Plug 'tpope/vim-commentary'             " gc is an operator to toggle comments; gcc linewise
Plug 'tpope/vim-repeat'                 " make vim-commentary and vim-surround work with `.`
Plug 'tpope/vim-vinegar'                " enhance the built-in netrw file explorer
Plug 'altercation/vim-colors-solarized'
Plug 'jpalardy/vim-slime'               " sending text between terminals
" Plug 'Valloric/YouCompleteMe'           " asynchronous autocompletion
Plug 'w0rp/ale'                         " asynchronous lint engine
Plug 'ervandew/supertab'                " fixes tab for insert-mode
Plug 'christoomey/vim-tmux-navigator'   " seamless vim-tmux pane movement
Plug 'tmhedberg/SimpylFold'             " better python code folding
Plug 'Vimjas/vim-python-pep8-indent'    " better python indenting
Plug 'hdima/python-syntax'              " better python syntax colors
Plug 'freitass/todo.txt-vim'            " todo.txt functionality
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }    " cool for note-taking
Plug 'cocopon/iceberg.vim'
Plug 'lifepillar/vim-solarized8'
call plug#end()
" }}}
" Plugin Settings {{{
let g:slime_target = 'tmux'
let g:slime_paste_file = tempname()
let g:slime_python_ipython = 1
" let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ale_python_mypy_options = '--ignore-missing-imports'    " '--warn-no-return' may also be useful in future
let g:python_highlight_all = 1
" vimwiki
let wiki = {}
let wiki.path = '~/Dropbox/notes/'
let wiki.nested_syntaxes = {'python': 'python'}
let g:vimwiki_list = [wiki]
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
if g:colors_name == 'iceberg'
    highlight StatusLine guibg=#818596 guifg=#1e2132
    highlight StatusLineNC guibg=#3e445e guifg=#1e2132
endif
" }}}
" Font {{{
set guifont='DejaVu\ Sans\ Mono\ 12
" }}}
" vim: foldmethod=marker:foldlevel=0
