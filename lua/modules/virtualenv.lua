local function find_venv()
    local venv_dirs = {"venv", ".venv"}  -- Список возможных названий директорий
    for _, dir in ipairs(venv_dirs) do
        -- finddir ищет директорию начиная с текущей и поднимаясь вверх по дереву директорий
        local found = vim.fn.finddir(dir, ".")
        if found ~= "" then
            return found
        end
    end
    return nil
end

local has_pyproject = vim.fn.findfile("pyproject.toml", ".", 1) ~= ""
local venv_path = find_venv()
if has_pyproject and venv_path then
    print("Poetry activated")
    require("modules.poetry")
end

