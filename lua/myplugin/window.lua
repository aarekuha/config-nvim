local M = {}

local git = require('myplugin.git')
local state = {
  branches = {},
  stashes = {},
  branch_cursor = 1,
  stash_cursor = 1,
  show_branch = true,
}

M.window = nil

-- Создать буферы для отображения
local function create_buffers()
  local buf1 = vim.api.nvim_create_buf(false, true)
  local buf2 = vim.api.nvim_create_buf(false, true)
  return buf1, buf2
end

-- Функция для создания окна
function M.create_window()
  if M.window then
    return
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  M.buf1, M.buf2 = create_buffers()
  M.window = vim.api.nvim_open_win(M.buf1, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'single'
  })

  state.branches = git.get_git_branches(10)
  state.stashes = git.get_git_stashes()
  M.render()
  M.set_keymaps()
end

-- Функция для закрытия окна
function M.close_window()
  if M.window then
    vim.api.nvim_win_close(M.window, true)
    M.window = nil
    M.clear_keymaps()
  end
end

-- Функция для обновления содержимого окна
function M.render()
  if state.show_branch then
    vim.api.nvim_buf_set_lines(M.buf1, 0, -1, false, state.branches)
    vim.api.nvim_buf_add_highlight(M.buf1, -1, 'CursorLine', state.branch_cursor - 1, 0, -1)
  else
    vim.api.nvim_buf_set_lines(M.buf2, 0, -1, false, state.stashes)
    vim.api.nvim_buf_add_highlight(M.buf2, -1, 'CursorLine', state.stash_cursor - 1, 0, -1)
  end
end

-- Переключение между буферами
function M.toggle_view()
  state.show_branch = not state.show_branch
  if state.show_branch then
    vim.api.nvim_win_set_buf(M.window, M.buf1)
  else
    vim.api.nvim_win_set_buf(M.window, M.buf2)
  end
  M.render()
end

-- Навигация в списке веток
function M.navigate_branches(dir)
  if state.show_branch then
    if dir == 'up' then
      state.branch_cursor = math.max(state.branch_cursor - 1, 1)
    else
      state.branch_cursor = math.min(state.branch_cursor + 1, #state.branches)
    end
    M.render()
  end
end

-- Навигация в списке стэшей
function M.navigate_stashes(dir)
  if not state.show_branch then
    if dir == 'up' then
      state.stash_cursor = math.max(state.stash_cursor - 1, 1)
    else
      state.stash_cursor = math.min(state.stash_cursor + 1, #state.stashes)
    end
    M.render()
  end
end

-- Выполнение команды git diff
function M.git_diff()
  local branch = state.branches[state.branch_cursor]
  M.close_window()
  vim.cmd('Git diff ' .. branch)
end

-- Выполнение команды git checkout
function M.git_checkout()
  local branch = state.branches[state.branch_cursor]
  local changes = git.get_git_status()

  if #changes > 0 then
    vim.cmd('echo "Есть изменения. Выполнить git stash? (y/n)"')
    local input = vim.fn.input()
    if input == 'y' then
      vim.cmd('Git stash')
    elseif input == 'n' then
      return
    end
  end

  vim.cmd('Git checkout ' .. branch)
  M.close_window()
end

-- Загрузка дополнительных веток
function M.load_more_branches()
  local more_branches = git.get_git_branches(10, #state.branches)
  for _, branch in ipairs(more_branches) do
    table.insert(state.branches, branch)
  end
  M.render()
end

-- Выполнение команды git stash apply
function M.git_stash_apply()
  local stash = state.stashes[state.stash_cursor]
  vim.cmd('echo "Применить stash? (y/n)"')
  local input = vim.fn.input()
  if input == 'y' then
    vim.cmd('Git stash apply ' .. stash)
  end
end

-- Показ содержимого git stash show
function M.show_stash()
  local stash = state.stashes[state.stash_cursor]
  vim.cmd('split')
  vim.cmd('Git stash show ' .. stash)
end

-- Обновление содержимого окна
function M.git_fetch_all()
  vim.cmd('Git fetch --all')
  state.branches = git.get_git_branches(10)
  state.stashes = git.get_git_stashes()
  M.render()
end

-- Установка локальных маппингов клавиш
function M.set_keymaps()
  vim.api.nvim_buf_set_keymap(M.buf1, 'n', 'j', ':lua require("myplugin.window").navigate_branches("down")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(M.buf1, 'n', 'k', ':lua require("myplugin.window").navigate_branches("up")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(M.buf1, 'n', 'd', ':lua require("myplugin.window").git_diff()<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(M.buf1, 'n', '<CR>', ':lua require("myplugin.window").git_checkout()<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(M.buf1, 'n', 'n', ':lua require("myplugin.window").load_more_branches()<CR>', { noremap = true, silent = true })

  vim.api.nvim_buf_set_keymap(M.buf2, 'n', 'j', ':lua require("myplugin.window").navigate_stashes("down")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(M.buf2, 'n', 'k', ':lua require("myplugin.window").navigate_stashes("up")<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(M.buf2, 'n', '<CR>', ':lua require("myplugin.window").git_stash_apply()<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(M.buf2, 'n', 'o', ':lua require("myplugin.window").show_stash()<CR>', { noremap = true, silent = true })

  vim.api.nvim_buf_set_keymap(M.buf1, 'n', 'h', ':lua require("myplugin.window").toggle_view()<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(M.buf2, 'n', 'l', ':lua require("myplugin.window").toggle_view()<CR>', { noremap = true, silent = true })

  vim.api.nvim_buf_set_keymap(M.buf1, 'n', '<ESC>', ':lua require("myplugin.window").close_window()<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(M.buf2, 'n', '<ESC>', ':lua require("myplugin.window").close_window()<CR>', { noremap = true, silent = true })
end

-- Очистка локальных маппингов клавиш
function M.clear_keymaps()
  vim.api.nvim_buf_del_keymap(M.buf1, 'n', 'j')
  vim.api.nvim_buf_del_keymap(M.buf1, 'n', 'k')
  vim.api.nvim_buf_del_keymap(M.buf1, 'n', 'd')
  vim.api.nvim_buf_del_keymap(M.buf1, 'n', '<CR>')
  vim.api.nvim_buf_del_keymap(M.buf1, 'n', 'n')
  vim.api.nvim_buf_del_keymap(M.buf1, 'n', 'h')
  vim.api.nvim_buf_del_keymap(M.buf1, 'n', '<ESC>')

  vim.api.nvim_buf_del_keymap(M.buf2, 'n', 'j')
  vim.api.nvim_buf_del_keymap(M.buf2, 'n', 'k')
  vim.api.nvim_buf_del_keymap(M.buf2, 'n', '<CR>')
  vim.api.nvim_buf_del_keymap(M.buf2, 'n', 'o')
  vim.api.nvim_buf_del_keymap(M.buf2, 'n', 'l')
  vim.api.nvim_buf_del_keymap(M.buf2, 'n', '<ESC>')
end

return M

