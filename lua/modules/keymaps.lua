local default_opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.g.floaterm_keymap_new = "<M-F9>"

keymap('n', '<C-s>', '<ESC>:write<CR>', default_opts)
keymap('n', '<C-ы>', '<ESC>:write<CR>', default_opts)
keymap('i', '<C-s>', '<ESC>:write<CR>', default_opts)
keymap('i', '<C-ы>', '<ESC>:write<CR>', default_opts)
keymap('n', '<C-q><C-q>', ':qall!<CR>', default_opts)
keymap('n', '<C-й><C-й>', ':qall!<CR>', default_opts)
keymap('n', '<C-q><C-w>', ':wqall!<CR>', default_opts)
keymap('n', '<C-й><C-ц>', ':wqall!<CR>', default_opts)
keymap('n', '<C-w><C-w>', ':bd<CR>', default_opts)
keymap('n', '<C-ц><C-ц>', ':bd<CR>', default_opts)
keymap('n', '<M-о>', '<C-d>', default_opts)
keymap('n', '<M-j>', '<C-d>', default_opts)
keymap('n', '<M-л>', '<C-u>', default_opts)
keymap('n', '<M-k>', '<C-u>', default_opts)
keymap('n', '<F1>', ':bp!<CR>', default_opts)
keymap('n', '<F2>', ':bn!<CR>', default_opts)
keymap('n', 'j', 'gj', default_opts)
keymap('n', 'k', 'gk', default_opts)
keymap('n', '<leader><CR>', ':TagbarToggle<CR>', default_opts)
keymap('n', '<C-n>', ':NERDTreeToggle<CR>', default_opts)
keymap('n', '<C-т>', ':NERDTreeToggle<CR>', default_opts)
keymap('n', '<leader><C-n>', ':NERDTreeFind<CR>', default_opts)
keymap('n', '<leader><C-т>', ':NERDTreeFind<CR>', default_opts)
keymap('n', '<Space>', ':HopChar2<CR>', default_opts)
keymap('n', '<leader>cc', "gcc<ESC>", { noremap = false })
keymap('n', '<leader>сс', "gcc<ESC>", { noremap = false })
keymap('v', '<leader>cc', "gcc<ESC>", { noremap = false })
keymap('v', '<leader>сс', "gcc<ESC>", { noremap = false })
keymap('v', 'x', '"_d', default_opts)
keymap('n', 'x', '"_d<Right>', default_opts)
keymap('v', 'p', '"_dP', default_opts)
keymap('v', 'P', '"_dp', default_opts)
keymap('n', '<leader>u', ":UndotreeToggle<CR>", default_opts)

vim.cmd([[
    let g:VM_maps = {}
    let g:VM_maps['Find Under']         = '<A-n>'   " replace C-n
    let g:VM_maps['Find Subword Under'] = '<A-n>'   " replace visual C-n
    let g:VM_maps["Undo"] = 'u'
    let g:VM_maps["Redo"] = '<C-r>'
    let g:VM_mouse_mappings = 1
    let g:VM_leader = '\'
]])

-- Git figitive
keymap('n', '<leader>gg', ':Git<CR>', default_opts)
keymap('n', '<leader>пп', ':Git<CR>', default_opts)
keymap('n', '<leader>gb', ':Git blame<CR>', default_opts)
keymap('n', '<leader>пи', ':Git blame<CR>', default_opts)
keymap('n', '<leader>gd', ':Gvdiff<CR>', default_opts)
keymap('n', '<leader>пв', ':Gvdiff<CR>', default_opts)
keymap('n', '<leader>gl', ':Gclog<CR>', default_opts)
keymap('n', '<leader>пд', ':Gclog<CR>', default_opts)
keymap('n', '<leader>gc', ':Git commit -m ""<LEFT>', default_opts)
keymap('n', '<leader>пс', ':Git commit -m ""<LEFT>', default_opts)
keymap('n', '<leader>gp', ':Git push<CR>', default_opts)
keymap('n', '<leader>пз', ':Git push<CR>', default_opts)
keymap('n', '<leader>gs', ':Telescope git_stash<CR>', default_opts)
keymap('n', '<leader>пы', ':Telescope git_stash<CR>', default_opts)
keymap('n', '<C-b>', ':Telescope git_branches<CR>', default_opts)
keymap('n', '<C-и>', ':Telescope git_branches<CR>', default_opts)
