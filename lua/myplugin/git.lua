local M = {}

-- Получить список веток Git
function M.get_git_branches(limit, offset)
  offset = offset or 0
  local handle = io.popen('git branch --sort=-committerdate -r | tail -n +' .. (offset + 1) .. ' | head -n ' .. limit)
  local result = handle:read("*a")
  handle:close()
  local branches = {}
  for branch in string.gmatch(result, "[^\r\n]+") do
    table.insert(branches, branch)
  end
  return branches
end

-- Получить список git stash
function M.get_git_stashes()
  local handle = io.popen('git stash list')
  local result = handle:read("*a")
  handle:close()
  local stashes = {}
  for stash in string.gmatch(result, "[^\r\n]+") do
    table.insert(stashes, stash)
  end
  return stashes
end

-- Проверка наличия изменений в текущей ветке
function M.get_git_status()
  local handle = io.popen('git status --porcelain')
  local result = handle:read("*a")
  handle:close()
  local changes = {}
  for change in string.gmatch(result, "[^\r\n]+") do
    table.insert(changes, change)
  end
  return changes
end

return M

