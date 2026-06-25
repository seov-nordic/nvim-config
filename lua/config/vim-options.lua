local o = vim.o
local wo = vim.wo

o.number = true
o.relativenumber = true
o.cursorline = true
o.winborder = 'single'

o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true

wo.colorcolumn = '101,121'

-- set frequently used file types to known by neovim (may be used by e.g. treesitter, lsp)
vim.api.nvim_create_autocmd('BufEnter' , { pattern = "*.overlay", command = "set filetype=dts" })
vim.api.nvim_create_autocmd('BufEnter' , { pattern = "*enkinsfile", command = "set filetype=groovy" })
