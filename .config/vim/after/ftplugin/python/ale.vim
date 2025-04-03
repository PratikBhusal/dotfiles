" ALE Linters {{{ --------------------------------------------------------------
let b:ale_linters = get(b:, 'ale_linters', [])

if executable('mypy') && index(b:ale_linters, 'mypy') == -1
    call add(b:ale_linters, 'mypy')
    let g:ale_python_mypy_options = '--no-pretty --show-error-codes'
endif
if executable('bandit') && index(b:ale_linters, 'bandit') == -1
    call add(b:ale_linters, 'bandit')
endif

if executable('vulture') && index(b:ale_linters, 'vulture') == -1
    call add(b:ale_linters, 'vulture')
endif

if executable('ruff') && index(b:ale_linters, 'ruff') == -1
    call add(b:ale_linters, 'ruff')
endif

" if executable('pylint')
"     call add(b:ale_linters, 'pylint')
" endif
" ALE Linters }}} --------------------------------------------------------------

" ALE Fixers {{{ ---------------------------------------------------------------
let b:ale_fixers = get(b:, 'ale_fixers', [])

if executable('ruff') && index(b:ale_fixers, 'ruff_format') == -1
    call add(b:ale_fixers, 'ruff_format')
endif

" if len(b:ale_fixers) > 0
"     let g:ale_fix_on_save = 1
" endif
" ALE Fixers }}} ---------------------------------------------------------------
