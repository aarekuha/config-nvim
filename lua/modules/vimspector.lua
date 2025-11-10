local M = {}

function M.init()
    vim.g.vimspector_enable_mappings = 'HUMAN'
end

function M.setup()
    local default_opts = { noremap = false, silent = true }
    local keymap = vim.api.nvim_set_keymap
    keymap('n', '<C-ESC>', ':VimspectorReset<CR>', default_opts)
    keymap('n', '<F7>', '<Plug>VimspectorBalloonEval', default_opts)
    keymap('n', '<F8>', '<Plug>VimspectorRunToCursor', default_opts)
end

return M
