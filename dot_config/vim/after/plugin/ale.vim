if exists(':ALEDetail') == 2
    " let g:ale_virtualenv_dir_names = []
    let g:ale_sign_column_always = 1
    let g:ale_linters = {
    \   'asm': [],
    \   'c': ['clang', 'clangtidy', 'gcc'],
    \   'cpp': ['clang','clangcheck','clangtidy','g++'],
    \   'java': [],
    \}
    let g:ale_set_balloons = 1
    let g:ale_fix_on_save = 1
endif

