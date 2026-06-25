if exists("$DIRENV_VIMRC")
    for path in split($DIRENV_VIMRC, ':')
        exec "source ".path
    endfor
endif
