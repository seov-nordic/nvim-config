return {
  -- COMPLETION
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- snippet engine
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      -- more sources
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require('cmp')

      cmp.setup{
        snippet = {
          -- REQUIRED - snippet engine
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        window = {
          documentation = cmp.config.window.bordered(),
          completion = cmp.config.window.bordered(),
        }
      }

      -- SNIPPET mappings
      local map = vim.keymap.set
      local m_opts = { noremap = true, silent = true, expr = true }
      map('i', '<Tab>', function()
        return vim.fn["vsnip#jumpable"](1) == 1 and "<Plug>(vsnip-jump-next)" or "<Tab>"
      end, m_opts)
      map('s', '<Tab>', function()
        return vim.fn["vsnip#jumpable"](1) == 1 and "<Plug>(vsnip-jump-next)" or "<Tab>"
      end, m_opts)
    end,
  },

  -- fix cmp-nvim-lsp to a specific commit still compatible with neovim 0.10.4
  {
    'hrsh7th/cmp-nvim-lsp',
    commit = 'a8912b88ce488f411177fc8aed358b04dc246d7b',
  },

  -- LSPs
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    version = '2.5.0',
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",  -- cmp source
    },
    config = function()
      vim.diagnostic.config({ virtual_text = true })
      local lsp_setup = require('lsp_setup')
      lsp_setup.c()
      lsp_setup.lua()
      lsp_setup.rust()
      lsp_setup.python()
      lsp_setup.bash()
      lsp_setup.cmake()
    end,
  },
}
