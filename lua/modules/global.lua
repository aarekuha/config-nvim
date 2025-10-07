vim.g.python3_host_prog = "/usr/bin/python"
vim.cmd([[
    " Устанавливает последнее положение курсора, при открытии файла (last cursor position)
    autocmd BufRead * autocmd FileType <buffer> ++once
    \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif
    " Удаление пробелов в конце строк при сохранении
    autocmd BufWritePre * :%s/\s\+$//e
]])

local neowords = require("neowords")
local p = neowords.pattern_presets

local hops = neowords.get_word_hops(
  p.snake_case,
  p.camel_case,
  p.upper_case,
  p.number,
  p.hex_color,
  "\\v\\.+",
  "\\v,+"
)

vim.keymap.set({ "n", "x", "o" }, "w", hops.forward_start)
vim.keymap.set({ "n", "x", "o" }, "e", hops.forward_end)
vim.keymap.set({ "n", "x", "o" }, "b", hops.backward_start)
vim.keymap.set({ "n", "x", "o" }, "ge", hops.backward_end)
