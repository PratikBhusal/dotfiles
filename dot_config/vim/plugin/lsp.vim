if !exists('*asyncomplete#register_source')
    finish
endif

let g:lsp_settings = get(g:, 'lsp_settings', {})

if executable('clangd')
    let g:lsp_settings['clangd'] = get(
        \ g:lsp_settings,
        \ 'clangd',
        \ { 'cmd': ['clangd'], 'config': { 'snippets': 0 } }
    \ )
endif

if has('python3')
    call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
        \ 'name': 'ultisnips',
        \ 'whitelist': ['*'],
        \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
        \ }))
endif
