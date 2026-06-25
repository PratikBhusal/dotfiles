setlocal commentstring=//\ %s

if executable('jq')
    setlocal formatprg=jq
elseif executable('python3')
    setlocal formatprg=python3\ -m\ json.tool
endif

" See:
"
" - https://phelipetls.github.io/posts/code-formatting-vim/
function! s:format_json_file(...) abort
    let w:view = winsaveview()
    keepjumps normal! gg
    silent keepjumps normal! ggvGgq
    if v:shell_error > 0
        silent undo
        echohl ErrorMsg
        echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
        echohl None
        endif
    keepjumps call winrestview(w:view)
    unlet w:view
endfunction

" nmap <silent> gq :set operatorfunc=<SID>Format<CR>g@
" nnoremap <silent> gq :setlocal operatorfunc=<SID>format_json_file<CR>g@
" vmap <silent> gq :<C-U>set operatorfunc=<SID>Format<CR>gvg@
" vnoremap <silent> gq :<C-U>setlocal operatorfunc=<SID>format_json_file<CR>gvg@
" nnoremap <silent> gQ :call <SID>format_json_file()<CR>
nnoremap <silent> gq :call <SID>format_json_file()<CR>
