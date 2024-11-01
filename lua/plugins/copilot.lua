return {

  {
    'zbirenbaum/copilot.lua',
    lazy = true,
    cmd = { "Copilot" },
    opts = {
      suggestion = {
        auto_trigger = true,
        hide_during_completion = false,
        keymap = {
          accept = "<M-a>",
          accept_word = "<M-w>",
          accept_line = "<M-l>",
        },
      },
    },
  },

  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      'zbirenbaum/copilot.lua',
      'nvim-lua/plenary.nvim',
    },
    lazy = true,
    cmd = { "CopilotChat" },
    build = "make tiktoken",
    opts = {},
  },

}
