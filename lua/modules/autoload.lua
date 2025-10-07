-- Настрой, что попадёт в сессию
vim.o.sessionoptions = table.concat({
  "buffers",   -- открытые буферы
  "curdir",    -- текущая директория
  "tabpages",  -- табы
  "winsize",   -- размеры окон
  "winpos",    -- позиция окна GUI (не мешает в TUI)
  "folds",     -- фолды
  "help",      -- help-буферы
  "globals",   -- переменные g:
  -- "terminal", -- если надо восстанавливать терминалы (нестабильно)
}, ",")

-- Папка для сессий
local sessions_dir = vim.fn.stdpath("state") .. "/sessions"
vim.fn.mkdir(sessions_dir, "p")

-- Имя файла из cwd (без двоеточий и слэшей)
local function session_file_for_cwd(cwd)
  local name = (cwd or vim.loop.cwd()):gsub("[:/\\]", "%%")
  return string.format("%s/%s.vim", sessions_dir, name)
end

-- Сохранение сессии; silent, чтобы не спамить
local function save_session()
  local file = session_file_for_cwd()
  -- Пропускаем headless и когда нет нормальных буферов
  if #vim.api.nvim_list_bufs() == 0 then return end
  vim.cmd("silent! mksession! " .. vim.fn.fnameescape(file))
  vim.g._last_session_file = file
end

-- Автосохранение при выходе
vim.api.nvim_create_autocmd("VimLeavePre", {
  desc = "Автосохранение сессии при выходе",
  callback = function()
    pcall(save_session)
  end,
})

-- Команда для редкой загрузки последней сессии
vim.api.nvim_create_user_command("SessionLoadLast", function()
  local file = vim.g._last_session_file or session_file_for_cwd()
  if vim.fn.filereadable(file) == 1 then
    vim.cmd("silent! source " .. vim.fn.fnameescape(file))
  else
    vim.notify("Сессии нет: " .. file, vim.log.levels.WARN)
  end
end, { desc = "Загрузить последнюю автосессию" })

-- Опционально: список доступных сессий и выбор
vim.api.nvim_create_user_command("SessionList", function()
  local files = vim.fn.glob(sessions_dir .. "/*.vim", false, true)
  if #files == 0 then
    vim.notify("Нет сохранённых сессий", vim.log.levels.INFO)
    return
  end
  -- Простой выбор через inputlist
  local items = { "Выбери сессию для загрузки:" }
  for i, f in ipairs(files) do items[#items+1] = string.format("%d) %s", i, f) end
  local choice = vim.fn.inputlist(items)
  if choice >= 1 and choice <= #files then
    vim.cmd("silent! source " .. vim.fn.fnameescape(files[choice]))
  end
end, { desc = "Выбрать и загрузить сессию" })

