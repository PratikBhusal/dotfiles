if !exists('*lightline#init')
    finish
endif

let g:lightline = get(g:, 'lightline', {})
let g:lightline.active = get(g:, 'lightline.active', {})

let g:lightline.active.left =  [
\   [ 'mode', 'paste' ],
\   [ 'gitstatus', 'readonly', 'filename', 'modified' ]
\ ]

let g:lightline.colorscheme = 'darkokai'

let g:lightline.mode_map = {
\   'n' : 'Normal',
\   'i' : 'Insert',
\   'R' : 'Replace',
\   'v' : 'Visual',
\   'V' : 'V-Line',
\   "\<C-v>": 'V-Block',
\   'c' : 'Command',
\   's' : 'Select',
\   'S' : 'S-Line',
\   "\<C-s>": 'S-Block',
\   't': 'Terminal',
\ }

let g:lightline.separator    = { 'left': "\ue0b0", 'right': "\ue0b2" }
let g:lightline.subseparator = { 'left': "\ue0b1", 'right': "\ue0b3" }

let g:lightline.component = get(g:, 'lightline.component', {})

" %3l is right aligned padding for 3 digits for current row. -2v is left
" aligned padding for current column
" let g:lightline.component.lineinfo = "\ue0a1 %3l:%-2v"
let g:lightline.component.lineinfo = "\ue0a1 %l:%v"

let g:lightline.component_function = get(g:, 'lightline.component_function', {})

let LightlineReadonly = {-> &readonly ? "\ue0a2" : ''}
let g:lightline.component_function.readonly = 'LightlineReadonly'

let LightlineFiletype = {->
\   winwidth(0) <= 70   ? '' :
\   !strlen(&filetype)  ? '' :
\
\   &filetype . (exists('*WebDevIconsGetFileTypeSymbol')
\       ? ' ' . WebDevIconsGetFileTypeSymbol() : ''
\   )
\ }
let g:lightline.component_function.filetype = 'LightlineFiletype'

let LightlineFileformat = {->
\   winwidth(0) <= 70   ? '' :
\
\   &fileformat . (exists('*WebDevIconsGetFileFormatSymbol')
\       ? ' ' . WebDevIconsGetFileFormatSymbol() : ''
\   )
\ }
let g:lightline.component_function.fileformat = 'LightlineFileformat'


function! LightlineVCSInfo() abort
    if !exists('*FugitiveHead')
        return ''
    endif

    let l:head = FugitiveHead()
    if l:head ==# ''
        return ''
    endif
    let l:head = "\ue0a0 " . l:head

    if !exists('*GitGutterGetHunkSummary')
        return l:head
    endif

    let [l:added,l:modified,l:removed] = GitGutterGetHunkSummary()

    return
    \   (l:added    != 0 ? '+' . l:added    . ' ' : '') .
    \   (l:modified != 0 ? '~' . l:modified . ' ' : '') .
    \   (l:removed  != 0 ? '-' . l:removed  . ' ' : '') .
    \   l:head
endfunction
let g:lightline.component_function.gitstatus = 'LightlineVCSInfo'

call lightline#init()
