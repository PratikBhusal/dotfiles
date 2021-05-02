let g:polyglot_disabled += ['latex']
" let g:vimtex_view_automatic = 0
" Compile and Run {{{ ----------------------------------------------------------
    augroup vimtex_event_1
        au!
        au User VimtexEventInitPost call vimtex#compiler#compile()
        au User VimtexEventQuit     call vimtex#compiler#clean(0)
        " au User VimtexEventQuit     call CloseViewers()
    augroup END
" Compile and Run }}} ----------------------------------------------------------
