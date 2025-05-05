local M = {}
local lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local border = {
  {'🭽', 'FloatBorder'},
  {'▔', 'FloatBorder'},
  {'🭾', 'FloatBorder'},
  {'▕', 'FloatBorder'},
  {'🭿', 'FloatBorder'},
  {'▁', 'FloatBorder'},
  {'🭼', 'FloatBorder'},
  {'▏', 'FloatBorder'},
}
local handlers = {
  ['textDocument/hover'] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border}),
  ['textDocument/signatureHelp'] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border }),
}

function M.c()
  lsp.clangd.setup{
    capabilities = capabilities,
    handlers = handlers,
    cmd = { 'clangd', '--query-driver', '/opt/**/bin/arm-*-eabi-gcc,/usr/bin/gcc', '--enable-config' },
  }
end

function M.lua()
  lsp.lua_ls.setup{
    capabilities = capabilities,
    handlers = handlers,
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
    },
  }
end

function M.rust()
  lsp.rust_analyzer.setup{ capabilities = capabilities, handlers = handlers }
end

function M.python()
  lsp.pylsp.setup{ capabilities = capabilities, handlers = handlers }
end

function M.fish()
  lsp.fish_lsp.setup{ capabilities = capabilities, handlers = handlers }
end

function M.bash()
  lsp.bashls.setup{ capabilities = capabilities, handlers = handlers }
end

function M.cmake()
  lsp.neocmake.setup{ capabilities = capabilities, handlers = handlers }
end

return M
