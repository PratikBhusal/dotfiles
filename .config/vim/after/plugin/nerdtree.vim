let g:NERDTreeBookmarksFile= ( g:linux )
    \ ? expand('$HOME/.vim/.cache/NERDTree/.Linux')
    \ : expand('$HOME/.vim/.cache/NERDTree/.Windows')
let g:NERDTreeShowBookmarks=1
let g:NERDTreeShowLineNumbers=1
let g:NERDTreeHijackNetrw = 0
let g:NERDTreeIgnore=['\.ncb$', '\.suo$', '\.vcproj\.RIMNET', '\.obj$',
    \ '\.ilk$', '^BuildLog.htm$', '\.pdb$', '\.idb$',
    \ '\.embed\.manifest$', '\.embed\.manifest.res$',
    \ '\.intermediate\.manifest$', '^mt.dep$' ]
let g:NERDTreeShowHidden=1
let g:NERDTreeChDirMode = 2

" " Auto Expand on Startup {{{
" function! Nerdtree_auto_expand()
"     let b:NERDTreeZoomed = 0
"     call feedkeys("A")
" endfunction

" autocmd Filetype nerdtree call Nerdtree_auto_expand()
" " Auto Expand on Startup }}}
