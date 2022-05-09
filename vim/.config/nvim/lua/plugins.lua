local packer = nil
local function init()
  if packer == nil then
    packer = require('packer')
    packer.init({ disable_commands = true })
  end

  local use = packer.use
  packer.reset()

  use 'wbthomason/packer.nvim'

  -- Basics

  use 'tpope/vim-commentary'      -- Comment verbs
  use 'tpope/vim-endwise'         -- wisely add "end"
  use 'rstacruz/vim-closer'       -- endwise for brackets
  use 'tpope/vim-eunuch'          -- UNIX shell commands
  use 'tpope/vim-repeat'          -- . command for plugins
  use 'tpope/vim-rsi'             -- Emacs keys in command mode
  use 'tpope/vim-surround'        -- Objects and verbs for "surroundings"
  use 'tpope/vim-vinegar'         -- Enhance netrw (built-in file browser)
  use 'tpope/vim-unimpaired'      -- Convenient mappings on [* and ]*
  use {
    'tpope/vim-fugitive',        -- Git interface
    config = function()
      -- v for vcs
      vim.api.nvim_set_keymap('n', '<leader>v', "<cmd>Git<cr><c-w>o", { noremap = true, silent = true })
      -- TODO: Probably better to use an autocmd for the <c-w>o part?
      -- vim.cmd[[autocmd BufNewFile,BufRead */.git/index :normal <c-w>o]]
    end,
  }
  use 'tpope/vim-sleuth'          -- Infer shiftwidth and expandtab

  use 'romainl/vim-cool'          -- Only highlight while searching

  use 'hynek/vim-python-pep8-indent'

  use {
    'jpalardy/vim-slime',
    config = function()
      vim.g.slime_target = 'tmux'
      vim.g.slime_default_config = { socket_name = 'default', target_pane = '{right}' }
      vim.g.slime_python_ipython = 1
    end,
  }

  use {
    'AndrewRadev/splitjoin.vim',  -- Syntax-aware line split/join 
    config = function()
      vim.g.splitjoin_trailing_comma = 1
      vim.g.splitjoin_python_brackets_on_separate_lines = 1
      vim.g.splitjoin_quiet = 1
    end,
  }

  use {
    'ludovicchabant/vim-gutentags',
    config = function()
      local gutentags_cache_dir = vim.fn.expand('$HOME') .. '/.gutentags'
      vim.fn.system({ 'mkdir', '-p', gutentags_cache_dir})
      vim.g.gutentags_cache_dir = gutentags_cache_dir
    end,
  }

  use {
    'ervandew/supertab',
    config = function()
    end,
  }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { {'nvim-lua/plenary.nvim'}, {'neovim/nvim-lspconfig'} },
    config = function()
      require('null-ls').setup({
        debounce = 100,
        sources = {
          -- JavaScript
          require("null-ls").builtins.formatting.eslint,
          -- Shell
          require("null-ls").builtins.diagnostics.shellcheck,
          -- Lua
          require("null-ls").builtins.formatting.stylua,
          -- Python
          require("null-ls").builtins.diagnostics.flake8,
          require("null-ls").builtins.formatting.black,
          require("null-ls").builtins.formatting.isort,
        },
        on_attach = custom_on_attach,
      })
    end
  }

  use {
    'nvim-telescope/telescope.nvim',  -- Fuzzy finder
    requires = {
      {'nvim-lua/plenary.nvim'},
      {'nvim/telescope/telescope-fzf-native.nvim'},
    },
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>f', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }, previewer = false })<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>b', "<cmd>lua require'telescope.builtin'.buffers()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>g', "<cmd>lua require'telescope.builtin'.live_grep()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>t', "<cmd>lua require'telescope.builtin'.tags()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>h', "<cmd>lua require'telescope.builtin'.help_tags()<cr>", { noremap = true, silent = true })

      local telescope = require('telescope')
      telescope.setup {
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorted = true,
            case_mode = 'smart_case',
          }
        }
      }
      telescope.load_extension('fzf')
    end,
  }

  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
  }

  -- Don't actually use much but would like to

  -- use 'tpope/vim-dispatch'        -- Manage builds
  -- use 'tpope/vim-jdaddy'          -- JSON mappings
  -- use 'tpope/vim-projectionist'   -- Project configuration
  -- use 'tpope/vim-rhubarb'         -- GitHub for fugitive

  -- use 'easymotion/vim-easymotion'

  -- Colorschemes

  use 'cocopon/iceberg.vim'
  use 'romainl/Apprentice'

  -- Language server

  use {
    'neovim/nvim-lspconfig',      -- Simplify lsp configuration
    config = function()
      local nvim_lsp = require('lspconfig')
      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      custom_on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        -- Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { noremap = true, silent = true }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<leader>le', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap('n', 'gk', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', 'gj', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<leader>lq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
      end

      -- nvim-cmp supports additional completion capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

      -- Use a loop to conveniently call 'setup' on multiple servers and
      -- map buffer local keybindings when the language server attaches
      local servers = { 'pyright', 'sqlls', 'terraformls', 'tsserver' }
      -- local servers = { 'terraformls', 'tsserver' }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
          on_attach = custom_on_attach,
          capabilities = capabilities,
        }
      end
    end,
  }
  use {
    'hrsh7th/nvim-cmp',           -- Autocomplete
    config = function()
      vim.o.completeopt = 'menuone,noselect'
      local cmp = require'cmp'
      cmp.setup({
        mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
          ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
        },
        sources = {
          { name = 'nvim_lsp' },
          -- { name = 'buffer' },
        },
      })
    end,
  }
  -- use {
  --   'ray-x/lsp_signature.nvim',   -- Function signature popup with arg highlighting
  --   config = function()
  --     require'lsp_signature'.setup({
  --         bind = true, -- This is mandatory, otherwise border config won't get registered.
  --         hint_prefix = "",
  --         handler_opts = {
  --           border = "none",
  --         }
  --       })
  --   end,
  -- }
  -- Completion sources
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lsp'

  -- Languages

  use 'hashivim/vim-terraform'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
          disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
          additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
        },
        ensure_installed = {'org'}, -- Or run :TSUpdate org
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        indent = {
          enable = true
        },
      }
    end
  }

  -- use {
  --   'ms-jpq/coq_nvim',
  --   branch = 'coq',
  -- }

  -- use {
  --   'dense-analysis/ale',
  --   config = function()
  --     vim.g.ale_fixers = {
  --       python = { 'autoimport', 'isort', 'black' },
  --       sql = {
  --         function()
  --           return { command = 'cat %t | sqlfluff fix -' }
  --         end
  --       },
  --     }

  --     vim.api.nvim_set_keymap('n', 'g1', "<cmd>ALEFirst<cr>", { noremap = true, silent = true })
  --     vim.api.nvim_set_keymap('n', 'gj', "<cmd>ALENextWrap<cr>", { noremap = true, silent = true })
  --     vim.api.nvim_set_keymap('n', 'gk', "<cmd>ALEPreviousWrap<cr>", { noremap = true, silent = true })
  --     vim.api.nvim_set_keymap('n', '<leader>x', "<cmd>ALEFix<cr>", { noremap = true, silent = true })
  --   end,
  -- }

  use {
    'iamcco/markdown-preview.nvim',
    config = function()
    end,
    run = 'cd app && yarn install',
    -- cmd = 'MarkdownPreview',
  }

  use {'nvim-orgmode/orgmode', config = function()
    require('orgmode').setup_ts_grammar()
    require('orgmode').setup({
      org_agenda_files = {'~/gdrive/notes/org/*'},
      -- org_default_notes_file = '~/Dropbox/org/refile.org',
      -- org_ellipsis = '...\r',
    })
    end
  }

end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

return plugins
