setlocal foldmethod=marker

augroup vim_help
    autocmd!
    autocmd BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup end

vnoremap <buffer> <localleader>S y:@"<CR>
nnoremap <buffer> <localleader>S ^vg_y:execute @@<cr>:echo 'Sourced line.'<cr>
