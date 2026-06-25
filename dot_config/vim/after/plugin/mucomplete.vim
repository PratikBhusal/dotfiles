" if !get(g:, 'mucomplete#no_mappings', get(g:, 'no_plugin_maps', 0))
"   if !hasmapto('<plug>(MUcompleteFwd)', 'i')
"     imap <unique> <tab> <plug>(MUcompleteFwd)
"   endif
" endif


" if !get(g:, 'mucomplete#no_mappings', get(g:, 'no_plugin_maps', 0))
"   if !hasmapto('<plug>(MUcompleteFwd)', 'i')
"     imap <unique> <tab> <plug>(MUcompleteFwd)
"   endif
"   if !hasmapto('<plug>(MUcompleteBwd)', 'i')
"     imap <unique> <s-tab> <plug>(MUcompleteBwd)
"   endif
" endif

" if !(get(g:, 'mucomplete#no_popup_mappings', 0) || get(g:, 'mucomplete#no_mappings', 0) || get(g:, 'no_plugin_maps', 0))
"   if !hasmapto('<plug>(MUcompletePopupCancel)', 'i')
"     call mucomplete#map('imap', '<c-e>', '<plug>(MUcompletePopupCancel)')
"   endif
"   if !hasmapto('<plug>(MUcompletePopupAccept)', 'i')
"     call mucomplete#map('imap', '<c-y>', '<plug>(MUcompletePopupAccept)')
"   endif
"   if !hasmapto('<plug>(MUcompleteCR)', 'i')
"     call mucomplete#map('imap', '<cr>', '<plug>(MUcompleteCR)')
"   endif
" endif


" if !hasmapto('<plug>(MUcompleteCycFwd)', 'i')
"     inoremap <silent> <plug>(MUcompleteFwdKey) <c-j>
"     call mucomplete#map('imap', '<c-j>', '<plug>(MUcompleteCycFwd)')
" endif
" if !hasmapto('<plug>(MUcompleteCycBwd)', 'i')
"     inoremap <silent> <plug>(MUcompleteBwdKey) <c-h>
"     call mucomplete#map('imap', '<c-h>', '<plug>(MUcompleteCycBwd)')
" endif

if exists('g:loaded_mucomplete')
    inoremap <silent> <plug>(MUcompleteFwdKey) <c-j>
    imap <unique> <c-j> <plug>(MUcompleteCycFwd)

    inoremap <silent> <plug>(MUcompleteBwdKey) <c-h>
    imap <unique> <c-h> <plug>(MUcompleteCycBwd)
endif
