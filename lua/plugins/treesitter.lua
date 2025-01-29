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

}
