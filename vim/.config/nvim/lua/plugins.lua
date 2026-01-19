return {
  -- Basics
  'tpope/vim-commentary',      -- Comment verbs
  'tpope/vim-endwise',           -- wisely add "end"
  'rstacruz/vim-closer',         -- endwise for brackets
  'tpope/vim-eunuch',            -- UNIX shell commands
  'tpope/vim-repeat',            -- . command for plugins
  'tpope/vim-rsi',               -- Emacs keys in command mode
  'tpope/vim-surround',          -- Objects and verbs for "surroundings"
  'tpope/vim-vinegar',           -- Enhance netrw (built-in file browser)
  'tpope/vim-unimpaired',        -- Convenient mappings on [* and ]*
  'tpope/vim-ragtag',            -- HTML tag completion
  {
    'tpope/vim-fugitive',        -- Git interface
    config = function()
      -- v for vcs
      vim.api.nvim_set_keymap('n', '<leader>v', "<cmd>Git<cr><c-w>o", { noremap = true, silent = true })
      -- TODO: Probably better to use an autocmd for the <c-w>o part?
      -- vim.cmd[[autocmd BufNewFile,BufRead */.git/index :normal <c-w>o]]
    end,
  },
  'tpope/vim-sleuth',            -- Infer shiftwidth and expandtab

  {
    'github/copilot.vim',
    cond = not_in_vscode,
  },

  'romainl/vim-cool',            -- Only highlight while searching

  {
    'hynek/vim-python-pep8-indent',
    cond = function() return vim.g.vscode == nil end,
  },

  {
    'jpalardy/vim-slime',
    config = function()
      vim.g.slime_target = 'tmux'
      vim.g.slime_default_config = { socket_name = 'default', target_pane = '{right}' }
      vim.g.slime_python_ipython = 1
    end,
  },

  {
    'AndrewRadev/splitjoin.vim',  -- Syntax-aware line split/join 
    config = function()
      vim.g.splitjoin_trailing_comma = 1
      vim.g.splitjoin_python_brackets_on_separate_lines = 1
      vim.g.splitjoin_quiet = 1
    end,
  },

  -- NOTE: Causes a hang on exit in large repos
  -- {
  --   'ludovicchabant/vim-gutentags',
  --   config = function()
  --     local gutentags_cache_dir = vim.fn.expand('$HOME') .. '/.gutentags'
  --     vim.fn.system({ 'mkdir', '-p', gutentags_cache_dir})
  --     vim.g.gutentags_cache_dir = gutentags_cache_dir
  --   end,
  -- },

  {
    'ervandew/supertab',
    commit = '6ce779367e2c4947367fcce401b77251d2bb47ab',
    config = function()
    end,
  },

  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
      'nvimtools/none-ls-extras.nvim',
    },
    cond = not_in_vscode,
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        debounce = 100,
        sources = {
          -- JavaScript
          require("none-ls.diagnostics.eslint"),
          -- Lua
          null_ls.builtins.formatting.stylua,
          -- Python
          -- null_ls.builtins.diagnostics.flake8,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
        },
        on_attach = custom_on_attach,
      })
    end
  },

  {
    'nvim-telescope/telescope.nvim',  -- Fuzzy finder
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    cond = not_in_vscode,
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
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    cond = not_in_vscode,
    build = 'make',
  },

  -- Don't actually use much but would like to

  -- 'tpope/vim-dispatch',        -- Manage builds
  -- 'tpope/vim-jdaddy',          -- JSON mappings
  -- 'tpope/vim-projectionist',   -- Project configuration
  -- 'tpope/vim-rhubarb',         -- GitHub for fugitive

  -- 'easymotion/vim-easymotion',

  -- Colorschemes

  {
    'cocopon/iceberg.vim',
    lazy = false,  -- Load immediately since it's the main colorscheme
    priority = 1000, -- Load before other plugins
    config = function()
      vim.cmd[[colorscheme iceberg]]
    end,
  },
  'romainl/Apprentice',

  -- Language server

  {
    'neovim/nvim-lspconfig',      -- Simplify lsp configuration
    cond = function() return vim.g.vscode == nil end,
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
        buf_set_keymap('n', '<leader>le', '<cmd>lua vim.diagnostic.open_float({source = "always"})<CR>', opts)
        buf_set_keymap('n', 'gk', '<cmd>lua vim.diagnostic.goto_prev({float = {source = "always"}})<CR>', opts)
        buf_set_keymap('n', 'gj', '<cmd>lua vim.diagnostic.goto_next({float = {source = "always"}})<CR>', opts)
        buf_set_keymap('n', '<leader>lq', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
        buf_set_keymap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
      end

      -- nvim-cmp supports additional completion capabilities
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Use a loop to conveniently call 'setup' on multiple servers and
      -- map buffer local keybindings when the language server attaches
      local servers = { 'sqlls', 'terraformls', 'tsserver', 'bashls', 'ruff' }
      for _, lsp in ipairs(servers) do
        vim.lsp.enable(lsp)
        vim.lsp.config(lsp, {
          on_attach = custom_on_attach,
          capabilities = capabilities,
        })
      end
      vim.lsp.enable('pyright')
      vim.lsp.config('pyright', {
        on_attach = custom_on_attach,
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "off"
            }
          }
        }
      })
      vim.lsp.enable('eslint')
      vim.lsp.config('eslint', {
        on_attach = custom_on_attach,
        capabilities = capabilities,
        settings = {
          experimental = {
            useFlatConfig = true
          }
        }
      })
    end,
  },
  {
    'hrsh7th/nvim-cmp',           -- Autocomplete
    cond = not_in_vscode,
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
  },
  -- {
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
  -- },
  -- Completion sources
  {
    'hrsh7th/cmp-buffer',
    cond = not_in_vscode,
  },
  {
    'hrsh7th/cmp-nvim-lsp',
    cond = not_in_vscode,
  },

  -- Languages

  'hashivim/vim-terraform',

  -- {
  --   'nvim-treesitter/nvim-treesitter',
  --   build = ':TSUpdate',
  --   config = function()
  --     require('nvim-treesitter.configs').setup {
  --       highlight = {
  --         enable = true,
  --         disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
  --         additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
  --       },
  --       ensure_installed = {'org'}, -- Or run :TSUpdate org
  --       incremental_selection = {
  --         enable = true,
  --         keymaps = {
  --           init_selection = "gnn",
  --           node_incremental = "grn",
  --           scope_incremental = "grc",
  --           node_decremental = "grm",
  --         },
  --       },
  --       indent = {
  --         enable = true
  --       },
  --     }
  --   end
  -- },

  -- {
  --   'ms-jpq/coq_nvim',
  --   branch = 'coq',
  -- },

  -- {
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
  -- },

  {
    'iamcco/markdown-preview.nvim',
    cond = not_in_vscode,
    config = function()
    end,
    build = 'cd app && yarn install',
    -- cmd = 'MarkdownPreview',
  },
}
