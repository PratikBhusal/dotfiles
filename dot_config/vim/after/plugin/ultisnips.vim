" set runtimepath+=~/.vim/UltiSnips
let g:UltiSnipsSnippetsDir='~/.vim/UltiSnips'
" let g:UltiSnipsSnippetDirectories=['UltiSnips','bundle/vim-snippets/UltiSnips']
let g:UltiSnipsUsePythonVersion = ( has('python3') ? 3 : 2 )
let g:UltiSnipsEditSplit='context'

" Ultisnips Mappings
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<Leader>.'
let g:UltiSnipsJumpBackwardTrigger = '<Leader>,'

let g:snips_author = 'Pratik Bhusal'
