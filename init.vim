" only basic stuff here, e.g. number, relativenumber, etc.
" source ~/.vimrc
set relativenumber
set number
set incsearch
" tabstop:          Width of tab character
" softtabstop:      Fine tunes the amount of white space to be added
" shiftwidth        Determines the amount of whitespace to add in normal mode
" expandtab:        When this option is enabled, vi will use spaces instead of tabs
set tabstop     =4
set softtabstop =4
set shiftwidth  =4
set expandtab


" ----------------------------------------------------- PLUGINS -----------------------------------------------------
call plug#begin()

" LSP with auto-completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" File system explorer
Plug 'preservim/nerdtree'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'  " Default commands

" Markdown browser preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Auto-save plugin
Plug 'Pocco81/auto-save.nvim'

" Colorschemes
Plug 'romgrk/doom-one.vim'
Plug 'flazz/vim-colorschemes'

" Pretty tabs
Plug 'nvim-tree/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'

" Debugging (incomplete configuration)
Plug 'mfussenegger/nvim-dap', {'tag': '0.6.0'}
Plug 'jedrzejboczar/nvim-dap-cortex-debug'
Plug 'rcarriga/nvim-dap-ui'

" Simple git highlights
Plug 'airblade/vim-gitgutter'

" Codeium AI assistant
" Plug 'Exafunction/codeium.vim', { 'branch': 'main' }

" GitHub Copilot - have to set copilot_no_tab_map here because otherwise the annoying tab mapping persists
let g:copilot_no_tab_map = v:true
Plug 'github/copilot.vim'
" Copilot chat - needs a python3 provider
let g:python3_host_prog = '/usr/bin/python3'
Plug 'CopilotC-Nvim/CopilotChat.nvim'

call plug#end()
" ----------------------------------------------------- PLUGINS -----------------------------------------------------

" lua code
" TODO: write lua init instead of vimscript, organise into modules
lua << EOF
-- Copilot chat setup
  require('CopilotChat').setup({
    debug = false,
    show_help = 'yes',
    prompts = {
      Explain = 'Explain how it works.',
      Review = 'Review the following code and provide concise suggestions.',
      Tests = 'Briefly explain how the selected code works, then generate unit tests.',
      Refactor = 'Refactor the code to improve clarity and readability.',
    },
    build = function()
      vim.notify('Please update the remote plugins by running :UpdateRemotePlugins, then restart Neovim.')
    end,
    event = 'VeryLazy',
  })

  local cmp = require'cmp'

    cmp.setup({
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            ['<Tab>'] = cmp.mapping.select_next_item(),
            ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' }, -- For vsnip users.
        }, {
            { name = 'buffer' },
        })
    })

    -- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    -- cmp.setup.cmdline({ '/', '?' }, {
    --     mapping = cmp.mapping.preset.cmdline(),
    --     sources = {
    --         { name = 'buffer' }
    --     }
    -- })

    -- -- Use path source for ':'
    -- cmp.setup.cmdline({ ':' }, {
    --     mapping = cmp.mapping.preset.cmdline(),
    --     sources = {
    --         { name = 'path' }
    --     }
    -- })

    -- additional capabilities supported by nvim-cmp
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    -- python to use for mypy
    local venv_path = os.getenv('VIRTUAL_ENV')
    local py_path = nil
    if venv_path ~= nil then
        py_path = venv_path .. "/bin/python"
    else
        py_path = vim.g.python3_host_prog
    end
    -- Enable LSPs with cmp capabilities
    require'lspconfig'.clangd.setup{
        cmd = { 'clangd', '--query-driver', '/opt/gcc-arm-none-eabi/bin/arm-none-eabi-gcc', '--enable-config' },
        capabilities = capabilities,
    }
    require'lspconfig'.pylsp.setup{
        settings = {
            pylsp = {
                configurationSources = {'flake8', 'black'},
                plugins = {
                    black = {enabled = true, line_length=120},
                    flake8 = {enabled = true, indentSize=4, maxLineLength=120, ignore={'D10','W503'}},
                    isort = {enabled = true, profile='black'},
                    pylsp_mypy = {
                        enabled = true,
                        overrides = { "--python-executable", py_path, true },
                        report_progress = true,
                        live_mode = false
                    },
                    -- disable other linters (is it necessary?)
                    autopep8 = {enabled = false},
                    pycodestyle = {enabled = false},
                    pydocstyle = {enabled = false},
                    pylint = {enabled = false},
                    rope_autoimport = {enabled = false},
                    rope_completion = {enabled = false}
                }
            }
        },
        capabilities = capabilities,
    }

    -- configure cortex-debug
    local dap_cortex_debug = require('dap-cortex-debug')
    dap_cortex_debug.setup {
        debug = false,  -- log debug messages
        -- path to cortex-debug extension, supports vim.fn.glob
        extension_path = '/home/seov/.local/bin/cortex-debug/extension/',
        lib_extension = nil, -- tries auto-detecting, e.g. 'so' on unix
        node_path = 'node', -- path to node.js executable
        dapui_rtt = false, -- register nvim-dap-ui RTT element
        dap_vscode_filetypes = { 'c', 'cpp' }, -- make :DapLoadLaunchJSON register cortex-debug for C/C++, set false to disable
    }

    -- configure dap with cortex-debug adapter
    local dap = require('dap')
    dap.configurations.c = {
        dap_cortex_debug.jlink_config {
            name = 'Attach to JLinkGDBServer at :2331',
            cwd = '${workspaceFolder}',
            executable = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            device = function()
                return vim.fn.input('-device ', 'Cortex-M4')
            end,
            serverArgs = function()
                return { '-select', vim.fn.input('-select ', 'USB=') }
            end,
            rttConfig = { enabled = false },
            interface = 'swd',
            toolchainPath = '/opt/gcc-arm-none-eabi/bin',
        },
    }

--    require('dapui').setup {
--        layouts = {
--            {
--                position = 'left',
--                size = 96,
--                elements = {
--                    { id = 'scopes', size = 0.4 },
--                },
--            },
--            -- (...)
--        },
--    }

EOF
" back to vimscript "

" style stuff "
autocmd VimEnter * colorscheme doom-one
autocmd VimEnter * set termguicolors
autocmd VimEnter * highlight EndOfBuffer guibg=none
autocmd VimEnter * highlight Normal guibg=none
autocmd VimEnter * highlight CursorLine guibg=none
autocmd VimEnter * windo set colorcolumn=121
