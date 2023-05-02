-- Настройки Vim Visual Multi
vim.cmd([[
    let g:VM_maps = {}
    let g:VM_maps['Find Under']         = '<A-n>'   " replace C-n
    let g:VM_maps['Find Subword Under'] = '<A-n>'   " replace visual C-n
    let g:VM_maps["Undo"] = 'u'
    let g:VM_maps["Redo"] = '<C-r>'
    let g:VM_mouse_mappings = 1
]])
