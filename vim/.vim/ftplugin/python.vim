setlocal textwidth=100
nnoremap <silent> K :call jedi#show_documentation()<CR><C-w>k<C-w>Hzz
imap  ->

" From: https://github.com/garybernhardt/dotfiles/blob/7e0f353bca25b07d2ef9bcae2070406e3d4ac029/.vimrc#L311-L329
function! ExtractVariable()
    let name = input("Variable name: ")
    if name == ''
        return
    endif
    " Enter visual mode (not sure why this is needed since we're already in
    " visual mode anyway)
    normal! gv

    " Replace selected text with the variable name
    exec "normal c" . name
    " Define the variable on the line above
    exec "normal! O" . name . " = "
    " Paste the original selected text to be the variable value
    normal! $p
endfunction

vnoremap <leader>rv :call ExtractVariable()<cr>

" From: https://github.com/garybernhardt/dotfiles/blob/7e0f353bca25b07d2ef9bcae2070406e3d4ac029/.vimrc#L331-L355
function! InlineVariable()
    " Copy the variable under the cursor into the 'a' register
    :let l:tmp_a = @a
    :normal "ayiw
    " Delete variable and equals sign
    :normal 2daW
    " Delete the expression into the 'b' register
    :let l:tmp_b = @b
    :normal "bd$
    " Delete the remnants of the line
    :normal dd
    " Go to the end of the previous line so we can start our search for the
    " usage of the variable to replace. Doing '0' instead of 'k$' doesn't
    " work; I'm not sure why.
    normal k$
    " Find the next occurence of the variable
    exec '/\<' . @a . '\>'
    " Replace that occurence with the text we yanked
    exec ':.s/\<' . @a . '\>/' . escape(@b, "/")
    :let @a = l:tmp_a
    :let @b = l:tmp_b
endfunction

nnoremap <leader>ri :call InlineVariable()<cr>

" Configure vim-slime for ipython.
" See: https://github.com/jpalardy/vim-slime/tree/master/ftplugin/python
let g:slime_python_ipython = 1
