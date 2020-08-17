" Enable visual wrapping
set wrap linebreak nolist
" Disable hard line wrapping
set textwidth=0
set tabstop=3
" set background=light
" colorscheme PaperColor
set colorcolumn=80
let g:markdown_folding = 1
" Gives us nice folding but breaks ctrl-i...
nnoremap <buffer> <tab> za
nnoremap <buffer> <expr> <s-tab> &foldlevel ? 'zM' :'zR'
