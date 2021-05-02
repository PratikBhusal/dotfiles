if !( filereadable( expand('%:p:h') . ( g:windows ? '\/Makefile' : '/Makefile' ) ) )
    setlocal makeprg=g++\ -Wall\ -fexceptions\ -g\ -O3\ -Wcast-align\ -Wundef\
        \ -Wnon-virtual-dtor\ -Wshadow\ -Winit-self\ -Wredundant-decls\ -Wextra\
        \ -Wfloat-equal\ -Winline\ -Wunreachable-code\ -Wmissing-declarations\
        \ -Wmissing-include-dirs\ -Wswitch-enum\ -Wswitch-default\ -Wmain\
        \ -Wzero-as-null-pointer-constant\ -pedantic-errors\ -pedantic\
        \ %:p\ -o
else
    noremap <buffer> <silent> <F10> :!make run<cr>
endif

" -std=c++11
" -Weffc++
" -Wfatal-errors
