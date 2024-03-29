" Vim Backwards Compatibility {{{ ----------------------------------------------
if exists("g:neovide")
    let g:neovide_cursor_animate_command_line = v:false
    let g:neovide_cursor_animate_in_insert_mode = v:false
    let g:neovide_cursor_animation_length = 0
    let g:neovide_cursor_trail_size = 0
    let g:neovide_hide_mouse_when_typing = v:true
    let g:neovide_scroll_animation_far_lines = 0
    let g:neovide_scroll_animation_length = 0
endif

if empty($XDG_CACHE_HOME)  | let $XDG_CACHE_HOME  = $HOME.'/.cache'       | endif
if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME = $HOME.'/.config'      | endif
if empty($XDG_DATA_HOME)   | let $XDG_DATA_HOME   = $HOME.'/.local/share' | endif

set runtimepath^=$XDG_CONFIG_HOME/vim runtimepath+=$XDG_CONFIG_HOME/vim/after
let &packpath = &runtimepath

nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

if empty($MYVIMRC) | let $MYVIMRC = expand('<sfile>:p') | endif

" Jump to the last position when reopening a file (except Git commit)
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

source $XDG_CONFIG_HOME/vim/vimrc
" Vim Backwards Compatibility }}} ----------------------------------------------

" Setup python virtual enviroment {{{ ------------------------------------------
let g:loaded_python_provider = 1

if executable($PYENV_ROOT . 'versions/neovim3/bin/python')
    let g:python3_host_prog = $PYENV_ROOT . 'versions/neovim3/bin/python'
elseif executable($HOME . '/.pyenv/versions/neovim3/bin/python')
    let g:python3_host_prog = $HOME . '/.pyenv/versions/neovim3/bin/python'
endif
" Setup python virtual enviroment }}} ------------------------------------------

" autocmd GUIEnter * set lines=999 columns=999
" let g:GuiWindowFullScreen=1

" Colorscheme Settings {{{ -----------------------------------------------------
if (empty($TMUX))
  if (has('nvim'))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has('termguicolors'))
    set termguicolors
  endif
endif
"  }}} -------------------------------------------------------------------------