return {
  -- COMPLETION
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-vsnip",  -- snippet engine
      "hrsh7th/vim-vsnip",  -- snippet engine
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

  -- LSPs
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",  -- cmp source
    },
    config = function()
      local lsp = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      lsp.clangd.setup{
        cmd = { 'clangd', '--query-driver', '/opt/gcc-arm-none-eabi/bin/arm-none-eabi-gcc', '--enable-config' },
        capabilities = capabilities,
      }
    end,
  }
}
