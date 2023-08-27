" ALE Linters {{{ --------------------------------------------------------------
let b:ale_linters = get(b:, 'ale_linters', [])

if executable('flake8')
    call add(b:ale_linters, 'flake8')
endif
if executable('mypy')
    call add(b:ale_linters, 'mypy')
    let g:ale_python_mypy_options = '--no-pretty --show-error-codes'
endif
if executable('bandit')
    call add(b:ale_linters, 'bandit')
endif

if executable('vulture')
    call add(b:ale_linters, 'vulture')
endif
" if executable('pydocstyle')
"     call add(b:ale_linters, 'pydocstyle')
" endif
" if executable('pylint')
"     call add(b:ale_linters, 'pylint')
" endif
" ALE Linters }}} --------------------------------------------------------------

" ALE Fixers {{{ ---------------------------------------------------------------
let b:ale_fixers = get(b:, 'ale_fixers', [])

if executable('isort')
    call add(b:ale_fixers, 'isort')
endif
if executable('black')
    call add(b:ale_fixers, 'black')
endif

" if len(b:ale_fixers) > 0
"     let g:ale_fix_on_save = 1
" endif
" ALE Fixers }}} ---------------------------------------------------------------
