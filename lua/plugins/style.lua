return {
  -- the colorscheme should be available when starting Neovim
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {
      style = 'moon',
      transparent = true,
      styles = {
        sidebars = 'transparent',
        floats = 'transparent',
      },
      on_highlights = function(hl, c)
        hl.LineNrAbove = { fg = c.fg_dark }
        hl.LineNrBelow = { fg = c.fg_dark }
        hl.CursorLineNr.bg = hl.CursorLine.bg
        hl.SignColumn = { fg = 'white' }
      end,
    },
    config = function(_, opts)
      require('tokyonight').setup(opts)
      vim.cmd.colorscheme 'tokyonight-moon'
    end
  },

  {
    "norcalli/nvim-colorizer.lua",
    lazy = true,
    keys = {
      { "<leader>cl", "<cmd>ColorizerAttachToBuffer<cr>", desc = "Colorizer" },
    },
    opts = {}
  }
}
