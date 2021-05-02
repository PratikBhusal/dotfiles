" Make Vim Useable {{{ ---------------------------------------------------------
set guifont=Monospace\ 15
set clipboard^=unnamedplus
if has('autocmd') && executable('wmctrl') && has('patch-7.3.031')
    autocmd VimEnter * call system(
        \ 'wmctrl -i -b add,maximized_vert,maximized_horz -r '.v:windowid)
endif
" Make Vim Useable }}} ---------------------------------------------------------
