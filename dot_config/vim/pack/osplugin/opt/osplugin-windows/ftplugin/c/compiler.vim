if !( filereadable( expand('%:p:h') . ( g:windows ? '\/Makefile' : '/Makefile' ) ) )
    noremap <buffer> <silent> <F9> :silent update <bar>silent make %:p:r.exe<cr><cr>

    if has('nvim')
        noremap <buffer> <silent> <F10> :!%:p:r.exe<cr>
    else
        noremap <buffer> <silent> <F10> :!%:p:r.exe<cr><cr>
    endif
else
    noremap <buffer> <silent> <F9> :silent update <bar>silent make <cr><cr>
    noremap <buffer> <silent> <F10> :!make run<cr><cr>
endif
