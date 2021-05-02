let g:mucomplete#no_mappings = 1
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#completion_delay = 200

" Completion Chains
let g:mucomplete#chains = {}
let g:mucomplete#chains.default = ['omni', 'ulti', 'snip', 'path', 'keyn', 'uspl']
let g:mucomplete#chains.vim = ['path', 'cmd', 'keyn', 'ulti', 'snip']
let g:mucomplete#chains.cpp = ['path', 'cmd', 'keyn', 'ulti', 'snip']
