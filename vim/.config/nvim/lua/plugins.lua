return require('packer').startup(function()

  use 'wbthomason/packer.nvim'

  -- Basics

  use 'tpope/vim-commentary'      -- Comment verbs
  use 'tpope/vim-endwise'         -- wisely add "end"
  use 'tpope/vim-eunuch'          -- UNIX shell commands
  use 'tpope/vim-repeat'          -- . command for plugins
  use 'tpope/vim-rsi'             -- Emacs keys in command mode
  use 'tpope/vim-surround'        -- Objects and verbs for "surroundings"
  use 'tpope/vim-vinegar'         -- Enhance netrw (built-in file browser)
  use 'tpope/vim-unimpaired'      -- Convenient mappings on [* and ]*
  use 'tpope/vim-fugitive'        -- Git interface
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
    'jose-elias-alvarez/null-ls.nvim',
    requires = { {'nvim-lua/plenary.nvim'}, {'neovim/nvim-lspconfig'} },
    config = function()
      local null_ls = require('null-ls')
      null_ls.config({
        debounce = 100,
        sources = {
          -- JavaScript
          null_ls.builtins.formatting.eslint,
          -- Shell
          null_ls.builtins.diagnostics.shellcheck,
          -- Lua
          null_ls.builtins.formatting.stylelua,
          -- Python
          null_ls.builtins.diagnostics.flake8,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.diagnostics.flake8,
        },
      })
      require('lspconfig')['null-ls'].setup {
        on_attach = custom_on_attach,
        capabilities = capabilities,
      }
    end
  }

  use {
    'nvim-telescope/telescope.nvim',  -- Fuzzy finder
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require'telescope.builtin'.buffers()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require'telescope.builtin'.live_grep()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>ft', "<cmd>lua require'telescope.builtin'.tags()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>fs', "<cmd>lua require'telescope.builtin'.lsp_workspace_symbols()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>fr', "<cmd>lua require'telescope.builtin'.lsp_references()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>fd', "<cmd>lua require'telescope.builtin'.lsp_definitions()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>f/', "<cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>lua require'telescope.builtin'.help_tags()<cr>", { noremap = true, silent = true })

      vim.api.nvim_set_keymap('n', '<leader>gs', "<cmd>lua require'telescope.builtin'.git_status()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>gl', "<cmd>lua require'telescope.builtin'.git_commits()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>gc', "<cmd>lua require'telescope.builtin'.git_bcommits()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>gb', "<cmd>lua require'telescope.builtin'.git_branches()<cr>", { noremap = true, silent = true })
    end,
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
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<leader>lq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
      end

      -- nvim-cmp supports additional completion capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

      -- Use a loop to conveniently call 'setup' on multiple servers and
      -- map buffer local keybindings when the language server attaches
      local servers = { 'pyright', 'terraformls', 'tsserver' }
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
          { name = 'buffer' },
        },
      })
    end,
  }
  use {
    'ray-x/lsp_signature.nvim',   -- Function signature popup with arg highlighting
    config = function()
      require'lsp_signature'.setup({
          bind = true, -- This is mandatory, otherwise border config won't get registered.
          hint_prefix = "",
          handler_opts = {
            border = "none",
          }
        })
    end,
  }
  -- Completion sources
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lsp'

  -- Languages

  use 'hashivim/vim-terraform'

end)
