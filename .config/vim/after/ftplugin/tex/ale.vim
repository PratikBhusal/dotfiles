" ALE Fixers {{{ ---------------------------------------------------------------
let b:ale_fixers = get(b:, 'ale_fixers', [])

if executable('latexindent')
    call add(b:ale_fixers, 'latexindent')
endif

" if len(b:ale_fixers) > 0
"     let g:ale_fix_on_save = 1
" endif
" ALE Fixers }}} ---------------------------------------------------------------
