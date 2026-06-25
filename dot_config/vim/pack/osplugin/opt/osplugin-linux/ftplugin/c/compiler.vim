if !( filereadable( expand('%:p:h') . ( g:windows ? '\/Makefile' : '/Makefile' ) ) )
    noremap <buffer> <silent> <F9> :silent update <bar>silent make %:p:r.out<cr><cr>
    noremap <buffer> <silent> <F10> :!'%:p:r.out'<cr>
else
    noremap <buffer> <silent> <F9> :silent update <bar>silent make <cr><cr>
    noremap <buffer> <silent> <F10> :!make run<cr>
endif
