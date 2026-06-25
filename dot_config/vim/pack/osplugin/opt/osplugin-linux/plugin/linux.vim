" Make Vim Useable {{{ ---------------------------------------------------------
" set guifont=Monospace\ 5
set guifont=Monospace:h12
set clipboard^=unnamed,unnamedplus
" set clipboard^=unnamedplus
if has('autocmd') && executable('wmctrl') && has('patch-7.3.031')
    autocmd VimEnter * call system(
        \ 'wmctrl -i -b add,maximized_vert,maximized_horz -r '.v:windowid)
endif
" Make Vim Useable }}} ---------------------------------------------------------
