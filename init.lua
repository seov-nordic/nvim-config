-- vim-options must load before lazy: plugins (e.g. nvim-cmp) read editor
-- options like vim.o.winborder at setup time, which runs during lazy.setup()
require('config.vim-options')

require('config.lazy')

require('config.keymaps')
