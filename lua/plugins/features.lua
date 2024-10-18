return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { 'c', 'lua', 'python', 'rust', 'markdown', 'cmake', 'kconfig' },
      sync_install = true,
      auto_install = true,
      highlight = { enable = true },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
    build = ':TSUpdate'
  },

  {
    'nvim-treesitter/nvim-treesitter-context'
  },

  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-treesitter/nvim-treesitter',
    },
  }
}
