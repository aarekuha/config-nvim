local vim = _G.vim

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "pyright", "ts_ls" }, -- свои сервера сюда
  automatic_installation = true,
  handlers = {
    -- дефолт для всех серверов
    function(server)
      require("lspconfig")[server].setup({})
    end,

    -- пример точечной настройки
    lua_ls = function()
      require("lspconfig").lua_ls.setup({
        settings = {
          Lua = { diagnostics = { globals = { "vim" } } }
        }
      })
    end,
  },
})

local function _unique_locs(locs)
  local seen, out = {}, {}
  for _, loc in ipairs(locs) do
    local uri = loc.uri or loc.targetUri
    local range = (loc.range or loc.targetSelectionRange or loc.targetRange).start
    local key = string.format("%s:%d:%d", uri, range.line, range.character)
    if not seen[key] then
      seen[key] = true
      table.insert(out, loc)
    end
  end
  return out
end

local function goto_def_unique()
  local pos = vim.api.nvim_win_get_cursor(0)
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(0),
    position = { line = pos[1] - 1, character = pos[2] },
  }
  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx, _)
    if err or not result then return end
    local locs = vim.islist(result) and result or { result }
    locs = _unique_locs(locs)
    local enc = (vim.lsp.get_client_by_id(ctx.client_id) or {}).offset_encoding or "utf-16"
    if #locs == 1 then
      vim.lsp.util.show_document(locs[1], enc, { focus = true })
    else
      vim.fn.setqflist(vim.lsp.util.locations_to_items(locs, enc))
      vim.cmd("copen")
    end
  end)
end

require("neodev").setup({
    library = {
        enabled = true,
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
   group = vim.api.nvim_create_augroup("user.lsp.keys", {}),
   callback = function(ev)
     local opts = { buffer = ev.buf, noremap = true, silent = true }
     local map = function(lhs, rhs) vim.keymap.set("n", lhs, rhs, opts) end
     map("<leader>D", vim.lsp.buf.declaration)
     map("<leader>d", goto_def_unique)
     map("<leader>n", vim.lsp.buf.references)
     map("<leader>k", vim.lsp.buf.hover)
     map("<leader>s", vim.lsp.buf.signature_help)
     map("<leader>r", vim.lsp.buf.rename)
     map("<leader>i", vim.lsp.buf.implementation)
   end,
})

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require("cmp")

cmp.setup({
    completion = {
        completeopt = "menu,menuone,noinsert",
        autocomplete = false
    },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<C-l>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    -- ["<Tab>"] = function(fallback)
    --   if cmp.visible() then
    --     cmp.select_next_item()
    --   else
    --     fallback()
    --   end
    -- end,
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
})

require("Comment").setup({})
require("hop").setup { keys = "ghfjdksla" }

vim.lsp.config("*", {
   capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.lsp.config("clangd", {})
vim.lsp.config("ccls", {})

-- Только для pyright добавляем объявление динамического наблюдения
local py_caps = require("cmp_nvim_lsp").default_capabilities()
py_caps.workspace = py_caps.workspace or {}
py_caps.workspace.didChangeWatchedFiles = { dynamicRegistration = true }
py_caps.workspace.fileOperations = {
  dynamicRegistration = true,
  willRename = true, didRename = true,
  willCreate = true, didCreate = true,
  willDelete = true, didDelete = true,
}

vim.lsp.config("pyright", {
   capabilities = py_caps,
   flags = { debounce_text_changes = 150 },
   on_init = function(client)
     client.config.settings = client.config.settings or {}
     client.config.settings.python = client.config.settings.python or {}
     if vim.env.VIRTUAL_ENV ~= nil then
       client.config.settings.python.pythonPath = vim.env.VIRTUAL_ENV .. "/bin/python"
     else
       client.config.settings.python.pythonPath = "/home/alex/.pyenv/shims/python"
     end
   end,
})

vim.lsp.config("lua_ls", {
   before_init = require("neodev.lsp").before_init,
   settings = {
     Lua = {
       diagnostics = { globals = { "vim" } },
     },
   },
})

vim.lsp.enable({ "clangd", "pyright", "lua_ls" })

local function compare_to_clipboard()
  local ftype = vim.api.nvim_eval("&filetype")
  vim.cmd(string.format([[
    execute "normal! \"xy"
    vsplit
    enew
    normal! P
    setlocal buftype=nowrite
    set filetype=%s
    diffthis
    execute "normal! <C-w><C-w>"
    enew
    set filetype=%s
    normal! "xP
    diffthis
  ]], ftype, ftype))
end

vim.keymap.set('v', '<C-d>', compare_to_clipboard)

require('lsp_signature').setup({
  bind = true,
  floating_window = true,
  hint_enable = false,          -- если не хочешь inline-хинтов
  toggle_key = nil,
  hi_parameter = 'IncSearch',   -- подсветка текущего аргумента
  zindex = 50,
})
--
-- === Два независимых "resume": для live_grep и find_files ===
local tb = require('telescope.builtin')

-- Память запроса только в RAM на текущую сессию
local hist = {
  live_grep  = nil,
  find_files = nil,
}

-- безопасный вызов live_grep_args если есть, иначе live_grep
local function call_live_grep(opts)
  local ok, ext = pcall(function() return require('telescope').extensions.live_grep_args end)
  if ok and ext and ext.live_grep_args then
    ext.live_grep_args(opts or {})
  else
    tb.live_grep(opts or {})
  end
end

-- Обёртка: открыть пикер, подставить прошлый запрос, запомнить новый при Enter/закрытии
local function open_with_history(kind, picker_fn, opts)
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  opts = opts or {}
  opts.default_text = hist[kind] or ""

  opts.attach_mappings = function(_, map)
    local function save_and(fn)
      return function(prompt_bufnr)
        hist[kind] = action_state.get_current_line()
        return fn(prompt_bufnr)
      end
    end
    -- сохраняем и при выборе, и при выходе
    map('i', '<CR>',  save_and(actions.select_default))
    map('n', '<CR>',  save_and(actions.select_default))
    map('i', '<Esc>', save_and(actions.close))
    map('n', 'q',     save_and(actions.close))
    return true
  end

  picker_fn(opts)
end

-- Ctrl-f: первый раз — чистый live_grep; дальше — с прошлым запросом (как «resume»)
vim.keymap.set('n', '<C-f>', function()
  open_with_history('live_grep', function(o) call_live_grep(o) end, {
    -- добавь свои дефолтные флаги, если нужны
    additional_args = function() return { "--hidden" } end,
  })
end, { desc = 'Smart live_grep с автоподстановкой прошлого запроса' })

-- Ctrl-t: аналогично для find_files
vim.keymap.set('n', '<C-t>', function()
  open_with_history('find_files', tb.find_files, {
    -- пример: скрытые файлы и не уважать .gitignore
    hidden = true,
    no_ignore = true,
  })
end, { desc = 'Smart find_files с автоподстановкой прошлого запроса' })
