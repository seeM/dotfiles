setlocal textwidth=100
nnoremap <silent> K :call jedi#show_documentation()<CR><C-w>k<C-w>Hzz

" Configure vim-slime for ipython.
" See: https://github.com/jpalardy/vim-slime/tree/master/ftplugin/python
let g:slime_python_ipython = 1
