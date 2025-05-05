local o = vim.o
local wo = vim.wo

o.number = true
o.relativenumber = true
o.cursorline = true

o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true

wo.colorcolumn = '121'

vim.api.nvim_create_autocmd('BufEnter' , { pattern = "*.overlay", command = "set filetype=devicetree" })
vim.api.nvim_create_autocmd('BufEnter' , { pattern = "*enkinsfile", command = "set filetype=groovy" })
