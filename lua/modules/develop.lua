require("neodev").setup({
    library = {
        enabled = true,
    },
    lspconfig = true,
})

local default_opts = { noremap = true, silent = true }

local on_attach = function(client, bufnr)
    local keymap = vim.api.nvim_buf_set_keymap
    keymap(bufnr, "n", "<leader>D", "<cmd>lua vim.lsp.buf.declaration()<CR>", default_opts)
    keymap(bufnr, "n", "<leader>d", "<cmd>lua vim.lsp.buf.definition()<CR>", default_opts)
    keymap(bufnr, "n", "<leader>n", "<cmd>lua vim.lsp.buf.references()<CR>", default_opts)
    keymap(bufnr, "n", "<leader>k", "<cmd>lua vim.lsp.buf.hover()<CR>", default_opts)
    keymap(bufnr, "n", "<leader>s", "<cmd>lua vim.lsp.buf.signature_help()<CR>", default_opts)
    keymap(bufnr, "n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", default_opts)
    keymap(bufnr, "n", "<leader>i", "<cmd>lua vim.lsp.buf.implementation()<CR>", default_opts)
end

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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.offsetEncoding = "utf-8"

local lsp = require("lspconfig")

lsp.clangd.setup({
    on_attach=on_attach,
    capabilities = capabilities,
})

lsp.ccls.setup{
    on_attach=on_attach,
    capabilities = capabilities,
}

lsp.pyright.setup({
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    },
    venvPath = "/home/alex/.cache/pypoetry/virtualenvs",
    venv = "cyberstudio-batchmq-JMgety6E-py3.11",
    on_init = function(client)
        print(vim.env.VIRTUAL_ENV)
        client.config.settings.python.pythonPath = vim.env.VIRTUAL_ENV .. "/bin/python"
    end,
})

lsp.lua_ls.setup{
    on_attach=on_attach,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }
            }
        }
    }
}
