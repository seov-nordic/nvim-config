return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { 'c', 'lua', 'python', 'rust', 'markdown', 'cmake', 'kconfig' },
      sync_install = true,
      auto_install = true,
      highlight = { enable = true },
      -- indent = { enable = true },
    },
    config = function(_, opts)
      -- vim.opt.smartindent = false
      require('nvim-treesitter.configs').setup(opts)
    end,
    build = ':TSUpdate'
  },

  {
    'nvim-treesitter/nvim-treesitter-context'
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            -- You can optionally set descriptions to the mappings (used in the desc parameter of
            -- nvim_buf_set_keymap) which plugins like which-key display
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            -- You can also use captures from other query groups like `locals.scm`
            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
          },
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end
  },

  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      -- required
      'nvim-lua/plenary.nvim',
      -- suggested
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
      -- optional
      'nvim-tree/nvim-web-devicons',
      'nvim-treesitter/nvim-treesitter',
    },
    keys = {
      { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Telescope find files' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Telescope live grep' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Telescope buffers' },
      { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Telescope help tags' },
      { '<leader>fr', '<cmd>Telescope resume<cr>', desc = 'Telescope resume' },

      { '<leader>jr', function() require('telescope.builtin').lsp_references() end, desc = 'Jump to / list reference(s)' },
      { '<leader>jd', function() require('telescope.builtin').lsp_definitions() end, desc = 'Jump to / list definition(s)' },
      { '<leader>ji', function() require('telescope.builtin').lsp_implementations() end, desc = 'Jump to / list implementation(s)' },
    },
    cmd = { 'Telescope' },
    opts = function()
      -- needs to be a function because 'telescope' modules are not available on first install loading
      local actions = require('telescope.actions')
      local setup_opts = { defaults = { mappings = {} } }
      setup_opts.defaults.mappings.i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<Esc>'] = actions.close,
      }
      return setup_opts
    end,
  },

  {
    'tpope/vim-fugitive',
    lazy = true,
    keys = {
      { '<leader>gs', '<cmd>Git<cr>', desc = 'Git status' },
    },
    cmd = { 'G' },
  },

  {
    'nvim-tree/nvim-tree.lua',
    lazy = true,
    keys = {
      { '<leader>t', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle file tree view' },
    },
    opts = {},
  },

  {
    'iamcco/markdown-preview.nvim',
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    init = function()
      vim.g.mkdp_auto_close = 0
    end,
  },

  {
    'nmac427/guess-indent.nvim',
    opts = {},
  },
}
