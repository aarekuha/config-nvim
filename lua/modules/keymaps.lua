local default_opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.g.floaterm_keymap_new = "<M-F9>"

keymap('n', '<C-s>', '<ESC>:write<CR>', default_opts)
keymap('i', '<C-s>', '<ESC>:write<CR>', default_opts)
keymap('n', '<C-q><C-q>', ':qall!<CR>', default_opts)
keymap('n', '<C-q><C-w>', ':wqall!<CR>', default_opts)
keymap('n', '<C-w><C-w>', ':bd<CR>', default_opts)
keymap('n', '<M-j>', '<C-d>', default_opts)
keymap('n', '<M-k>', '<C-u>', default_opts)
keymap('n', '<C-j>', '<C-d>', default_opts)
keymap('n', '<C-k>', '<C-u>', default_opts)
keymap('n', '<F1>', ':bp!<CR>', default_opts)
keymap('n', '<F2>', ':bn!<CR>', default_opts)
keymap('n', 'j', 'gj', default_opts)
keymap('n', 'k', 'gk', default_opts)
keymap('n', '<leader><CR>', ':TagbarToggle<CR>', default_opts)
keymap('n', '<C-n>', ':NERDTreeToggle<CR>', default_opts)
keymap('n', '<leader><C-n>', ':NERDTreeFind<CR>', default_opts)
keymap('n', '<C-f>', ':Telescope live_grep<CR>', default_opts)
keymap('n', '<C-t>', ':Telescope find_files find_command=rg,--ignore,--hidden,--files<CR>', default_opts)
keymap('n', '<Space>', ':HopChar2<CR>', default_opts)
keymap('n', '<leader>cc', "gcc<ESC>", { noremap = false })
keymap('v', '<leader>cc', "gcc<ESC>", { noremap = false })
keymap('v', 'x', '"_d', default_opts)
keymap('n', 'x', '"_d<Right>', default_opts)
keymap('v', 'p', '"_dP', default_opts)
keymap('v', 'P', '"_dp', default_opts)
keymap('n', '<leader>u', ":UndotreeToggle<CR>", default_opts)
keymap('n', '<INS>', ':Git blame<CR>', default_opts)

vim.cmd([[
    let g:VM_maps = {}
    let g:VM_maps['Find Under']         = '<A-n>'   " replace C-n
    let g:VM_maps['Find Subword Under'] = '<A-n>'   " replace visual C-n
    let g:VM_maps["Undo"] = 'u'
    let g:VM_maps["Redo"] = '<C-r>'
    let g:VM_mouse_mappings = 1
    let g:VM_leader = '\'
]])

