" Author: Wasim Lorgat
" Source: http://github.com/seem/dotfiles/vim/.vimrc
" TODO: Modify pymode pydoc to use python -m pydoc which is aware of current venv.
" TODO: Change grep command to only use inner word, and give a better letter.

let mapleader      = ','
let maplocalleader = ','

" Plugins {{{
call plug#begin('~/.vim/plugged')
" Basics {{{
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-rsi'
" Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-projectionist'
Plug 'romainl/vim-cool'                 " only highlight search while typing
Plug 'AndrewRadev/splitjoin.vim'
    let g:splitjoin_trailing_comma = 1
    let g:splitjoin_python_brackets_on_separate_lines = 1
    let g:splitjoin_quiet = 1
" }}}
" LSP {{{
Plug 'neovim/nvim-lspconfig'
" }}}
" Completion {{{
Plug 'hrsh7th/nvim-cmp'

" Extensions
Plug 'ray-x/lsp_signature.nvim'

" Completion sources
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
" }}}
" Languages {{{
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
" Plug 'python-mode/python-mode', { 'branch': 'develop' }
"     let g:pymode_lint_cwindow = 0
"     let g:pymode_options_max_line_length = 88
"     let g:pymode_python = 'python3'
"     let g:pymode_breakpoint_bind = '<leader>d'
"     let g:pymode_lint = 0
"     let g:pymode_rope = 0
"     let g:pymode_rope_completion = 0
"     " TODO: I do want these but they're breaking for some reason... maybe
"     " clashing with unimpaired?
"     let g:pymode_motion = 0
"     " Use vim-coiled-snake
"     let g:pymode_folding = 0
"     let g:pymode_trim_whitespaces = 0
"     let g:pymode_run_bind = ''
"     let g:python3_host_prog = '/usr/bin/python'

    Plug 'alfredodeza/pytest.vim'
Plug 'saltstack/salt-vim'
Plug 'jceb/vim-orgmode'
Plug 'PProvost/vim-ps1'
Plug 'cespare/vim-toml'
" Clojure
Plug 'guns/vim-sexp'
    Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'tpope/vim-fireplace'
Plug 'kien/rainbow_parentheses.vim'
" Terraform
Plug 'hashivim/vim-terraform'
" }}}
" Features {{{
Plug 'tpope/vim-fugitive'
Plug 'easymotion/vim-easymotion'
Plug 'jpalardy/vim-slime'               " sending text between terminals
  let g:slime_default_config = {"socket_name": "default", "target_pane": ":.2"}
  let g:slime_dont_ask_default = 1
  let g:slime_target = 'tmux'
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'
  nnoremap <leader>f :Files<CR>
  nnoremap <leader>b :Buffers<CR>
  nnoremap <leader>g :Rg<CR>
  nnoremap <leader>t :Tags<CR>
  nnoremap <leader>c :Commands<CR>
Plug 'dense-analysis/ale'
  let g:ale_lint_on_insert_leave = 0
Plug 'dkarter/bullets.vim'
" }}}
" Colors {{{
Plug 'cocopon/iceberg.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'romainl/Apprentice'
Plug 'romainl/flattened'
Plug 'NLKNguyen/papercolor-theme'
Plug 'danilo-augusto/vim-afterglow'
Plug 'owickstrom/vim-colors-paramount'
Plug 'romainl/vim-dichromatic'
Plug 'tomasiser/vim-code-dark'
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
set numberwidth=5
" Reload files that are edited externally.
set autoread
au FocusGained,BufEnter * :silent! !
set shiftround
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
" Wrap with one space after a '.'
set nojoinspaces
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
nnoremap <leader>y "*y
nnoremap <leader>p "*p
nnoremap <leader><leader> <c-^>

nnoremap gj :ALENextWrap<cr>
nnoremap gk :ALEPreviousWrap<cr>
nnoremap g1 :ALEFirst<cr>

nnoremap <leader>s :w<cr>
nnoremap <leader>q :q<cr>

nnoremap <silent> L :set number!<CR>:set relativenumber!<CR>

" Save
inoremap <C-s>     <C-O>:w<cr>
noremap <C-s>     :w<cr>

" Quit
inoremap <C-q>     <esc>:q<cr>
nnoremap <C-q>     :q<cr>
vnoremap <C-q>     <esc>

" Windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Multipurpose tab {{{
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col
        return "\<tab>"
    endif

    let char = getline('.')[col - 1]
    if char =~ '\k'
        " There's an identifier before the cursor, so complete the identifier.
        return "\<c-p>"
    else
        return "\<tab>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>
" }}}

" Reference current file's path in commands {{{
cnoremap <expr> %% expand('%:h').'/'
" }}}

" Tags
" g<C-]> shows a menu if >1 match
nnoremap <C-]> g<C-]>
nnoremap g[ :pop<cr>

" Make Y behave like other capitals
nnoremap Y y$

" Make j and k work in wrapped lines
nnoremap j gj
nnoremap k gk

" Markdown headings
" nnoremap <leader>1 m`yypVr=``
" nnoremap <leader>2 m`yypVr-``
" nnoremap <leader>3 m`^i### <esc>``4l
" nnoremap <leader>4 m`^i#### <esc>``5l
" nnoremap <leader>5 m`^i##### <esc>``6l

" Source configs
" nnoremap <leader>sg :echo system('goku')<cr>

nnoremap Q gqip

" }}}
" Visual {{{
set background=dark
colorscheme apprentice

set guifont=IBM\ Plex\ Mono:h14
" Disable scrollbars
set guioptions=
" Disable cursor blinking
set guicursor+=n-v-c:blinkon0

set cursorline
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set list
let &showbreak="↪ "

" Highlight git merge conflict markers using the ErrorMsg highlight group
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

highlight CursorLineNR cterm=bold gui=bold
highlight Todo cterm=bold gui=bold
" TODO: Should this be moved to python?
highlight Statement cterm=bold gui=bold

" From: https://romainl.github.io/the-patient-vimmer/1.html
set statusline=%<\ %f\ %m%r%y%w%=\ L:\ \%l\/\%L\ C:\ \%c\ 
" }}}
" Mini plugins {{{
" Black {{{
function! Black()
    echo system(join(['black', expand('%:p')], ' '))
    execute 'edit'
endfunction

command! Black Black()

nnoremap <silent> <leader>= :<C-U>call Black()<CR>
" }}}
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

function! GrepInnerWord()
    let reg_save = @@
    execute 'normal! "zyiw'
    execute 'cgetexpr Grep(' . shellescape(@@) . ')'
    let @@ = reg_save
endfunction

nnoremap <leader>r :call GrepInnerWord()<cr>

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

" nnoremap <silent> <leader>g :set opfunc=GrepOperator<CR>g@
" vnoremap <silent> <leader>g :<C-U>call GrepOperator(visualmode(), 1)<CR>

" Automatically open the quickfix/location list window on c/lgetexpr.
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost cgetexpr cwindow
    autocmd QuickFixCmdPost lgetexpr lwindow
augroup end

" }}}
" Word count {{{
function! WordCount()
    let word_count = system("wc -w " . @% . " | awk '{ print $1}'")[:-2]
    echo("Word count: " . word_count)
endfunction

command! -nargs=0 WordCount call WordCount()
" }}}
" Open changed files
function! OpenChangedFiles()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\|UU\)" | sed "s/^.\{3\}//"')
  let filenames = split(status, "\n")
  exec "edit " . filenames[0]
  for filename in filenames[1:]
    exec "sp " . filename
  endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()
" }}}

" Disable markdown syntax
autocmd BufRead,BufNewFile {*.markdown,*.mdown,*.mkdn,*.md,*.mkd,*.mdwn,*.mdtxt,*.mdtext,*.text} set filetype=markdown
autocmd FileType markdown setlocal syntax=off spell

lua << EOF
require'lspconfig'.pyright.setup{}
EOF

" Below is taken verbatim from: https://github.com/neovim/nvim-lspconfig
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
EOF

lua <<EOF
require'lsp_signature'.setup({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    hint_prefix = "",
    handler_opts = {
      border = "none",
    }
  })
EOF

set completeopt=menuone,noselect

lua <<EOF
local cmp = require'cmp'
cmp.setup({
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
})
EOF
