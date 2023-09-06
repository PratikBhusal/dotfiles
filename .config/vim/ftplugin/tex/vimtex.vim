let g:polyglot_disabled += ['latex']
" let g:vimtex_view_automatic = 0
" Compile and Run {{{ ----------------------------------------------------------
    augroup vimtex_event_1
        au!
        au User VimtexEventInitPost VimtexCompile
        au User VimtexEventQuit     VimtexClean
    augroup END
" Compile and Run }}} ----------------------------------------------------------

" Close PDF viewer once done in vim {{{ ----------------------------------------
if executable('xdotool')
    fun s:close_viewers()
        if exists('b:vimtex.viewer.xwin_id') && b:vimtex.viewer.xwin_id > 0
            echom 'statement is true!'
            call system('xdotool windowclose '. b:vimtex.viewer.xwin_id)
        endif
    endf

    augroup vimtex_event_2
        " au User VimtexEventQuit call s:close_viewers()

        au User VimtexEventInitPost call s:close_viewers()
    augroup END
endif
" Close PDF viewer once done in vim }}} ----------------------------------------
