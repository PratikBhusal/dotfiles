if exists('g:context_filetype_blacklist')
    if index(g:context_filetype_blacklist, 'help') == -1
        call add(g:context_filetype_blacklist, 'help')
    endif
endif
