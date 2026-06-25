if exists(':FZF') == 2 " {{{
    " Hotkeys {{{
    nnoremap <silent> <Leader>p :Files<CR>
    cabbrev ls <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Buffer' : 'ls')<CR>
    cabbrev sl <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Buffer' : 'sl')<CR>
    cabbrev rg <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Rg' : 'rg')<CR>
    " Hotkeys }}}

    " NERD_tree {{{

    autocmd FileType nerdtree let t:nerdtree_winnr = bufwinnr('%')
    autocmd BufWinEnter * call PreventBuffersInNERDTree()

    function! PreventBuffersInNERDTree()
      if bufname('#') =~ 'NERD_tree' && bufname('%') !~ 'NERD_tree'
        \ && exists('t:nerdtree_winnr') && bufwinnr('%') == t:nerdtree_winnr
        \ && &buftype == '' && !exists('g:launching_fzf')
        let bufnum = bufnr('%')
        close
        exe 'b ' . bufnum
      endif
      " if exists('g:launching_fzf') | unlet g:launching_fzf | endif
    endfunction
    " NERD_tree }}}

" }}}

elseif exists(':CtrlP') == 2 " {{{
    let g:ctrlp_reuse_window = 'nerdtree\|netrw\|help\|quickfix'
    let g:ctrlp_extensions = ['bookmarkdir']
    let g:ctrlp_custom_ignore = {
        \ 'dir':  '\v[\/]\.(git|hg|svn|bin)$',
        \ 'file': '\v\.(exe|so|dll|out|xmi)$'
    \ }
    let g:ctrlp_follow_symlinks = 1

    " Ignore and Index files with .gitignore file. Prefer ripgrep > git {{{
    let g:ctrlp_root_markers = ['.gitignore', '.vim']
    let g:ctrlp_user_command = ( executable('rg') )
        \ ? 'rg %s -i --files --no-heading --color=never --glob ""'
        \ : ['.git', 'cd %s && git ls-files']
    let g:ctrlp_use_caching = 0
    " Ignore and Index files with .gitignore file. Prefer rg > ag > git }}}

    " Hotkeys {{{
    nnoremap <silent> <Leader>p :CtrlP<CR>
    cabbrev ls <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'CtrlPBuffer' : 'ls')<CR>
    cabbrev sl <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'CtrlPBuffer' : 'sl')<CR>
    nnoremap <silent> <Leader>b :CtrlPBookmarkDir<CR>
    " Hotkeys }}}

" }}}
endif
