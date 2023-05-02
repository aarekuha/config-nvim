vim.cmd([[
    " Устанавливает последнее положение курсора, при открытии файла (last cursor position)
    autocmd BufRead * autocmd FileType <buffer> ++once
    \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif

    " Удаление пробелов в конце строк при сохранении
    autocmd BufWritePre * :%s/\s\+$//e
]])
