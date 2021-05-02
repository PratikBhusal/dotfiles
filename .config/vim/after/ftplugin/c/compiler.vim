if !( filereadable( expand('%:p:h') . ( g:windows ? '\/Makefile' : '/Makefile' ) ) )
    setlocal makeprg=gcc\ -Wall\ -fexceptions\ -g\ -O3\ -Wcast-align\ -Wundef\
        \ -Wshadow\ -Winit-self\ -Wredundant-decls\ -Wextra\
        \ -Wfloat-equal\ -Winline\ -Wunreachable-code\ -Wmissing-declarations\
        \ -Wmissing-include-dirs\ -Wswitch-enum\ -Wswitch-default\ -Wmain\
        \ -pedantic-errors\ -pedantic\
        \ %:p\ -o
else
    noremap <buffer> <silent> <F9> :silent update <bar>silent make <cr><cr>
endif
