if exists(':GitGutter') != 2
    finish
endif

autocmd gitgutter BufWritePost * GitGutter
