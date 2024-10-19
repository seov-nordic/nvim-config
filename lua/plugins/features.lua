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
      { '<leader>f', '<cmd>Telescope find_files<cr>', desc = 'Telescope find files' },
      { '<leader>g', '<cmd>Telescope live_grep<cr>', desc = 'Telescope live grep' },
      { '<leader>b', '<cmd>Telescope buffers<cr>', desc = 'Telescope buffers' },
      { '<leader>h', '<cmd>Telescope help_tags<cr>', desc = 'Telescope help tags' },
    },
    opts = function() return { defaults = { mappings = { i = {
      -- needs to be a function because 'telescope' modules are not available on first install loading
      ['<C-j>'] = require('telescope.actions').move_selection_next,
      ['<C-k>'] = require('telescope.actions').move_selection_previous,
    }}}} end,
  }
}
