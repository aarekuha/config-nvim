local default_opts = { noremap = false, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap('n', '<leader>`', ':FloatermToggle<CR>', default_opts)
keymap('n', '<leader>ё', ':FloatermToggle<CR>', default_opts)
keymap('t', '<leader>`', '<C-\\><C-n>:FloatermToggle<CR>', default_opts)
keymap('t', '<leader>ё', '<C-\\><C-n>:FloatermToggle<CR>', default_opts)
keymap('t', '<leader><TAB>', '<C-\\><C-n>:FloatermNext<CR>', default_opts)
keymap('n', '<leader><BS>', ':FloatermNew<CR>', default_opts)
keymap('t', '<leader><BS>', '<C-\\><C-n>:FloatermNew<CR>', default_opts)
