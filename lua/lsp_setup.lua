local M = {}
local lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

function M.c()
  lsp.clangd.setup{
    cmd = { 'clangd', '--query-driver', '/opt/**/bin/arm-*-eabi-gcc,/usr/bin/gcc', '--enable-config' },
    capabilities = capabilities,
  }
end

function M.lua()
  lsp.lua_ls.setup{
    capabilities = capabilities,
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT'
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            vim.env.HOME .. '/.local/share/nvim/lazy/plenary.nvim',
          }
        }
      })
    end,
    settings = {
      Lua = {}
    }
  }
end

function M.rust()
  lsp.rust_analyzer.setup{ capabilities = capabilities }
end

function M.python()
  lsp.basedpyright.setup{
    cmd = { 'basedpyright-langserver', '--stdio', '--level error'},
    capabilities = capabilities,
    settings = {
      basedpyright = {
        typeCheckingMode = "standard",
      },
    },
  }
end

function M.fish()
  lsp.fish_lsp.setup{ capabilities = capabilities }
end

function M.cmake()
  lsp.neocmake.setup{ capabilities = capabilities }
end

return M
