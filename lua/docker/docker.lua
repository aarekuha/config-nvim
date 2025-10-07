local M = {}

local function get_docker_containers()
    local handle = io.popen("docker ps -a --format '{{.Names}}: {{.Status}}'")
    local containers = {}
    for container in handle:lines() do
        table.insert(containers, container)
    end
    handle:close()
    return containers
end

local function toggle_container(container_name)
    local handle = io.popen("docker inspect -f '{{.State.Status}}' " .. container_name)
    local status = handle:read("*a"):gsub("%s+", "")

    handle:close()

    if status == "running" then
        os.execute("docker stop " .. container_name .. " > /dev/null 2>&1")
    else
        os.execute("docker start " .. container_name .. " > /dev/null 2>&1")
    end
end

local function create_popup(containers)
    local popup_buf = vim.api.nvim_create_buf(false, true)
    local popup_win = vim.api.nvim_open_win(popup_buf, true, {
        relative = 'editor',
        width = math.floor(vim.o.columns * 0.80),
        height = math.floor(vim.o.lines * 0.60),
        col = vim.o.columns / 2 - math.floor((vim.o.columns * 0.80) / 2),
        row = vim.o.lines / 2 - (vim.o.lines * 0.60 / 2),
        style = 'minimal',
        border = 'single'
    })

    vim.api.nvim_buf_set_lines(popup_buf, 0, -1, false, containers)
    vim.api.nvim_buf_set_option(popup_buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(popup_buf, 'bufhidden', 'wipe')

    local function update_highlight()
        vim.api.nvim_buf_clear_namespace(popup_buf, 0, 0, -1)
        local cursor = vim.api.nvim_win_get_cursor(popup_win)[1]
        vim.api.nvim_buf_add_highlight(popup_buf, 0, 'CursorLine', cursor - 1, 0, -1)
    end

    local function on_enter()
        local line = vim.api.nvim_win_get_cursor(popup_win)[1]
        local container_info = containers[line]
        local container_name = container_info:match("([^:]+)")
        toggle_container(container_name)
        -- vim.api.nvim_win_close(popup_win, true)
        containers = get_docker_containers()
        -- Update buffer with new container list
        vim.api.nvim_buf_set_lines(popup_buf, 0, -1, false, containers)
        -- Optionally, you may want to reapply highlights and ensure cursor is correctly positioned
        update_highlight()
    end

    local function on_escape()
        vim.api.nvim_win_close(popup_win, true)
    end

    local function on_up()
        local cursor = vim.api.nvim_win_get_cursor(popup_win)
        if cursor[1] > 1 then
            cursor[1] = cursor[1] - 1
            vim.api.nvim_win_set_cursor(popup_win, cursor)
            update_highlight()
        end
    end

    local function on_down()
        local cursor = vim.api.nvim_win_get_cursor(popup_win)
        if cursor[1] < #containers then
            cursor[1] = cursor[1] + 1
            vim.api.nvim_win_set_cursor(popup_win, cursor)
            update_highlight()
        end
    end

    vim.api.nvim_buf_set_keymap(popup_buf, 'n', '<CR>', '', { noremap = true, silent = true, callback = on_enter })
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', '<ESC>', '', { noremap = true, silent = true, callback = on_escape })
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', '<leader><ESC>', '', { noremap = true, silent = true, callback = on_escape })
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', 'q', '', { noremap = true, silent = true, callback = on_escape })
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', '<Up>', '', { noremap = true, silent = true, callback = on_up })
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', 'k', '', { noremap = true, silent = true, callback = on_up })
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', 'j', '', { noremap = true, silent = true, callback = on_down })
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', '<Down>', '', { noremap = true, silent = true, callback = on_down })

    vim.api.nvim_command('highlight PopupCursorLine guifg=white')

    vim.api.nvim_buf_set_option(popup_buf, 'winhighlight', 'Normal:PopupHighlight,CursorLine:PopupCursorLine')
    update_highlight()
end

function M.show_popup()
    local containers = get_docker_containers()
    create_popup(containers)
end

vim.api.nvim_set_keymap('n', '<leader><ESC>', ':lua require("docker.docker").show_popup()<CR>', { noremap = true, silent = true })

return M
