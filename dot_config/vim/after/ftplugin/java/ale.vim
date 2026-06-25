if exists('s:loaded')
    finish
endif
let s:loaded = 1

function! s:eclipse_formatter(buffer) abort
    let l:arguments =
    \   ' -nosplash'
    \ . ' -data /tmp'
    \ . ' -application org.eclipse.jdt.core.JavaCodeFormatter'
    \ . ' -quiet'
    \ . ' -config '
    \ . expand('$HOME') . '/.config/vim/eclipse/org.eclipse.jdt.core.prefs '

    silent! execute
    \   '!eclipse'
    \ . l:arguments
    \ . expand('%:s')
    \ . ' 1> /dev/null 2>&1'
    " redraw!

    return 0
endfunction


" ALE Fixers {{{ ---------------------------------------------------------------
let b:ale_fixers = get(b:, 'ale_fixers', [funcref('s:eclipse_formatter')])

" It takes a while for the formatting to be processed
if len(b:ale_fixers) > 0
    let b:ale_fix_on_save = 0
endif
" ALE Fixers }}} ---------------------------------------------------------------
