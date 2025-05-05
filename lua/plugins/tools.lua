return {
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
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' }
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
      { '<leader>T', '<cmd>NvimTreeFindFile<cr>', desc = 'Show current file in tree view' },
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
