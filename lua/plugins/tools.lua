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
    },
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
  },
}
