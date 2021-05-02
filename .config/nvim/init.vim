" Vim Backwards Compatibility {{{ ----------------------------------------------
if empty($XDG_CACHE_HOME)  | let $XDG_CACHE_HOME  = $HOME."/.cache"       | endif
if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME = $HOME."/.config"      | endif
if empty($XDG_DATA_HOME)   | let $XDG_DATA_HOME   = $HOME."/.local/share" | endif

set runtimepath^=$XDG_CONFIG_HOME/vim runtimepath+=$XDG_CONFIG_HOME/vim/after
let &packpath = &runtimepath

if empty($MYVIMRC) | let $MYVIMRC = expand('<sfile>:p') | endif
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
