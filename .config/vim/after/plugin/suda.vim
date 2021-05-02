if exists('g:suda#prefix')
    if ( type(g:suda#prefix) == 1 )
        if g:suda#prefix ==# 'sudo:'
            command! -nargs=1 SudoRead  edit  sudo:<args>
            command! -nargs=1 SudoWrite write sudo:<args>
        elseif  g:suda#prefix ==# 'suda://'
            command! -nargs=1 SudoRead  edit  suda://<args>
            command! -nargs=1 SudoWrite write suda://<args>
        endif
    elseif (type(g:suda#prefix) == 3)
        if index(g:suda#prefix, 'sudo:') != -1
            command! -nargs=1 SudoRead  edit  sudo:<args>
            command! -nargs=1 SudoWrite write sudo:<args>
        elseif index(g:suda#prefix, 'suda://') != -1
            command! -nargs=1 SudoRead  edit  suda://<args>
            command! -nargs=1 SudoWrite write suda://<args>
        endif
    endif
endif
