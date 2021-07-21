setlocal commentstring=//\ %s

if executable('jq')
    command! -buffer -nargs=0 Format :%!jq .
    setlocal formatprg=jq
elseif executable('python3')
    command! -buffer -nargs=0 Format :%!python3 -m json.tool .
    setlocal formatprg=python3\ -m\ json.tool
endif
