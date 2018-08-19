" Status line
" Based on:
" - https://www.vi-improved.org/recommendations/
" - https://shapeshed.com/vim-statuslines/
" - https://github.com/kutsan/dotfiles

function! Git() abort
    if !exists('g:loaded_gina')
	return ''
    endif

    let l:branch = gina#component#repo#branch()

    if l:branch == ''
        return ''
    endif

    let l:branch = ' ' . l:branch
    let l:unstaged = gina#component#status#unstaged() > 0 ? '*' : ''
    let l:staged = gina#component#status#staged() > 0 ? '+' : ''
    let l:statusline = l:branch . l:unstaged . l:staged

    return l:statusline . repeat(' ',4)
endfunction

function! Linter() abort
    if !exists('g:loaded_ale')
        return ''
    endif

    let l:counts = ale#statusline#Count(bufnr(''))

    let l:allerrors = l:counts.error + l:counts.style_error
    let l:allwarnings = l:counts.total - l:allerrors

    return printf(' %d  %d' . repeat(' ',4), l:allerrors, l:allwarnings)
endfunction

function! FilePrefix() abort
    let l:basename = expand('%:h')

    if l:basename ==# '' || l:basename ==# '.'
        return ''
    endif

    return substitute(l:basename . '/', '\C^' . $HOME, '~', '')
endfunction

set statusline=
set statusline+=%{repeat('\ ',1)}

" Git
" <git branch><unstaged marker><staged marker>
set statusline+=%{Git()}

" Linter
" <errors><warnings>
set statusline+=%<                        " Truncate lines to left if too long
set statusline+=%{Linter()}

" File prefix
" path/to/file
set statusline+=%{FilePrefix()}
set statusline+=%t

" Right-alignment
set statusline+=%=

" Lines and columns
" <line>/<total lines>:<column>
set statusline+=%02l/%02L:%02c
