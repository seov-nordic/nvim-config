local HEADER_SHADOW = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]

local HEADER_LEAN = [[
    _/      _/  _/_/_/_/    _/_/    _/      _/  _/_/_/  _/      _/
   _/_/    _/  _/        _/    _/  _/      _/    _/    _/_/  _/_/
  _/  _/  _/  _/_/_/    _/    _/  _/      _/    _/    _/  _/  _/
 _/    _/_/  _/        _/    _/    _/  _/      _/    _/      _/
_/      _/  _/_/_/_/    _/_/        _/      _/_/_/  _/      _/]]

local HEADER_SPEED = [[
_____   ____________________    ______________  ___
___  | / /__  ____/_  __ \_ |  / /___  _/__   |/  /
__   |/ /__  __/  _  / / /_ | / / __  / __  /|_/ /
_  /|  / _  /___  / /_/ /__ |/ / __/ /  _  /  / /
/_/ |_/  /_____/  \____/ _____/  /___/  /_/  /_/]]

local HEADERS = { HEADER_SHADOW, HEADER_LEAN, HEADER_SPEED }

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
  },

  {
    "echasnovski/mini.nvim", version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local starter = require("mini.starter")
      math.randomseed(os.time())
      local header = HEADERS[math.random(1, 3)]
      starter.setup{
        header = header,
        items = {
          starter.sections.telescope(),
          starter.sections.builtin_actions(),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(),
          starter.gen_hook.aligning('center', 'center'),
        },
      }
      require("mini.diff").setup()
      require("mini.git").setup()
      require("mini.statusline").setup()
    end
  },
}
