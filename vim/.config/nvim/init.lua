-- Plugin manager
-------------------------------------------------------------------------------

-- Bootstrap packer (plugin manager)
local fn = vim.fn
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Basics
-------------------------------------------------------------------------------

-- Set focus to the newly splitted window when using :sp or :vsp.
vim.o.splitbelow = true
vim.o.splitright = true

-- Do not save when switching buffers
vim.o.hidden = true

-- Enable mouse
vim.o.mouse = 'a'

-- Indent (>>) and dedent (<<) with 4 spaces
-- TODO: Disabled while trying vim-sleuth
-- vim.o.shiftwidth = 4
-- <Tab> and <BS> are worth shiftwidth spaces.
-- TODO: Disabled while trying vim-sleuth
-- vim.o.softtabstop = vim.o.shiftwidth
-- Disable conversion of 'tabstop' spaces to a \t character, they remain spaces.
-- TODO: Disabled while trying vim-sleuth
-- vim.o.expandtab = true

vim.o.sidescroll = 5

-- Wrap with one space after a '.'
vim.o.joinspaces = true

-- TODO: Are these still needed?
vim.o.modeline = false
vim.o.lazyredraw = true
vim.o.ttyfast = true
vim.o.shiftround = true
vim.o.formatoptions = 'qrn1j'

vim.o.undofile = true
vim.o.backup = true
vim.o.swapfile = false
-- TODO: Update these with nvim dir
vim.o.undodir = vim.fn.expand('$HOME') .. '/.vim/tmp/undo//'
vim.o.backupdir = vim.fn.expand('$HOME') .. '/.vim/tmp/backup//'
vim.o.directory = vim.fn.expand('$HOME') .. '/.vim/tmp/swap//'

-- Automatically reload files that are edited externally
vim.o.autoread = true
vim.cmd [[au FocusGained,BufEnter * :silent! !]]

vim.g.python3_host_prog = 'python'


-- Colorscheme
-------------------------------------------------------------------------------

vim.o.termguicolors = true
vim.cmd [[colorscheme iceberg]]
vim.o.cursorline = true
vim.o.listchars = [[tab:» ,extends:›,precedes:‹,nbsp:·,trail:·]]
vim.o.tabstop = 4
vim.o.list = true
vim.o.showbreak = '↪ '

-- Highlight git merge conflict markers using the ErrorMsg highlight group
vim.cmd [[match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$']]

-- Misc visual changes
vim.cmd [[highlight CursorLineNR cterm=bold gui=bold]]
vim.cmd [[highlight Todo cterm=bold gui=bold]]
vim.cmd [[highlight Statement cterm=bold gui=bold]]

-- Status line
-------------------------------------------------------------------------------

vim.o.statusline=[[%< %f %m%r%y%w%= L: %l/%L C: %c ]]

-- Mappings
-------------------------------------------------------------------------------

vim.api.nvim_set_keymap('n', '<leader>y', '"*y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>p', '"*p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader><leader>', '<c-^>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>s', ':w<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':q<cr>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'L', ':set number!<cr>:set relativenumber!<cr>', { noremap = true, silent = true })

-- Window movement
vim.api.nvim_set_keymap('n', '<c-h>', '<c-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<c-j>', '<c-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<c-k>', '<c-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<c-l>', '<c-w>l', { noremap = true, silent = true })

-- Reference current file's path in commands
vim.api.nvim_set_keymap('c', '%%', "expand('%:h').'/'", { noremap = true, expr = true, silent = true })

-- Avoid g<C-]> shows a menu if >1 match
vim.api.nvim_set_keymap('n', '<c-]>', 'g<c-]>', { noremap = true, silent = true })

-- Make Y behave like other capitals
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'Q', 'gqip', { noremap = true, silent = true })

-- TODO: Use language server
-- vim.api.nvim_set_keymap('n', 'gj', ':ALENextWrap', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', 'gk', ':ALEPreviousWrap', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', 'g1', ':ALEFirst', { noremap = true, silent = true })

-- Smoothly move over wrapped lines
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- TODO: Need this?
-- vim.cmd [[au FocusGained,BufEnter * :silent! !]]


-- Custom commands
-------------------------------------------------------------------------------

-- Grep to quickfix/location list
-- Source: https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3

if vim.fn.executable('rg') > 0 then
  vim.o.grepprg = [[rg --vimgrep --case-sensitive]]
else
  vim.o.grepprg = [[git grep -n --column]]
end

function Grep(...)
  local args = nil
  if type(...) == 'table' then
    args = ...
  else
    args = { ... }
  end
  args = table.concat(args, ' ')
  args = vim.fn.expandcmd(args)
  args = table.concat({ vim.o.grepprg, args }, ' ')
  return vim.fn.system(args)
end

vim.cmd[[
" Create commands Grep (populates quickfix list) and LGrep (populates location list)
command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr v:lua.Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr v:lua.Grep(<f-args>)

" Autocorrect grep to Grep and lgrep to LGrep
cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

" Automatically open the quickfix/local list when cgetexpr/lgetexpr are called
augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost cgetexpr cwindow
  autocmd QuickFixCmdPost lgetexpr lwindow
augroup END
]]

-- Grep inner word. Useful for finding references to a symbol

function GrepInnerWord()
  local unnamed_register = vim.fn.getreg('"')
  vim.api.nvim_command([[normal! "zyiw]])
  vim.api.nvim_command([[cgetexpr v:lua.Grep(]] .. vim.fn.shellescape(vim.fn.getreg('"')) .. ')')
  vim.fn.setreg('"', unnamed_register)
end

vim.api.nvim_set_keymap('n', '<leader>r', ':call v:lua.GrepInnerWord()<cr>', { noremap = true, silent = true })

-- Word count

function WordCount()
  local current_file = vim.fn.getreg('%')
  local word_count = vim.fn.system('wc -w ' .. current_file .. " | awk '{ print $1 }'")
  word_count = word_count:sub(0, #word_count - 2)
  print('Word count: ' .. word_count)
end

vim.cmd[[command! -nargs=0 WordCount call v:lua.WordCount()]]

vim.cmd[[
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
]]

-- Packer commands

vim.cmd [[command! PackerInstall packadd packer.nvim | lua require('plugins').install()]]
vim.cmd [[command! PackerUpdate packadd packer.nvim | lua require('plugins').update()]]
vim.cmd [[command! PackerSync packadd packer.nvim | lua require('plugins').sync()]]
vim.cmd [[command! PackerClean packadd packer.nvim | lua require('plugins').clean()]]
vim.cmd [[command! PackerCompile packadd packer.nvim | lua require('plugins').compile()]]
