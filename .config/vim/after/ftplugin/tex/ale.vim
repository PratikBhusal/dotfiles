if exists('s:loaded')
    finish
endif
let s:loaded = 1


" ALE Fixers {{{ ---------------------------------------------------------------
let b:ale_fixers = get(b:, 'ale_fixers', [])

" if executable('latexindent')
"     call add(b:ale_fixers, 'latexindent')
" endif
if executable('textlint')
    call add(b:ale_fixers, 'textlint')
endif

" It takes a while for the formatting to be processed
if len(b:ale_fixers) > 0
    let b:ale_fix_on_save = 0
endif
" ALE Fixers }}} ---------------------------------------------------------------
