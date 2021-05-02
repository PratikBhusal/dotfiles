let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \   '-pdf',
    \   '-verbose',
    \   '-bibtex',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}

let g:vimtex_view_automatic = 0

if has('nvim')
    g:vimtex_compiler_progname = 'nvr'
endif
