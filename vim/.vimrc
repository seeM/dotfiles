" Author: Wasim Lorgat
" Source: http://github.com/seem/dotfiles/vim/.vimrc
" TODO: Remove most plugins...
" TODO: Modify pymode pydoc to use python -m pydoc which is aware of current
"       venv.
" TODO: Why does surround plugin add spaces inside of square brackets in
"       python?
" TODO: Change grep command to only use inner word, and give a better letter.

augroup line_return
    autocmd!
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     exe "normal g`\"" |
        \ endif
augroup end

" New stuff -- via steve losh: https://bitbucket.org/sjl/dotfiles/src/default/vim/vimrc

" Junegunn
function! s:zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
                  \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction
nnoremap <silent> <leader>z :call <sid>zoom()<cr>

" function! s:statusline_expr()
"   let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
"   let ro  = "%{&readonly ? '[RO] ' : ''}"
"   let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
"   let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
"   let sep = ' %= '
"   let pos = ' %-12(%l : %c%V%) '
"   let pct = ' %P'

"   return '[%n] %F %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
" endfunction
" let &statusline = s:statusline_expr()

" Plugins {{{
call plug#begin('~/.vim/plugged')
" Basics {{{
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-endwise'
Plug 'romainl/vim-cool'                 " only highlight search while typing
" Plug 'christoomey/vim-tmux-navigator'
Plug 'AndrewRadev/splitjoin.vim'
    let g:splitjoin_trailing_comma = 1
    let g:splitjoin_python_brackets_on_separate_lines = 1
    let g:splitjoin_quiet = 1
" }}}
" Languages {{{
" Plug 'Vimjas/vim-python-pep8-indent'
" Plug 'fs111/pydoc.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'python-mode/python-mode', { 'branch': 'develop' }
    let g:pymode_lint_cwindow = 0
    let g:pymode_options_max_line_length = 100
    let g:pymode_python = 'python3'
    let g:pymode_breakpoint_bind = '<leader>d'
    let g:pymode_lint = 0
    let g:pymode_rope = 0
    let g:pymode_rope_completion = 0
Plug 'saltstack/salt-vim'
" }}}
" Features {{{
Plug 'tpope/vim-fugitive'
Plug 'jpalardy/vim-slime'               " sending text between terminals
    let g:slime_default_config = {"socket_name": "default", "target_pane": ":.2"}
    let g:slime_dont_ask_default = 1
    let g:slime_target = 'tmux'
" TODO: Ultisnips?
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
Plug 'dense-analysis/ale'
Plug 'dkarter/bullets.vim'

if executable('node')
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:show_documentation()
      if (index(['vim', 'help'], &filetype) >= 0)
        execute 'h' expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction

    " nnoremap <silent> K :call <SID>show_documentation()<CR>

    let g:coc_global_extensions = ['coc-github', 'coc-yaml', 'coc-solargraph',
      \ 'coc-r-lsp', 'coc-python', 'coc-html', 'coc-json', 'coc-css', 'coc-html',
      \ 'coc-prettier', 'coc-eslint', 'coc-tsserver', 'coc-emoji', 'coc-java']
    command! -nargs=0 Prettier :CocCommand prettier.formatFile

    let g:go_doc_keywordprg_enabled = 0

    augroup coc-config
      autocmd!
      autocmd VimEnter * nmap <silent> gd <Plug>(coc-definition)
      autocmd VimEnter * nmap <silent> gi <Plug>(coc-implementation)
      autocmd VimEnter * nmap <silent> g? <Plug>(coc-references)
    augroup END
endif
" }}}
" Colors {{{
Plug 'cocopon/iceberg.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'romainl/Apprentice'
Plug 'romainl/flattened'
" }}}
call plug#end()
" }}}
" Basics {{{
set nomodeline
set hidden
set ttyfast
set lazyredraw
" Set focus to the newly splitted window when using :sp or :vsp.
set splitbelow
set splitright
" Allow backspacing over these symbols (sane behaviour)
set backspace=indent,eol,start
set showcmd
set ruler
set laststatus=2
" set number relativenumber
set numberwidth=5
" TODO: Keep autowrite and autoread?
" set autowrite
" Reload files that are edited externally.
set autoread
au FocusGained,BufEnter * :silent! !
" Auto save files on focus lost.
" au FocusLost,WinLeave * :silent! noautocmd w
set shiftround
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
set conceallevel=3
" Indent (>>) and dedent (<<) with 4 spaces.
set shiftwidth=4
" <Tab> and <BS> are worth 'shiftwidth' spaces.
let &softtabstop = &shiftwidth
" Disable conversion of 'tabstop' spaces to a \t character, they remain spaces.
set expandtab
set nowrap
set sidescroll=5
" TODO: format options
set formatoptions=qrn1j
set incsearch
set hlsearch
silent! set ttymouse=xterm2
set mouse=a
" True color support
" From: https://github.com/vim/vim/issues/993#issuecomment-255651605
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
set path=.,**
" }}}
" Wildmenu completion {{{
set wildmenu
set wildignorecase
" set wildcharm=<C-z>
set wildmode=full
" I've had to repeat directories twice, please let me know if there's a better
" solution... The first, e.g., **/__pycache__  is needed for expanding wildcards
" in commands like :edit **. The second is needed for netrw.
set wildignore+=.DS_Store
set wildignore+=**/__pycache__,__pycache__
set wildignore+=**/.mypy_cache,.mypy_cache
set wildignore+=**/.pytest_cache,.pytest_cache
set wildignore+=**/.ropeproject,.ropeproject
set wildignore+=*.pyc
set wildignore+=**/.env,.env,**/env,env
set wildignore+=**/.venv,.venv,**/env,env
set wildignore+=**/.git,.git
set wildignore+=**/.vscode,.vscode
set wildignore+=**/.idea,.idea
set wildignore+=.tags,tags
" }}}
" Backup {{{
set undofile
set backup
set noswapfile
set undodir=~/.vim/tmp/undo//
set backupdir=~/.vim/tmp/backup//
set directory=~/.vim/tmp/swap//
if !isdirectory(expand(&backupdir)) | call mkdir(expand(&backupdir), "p") | endif
if !isdirectory(expand(&directory)) | call mkdir(expand(&directory), "p") | endif
" }}}
" Mappings {{{
" nnoremap <leader>f :Files .<CR>
" nnoremap <leader>b :Buffers<CR>
" From: https://romainl.github.io/the-patient-vimmer/3.html
let mapleader      = ' '
let maplocalleader = ' '
nnoremap <leader>e :edit **/*
nnoremap <leader>f :find *
nnoremap <leader>b :buffer *
nnoremap gb :ls<CR>:b<Space>
nnoremap <C-p> :FZF<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>d :bd<CR>
nnoremap <leader>y "*y
nnoremap <leader><leader> <c-^>

nnoremap <silent> L :set number!<CR>:set relativenumber!<CR>

" Save
inoremap <C-s>     <C-O>:update<cr>
nnoremap <C-s>     :update<cr>
nnoremap <leader>w :update<cr>

" Quit
inoremap <C-Q>     <esc>:q<cr>
nnoremap <C-Q>     :q<cr>
vnoremap <C-Q>     <esc>
nnoremap <Leader>q :q<cr>
nnoremap <Leader>Q :qa!<cr>

" Tags
" g<C-]> shows a menu if >1 match
nnoremap <C-]> g<C-]>
nnoremap g[ :pop<cr>

" Make Y behave like other capitals
nnoremap Y y$

" Last inserted text
nnoremap g. :normal! `[v`]<cr><left>

" Tabs
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

" Circular windows navigation
" nnoremap <tab>   <c-w>w
" nnoremap <S-tab> <c-w>W

" Markdown headings
nnoremap <leader>1 m`yypVr=``
nnoremap <leader>2 m`yypVr-``
nnoremap <leader>3 m`^i### <esc>``4l
nnoremap <leader>4 m`^i#### <esc>``5l
nnoremap <leader>5 m`^i##### <esc>``6l

" Folds
nnoremap <tab> za
function! ToggleAllFolds()
    if &foldlevel
        set foldlevel=0
    else
        set foldlevel=999
    endif
endfunction
command! ToggleAllFolds call ToggleAllFolds()
nnoremap <S-tab> :ToggleAllFolds<cr>

" }}}
" Visual {{{
set background=dark
colorscheme apprentice
" Highlight git merge conflict markers using the ErrorMsg highlight group
" TODO: Cause slow down?...
set cursorline
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set list
let &showbreak="↪ "

" Custom syntax
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

highlight CursorLineNR cterm=bold gui=bold
highlight Todo cterm=bold gui=bold

" TODO: Testing...
" highlight Include cterm=bold gui=bold
" TODO: Should this be moved to python?
highlight Statement cterm=bold gui=bold

" From: https://romainl.github.io/the-patient-vimmer/1.html
set statusline=%<\ %f\ %m%r%y%w%=\ L:\ \%l\/\%L\ C:\ \%c\ 

set guifont=Menlo:h12
" Disable scrollbars
set guioptions=
" Disable cursor blinking
set guicursor+=n-v-c:blinkon0
" }}}
" Mini plugins {{{
" Grep {{{
" From: https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
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

" function! GrepInnerWord()
"     let reg_save = @@
"     execute 'normal! "zyiw'
"     execute 'cgetexpr Grep(' . shellescape(@@) . ')'
"     let @@ = reg_save
" endfunction

" nnoremap <leader>giw :call GrepInnerWord()<cr>

" TODO: Currently Grep function doesn't make sense to be called with most motions,
"       only really inner word. Should it still be an operator?
"       Should there be gaurd clauses? Not sure the approach
function! GrepOperator(type, ...)
    let reg_save = @@

    if a:0  " Invoked from Visual mode
        silent exec "normal! gvy"
    elseif a:type == 'line'
        silent exec "normal! '[V']y"
    else
        silent exec "normal! `[v`]y"
    endif

    " TODO: Better way than this to have the actual contents of @@ display in the statusline of the quickfix window?
    "       This doesn't seem to work: cgetexpr Grep(shellescape(@@))
    execute "cgetexpr Grep(" . shellescape(@@) . ")"

    let @@ = reg_save
endfunction

nnoremap <silent> <leader>g :set opfunc=GrepOperator<CR>g@
vnoremap <silent> <leader>g :<C-U>call GrepOperator(visualmode(), 1)<CR>

" Automatically open the quickfix/location list window on c/lgetexpr.
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost cgetexpr cwindow
    autocmd QuickFixCmdPost lgetexpr lwindow
augroup end

" }}}
" Git Blame {{{
" From: https://gist.github.com/romainl/5b827f4aafa7ee29bdc70282ecc31640
command! -range GB echo join(systemlist("git -C " . shellescape(expand('%:p:h')) . " blame -L <line1>,<line2> " . expand('%:t')), "\n")
" }}}
" Rename file {{{
" From: https://github.com/garybernhardt/dotfiles/blob/7e0f353bca25b07d2ef9bcae2070406e3d4ac029/.vimrc#L284-L296
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
noremap <leader>rn :call RenameFile()<cr>
" }}}
" Cat {{{
" Cat selection to terminal so we can copy with mouse selection on remote
" servers.
function! CatSelection() range
    execute("!sed -n '" . a:firstline . "," . a:lastline . "p;" . (a:lastline + 1) . "q' %")
endfunction
nnoremap <leader>c :call CatSelection()<cr>
vnoremap <leader>c :call CatSelection()<cr>
" }}}
" Word count {{{
function! EchoWordCount()
    let word_count = system("wc -w " . @% . " | awk '{ print $1}'")[:-2]
    echo("Word count: " . word_count)
endfunction

command! -nargs=0 WC call EchoWordCount()
" }}}
" }}}
" COC {{{
" if has_key(g:plugs, 'coc.nvim')
"   function! s:check_back_space() abort
"     let col = col('.') - 1
"     return !col || getline('.')[col - 1]  =~# '\s'
"   endfunction

"   inoremap <silent><expr> <TAB>
"         \ pumvisible() ? "\<C-n>" :
"         \ <SID>check_back_space() ? "\<TAB>" :
"         \ coc#refresh()
"   inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

"   function! s:show_documentation()
"     if (index(['vim', 'help'], &filetype) >= 0)
"       execute 'h' expand('<cword>')
"     else
"       call CocAction('doHover')
"     endif
"   endfunction

"   nnoremap <silent> K :call <SID>show_documentation()<CR>

"   let g:coc_global_extensions = ['coc-github', 'coc-yaml', 'coc-solargraph',
"     \ 'coc-r-lsp', 'coc-python', 'coc-html', 'coc-json', 'coc-css', 'coc-html',
"     \ 'coc-prettier', 'coc-eslint', 'coc-tsserver', 'coc-emoji', 'coc-java']
"   command! -nargs=0 Prettier :CocCommand prettier.formatFile

"   let g:go_doc_keywordprg_enabled = 0

"   augroup coc-config
"     autocmd!
"     autocmd VimEnter * nmap <silent> gd <Plug>(coc-definition)
"     autocmd VimEnter * nmap <silent> gi <Plug>(coc-implementation)
"     autocmd VimEnter * nmap <silent> g? <Plug>(coc-references)
"   augroup END
" endif
" }}}
