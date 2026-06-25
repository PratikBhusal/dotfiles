" Quality of Life Changes {{{ --------------------------------------------------
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeAutoDeleteBuffer = 1
setlocal colorcolumn=
" Quality of Life Changes }}} --------------------------------------------------

" Visual Settings {{{ ----------------------------------------------------------
" setlocal colorcolumn=
setlocal colorcolumn=

if has('folding')
  setlocal nofoldenable
endif

setlocal nolist
" Visual Settings }}} ----------------------------------------------------------

" Shortcuts {{{ ----------------------------------------------------------------
" Make '-' work like 'u' (netrw-like)
nmap <buffer> <expr> - g:NERDTreeMapUpdir
" Shortcuts }}} ----------------------------------------------------------------
