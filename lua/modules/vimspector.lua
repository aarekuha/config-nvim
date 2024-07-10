vim.cmd([[
    let g:vimspector_enable_mappings = 'HUMAN'
    let g:vimspector_install_gadgets = [ 'debugpy' ]
    let g:vimspector_enable_mappings
    nmap <leader>q :VimspectorReset<CR>
    nmap <leader>v <Plug>VimspectorBalloonEval
]])
