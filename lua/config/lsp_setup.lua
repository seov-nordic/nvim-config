local M = {}
local lsp_cfg = vim.lsp.config

function M.c()
  lsp_cfg('clangd', { cmd = {
    'clangd', '--query-driver', vim.env.HOME .. '/**/bin/arm-*-eabi-gcc,/usr/bin/gcc', '--enable-config',
  } })
end

function M.lua()
  lsp_cfg('lua_ls', {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = {
            'lua/?.lua',
            'lua/?/init.lua',
          },
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
          }
        }
      })
    end,
    settings = {
        Lua = { diagnostics = { globals = { 'vim' } } }
    },
  } )
end

return M
