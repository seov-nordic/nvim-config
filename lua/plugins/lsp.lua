return {
  -- COMPLETION
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- snippet engine
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      -- more sources
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require('cmp')

      cmp.setup{
        snippet = {
          -- REQUIRED - snippet engine
          expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
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
        formatting = {
          -- cap entry width so long signatures don't blow up the menu
          -- (and starve the documentation window of horizontal space)
          format = function(_, item)
            local MAX = 30
            if vim.api.nvim_strwidth(item.abbr) > MAX then
              item.abbr = vim.fn.strcharpart(item.abbr, 0, MAX) .. '…'
            end
            if item.menu and vim.api.nvim_strwidth(item.menu) > MAX then
              item.menu = vim.fn.strcharpart(item.menu, 0, MAX) .. '…'
            end
            return item
          end,
        },
        window = {
          documentation = cmp.config.window.bordered(),
          completion = cmp.config.window.bordered(),
        }
      }

      -- SNIPPET mappings
      local map = vim.keymap.set
      local m_opts = { noremap = true, silent = true, expr = true }
      map('i', '<Tab>', function()
        return vim.fn['vsnip#jumpable'](1) == 1 and '<Plug>(vsnip-jump-next)' or '<Tab>'
      end, m_opts)
      map('s', '<Tab>', function()
        return vim.fn['vsnip#jumpable'](1) == 1 and '<Plug>(vsnip-jump-next)' or '<Tab>'
      end, m_opts)
    end,
  },

  -- LSPs
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',  -- cmp source
    },
    config = function()
      vim.diagnostic.config({ virtual_text = true })
      -- global config - add capabilities
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      vim.lsp.config('*', { capabilities = capabilities })
      -- some servers require extra config
      local lsp_setup = require('config.lsp_setup')
      lsp_setup.c()
      lsp_setup.lua()
      -- enable all that I need to start them automatically on buffer enter
      vim.lsp.enable{ 'clangd', 'dts_lsp', 'neocmake', 'lua_ls', 'pylsp', 'bashls', 'rust_analyzer' }
    end,
  },
}
