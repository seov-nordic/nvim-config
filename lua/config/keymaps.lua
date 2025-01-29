local function map(mode, lhs, rhs, extra_opts)
  local opts = { noremap = true, silent = true }
  if extra_opts ~= nil then
    opts = vim.tbl_extend('force', opts, extra_opts)
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- buffer ops
map('n', '<C-q>', vim.cmd.bdel)
map('n', '<C-l>', vim.cmd.bnext)
map('n', '<C-h>', vim.cmd.bprevious)

map('n', '<C-c>', vim.cmd.noh)

-- yanking to system clipboard
map('n', 'Y', '"+y')
map('v', 'Y', '"+y')

-- movement
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
