local keymap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

-- general
-- 1. <C-u> and <C-d> should center
keymap('n', '<C-u>', '<C-u>zz', default_opts)
keymap('n', '<C-d>', '<C-d>zz', default_opts)
-- 2. <C-c> removes highlighting
keymap('n', '<C-c>', ':noh<CR>', default_opts)
-- 3. <C-q> deletes current buffer and switches to the previous one
keymap('n', '<C-q>', ':bp | bd#<CR>', default_opts)
-- 4. Y yanks to system clipboard
keymap('n', 'Y', '"+y', default_opts)
keymap('v', 'Y', '"+y', default_opts)

-- switch b/w tabs/buffers
keymap('n', '<C-l>', ':bnext<CR>', default_opts)
keymap('n', '<C-h>', ':bprevious<CR>', default_opts)

-- <Leader>s -> FZF
keymap('n', '<Leader>s', ':FZF<CR>', default_opts)

-- <Leader>t -> NERDTree
keymap('n', '<Leader>t', ':NERDTreeToggle<CR>', default_opts)

-- dap mappings
vim.keymap.set('n', '<F5>',         function() require('dap').continue() end)
vim.keymap.set('n', '<F10>',        function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>',        function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>',        function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>b',    function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>dr',   function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl',   function() require('dap').run_last() end)

-- Codeium bindings: 1. rebind "accept" to <C-a> as the default <Tab> is *shit*
-- vim.g.codeium_no_map_tab = 1
-- vim.keymap.set('i', '<C-a>', function() return vim.fn['codeium#Accept']() end, { expr = true })

-- coc configurations:  UNUSED ATM
--   1. remap <cr> for autocompletion
-- inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
-- keymap('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "<CR>"', { silent = true, expr = true, noremap=true })
--   2. use <Tab> and <S-Tab> to navigate the completion list
-- inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
-- inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
-- keymap('i', '<Tab>', 'coc#pum#visible() ? coc#pum#next(1) : "<Tab>"', { silent = true, expr = true, noremap=true })
-- keymap('i', '<S-Tab>', 'coc#pum#visible() ? coc#pum#prev(1) : "<S-Tab>"', { silent = true, expr = true, noremap=true })

-- GitHub Copilot bindings: 1. rebind "accept" to <C-a> as the default <Tab> is *shit*
keymap('i', '<C-a>', 'copilot#Accept("")', { silent = true, expr = true, noremap=true })

-- NEW COMMANDS --
-- function to sync with remote ssh server
local _server = nil
local _remote_reporoot = nil

function sync(server, filepath, remote_reporoot)
    local reporoot = io.popen('git rev-parse --show-toplevel'):read('*l')
    local relative_filepath = string.gsub(filepath, reporoot, '')
    if server == nil then
        if _server == nil then
            _server = vim.fn.input('Server: ', 'node-test-')
        end
        server = _server
    end
    if remote_reporoot == nil then
        if _remote_reporoot == nil then
            _remote_reporoot = vim.fn.input('Remote repo root: ', '/home/seov/')
        end
        remote_reporoot = _remote_reporoot
    end
    local cmd = 'scp '..filepath..' '..server..':'..remote_reporoot..''..relative_filepath
    return io.popen(cmd):read('*a')
end

function sync_current(server, remote_reporoot)
    sync(server, vim.api.nvim_buf_get_name(0), remote_reporoot)
end
