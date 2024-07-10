local M = {}
local window = require('myplugin.window')

function M.setup()
  -- Открыть окно
  vim.api.nvim_set_keymap('n', '<ESC>', ':lua require("myplugin.window").create_window()<CR>', { noremap = true, silent = true })
end

return M
