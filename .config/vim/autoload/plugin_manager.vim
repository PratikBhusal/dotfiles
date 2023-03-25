" Package Manager Selecter {{{
function! plugin_manager#init() abort
    let l:plugin_manager = s:select_plugin_manager()

    augroup LazyLoadPlugin
        autocmd!
    augroup END

    if  l:plugin_manager==# 'plugpac'
        call s:plugpac()
    else
        call s:vim_plug()
    endif

    return l:plugin_manager
endfunction

function! s:select_plugin_manager() abort
    let l:use_packages = has('packages') && ( has('job') || exists('*jobstart()') )

    if isdirectory($XDG_CONFIG_HOME . '/vim/pack/minpac/opt/minpac') &&
        \ filereadable($XDG_CONFIG_HOME . '/vim/autoload/plugpac.vim') &&
        \ l:use_packages
        return 'plugpac'
    endif

    if filereadable( $XDG_CONFIG_HOME . '/vim/autoload/plug.vim') && !executable('curl')
        return 'vim_plug'
    endif

    if !executable('curl')
        throw 'Cannot download plugin manager. Plesae install curl.'
    endif

    if executable('git') && l:use_packages
        if !isdirectory($XDG_CONFIG_HOME . '/vim/pack/minpac/opt/minpac')
            execute 'silent !git clone https://github.com/k-takata/minpac.git ' .
                \ $XDG_CONFIG_HOME . '/vim/pack/minpac/opt/minpac'
        endif
        if !filereadable($XDG_CONFIG_HOME . '/vim/autoload/plugpac.vim')
            execute 'silent !curl -fLo ' . $XDG_CONFIG_HOME . '/vim/autoload/plugpac.vim' . ' --create-dirs ' .
                \ 'https://raw.githubusercontent.com/bennyyip/plugpac.vim/master/plugpac.vim'
        endif
        autocmd VimEnter * PackUpdate | source $MYVIMRC
        return 'plugpac'
    else
      execute 'silent !curl -flo ' . $XDG_CONFIG_HOME . '/vim/autoload/plug.vim' . ' --create-dirs ' .
        \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

    return 'vim_plug'

endfunction
" Package Manager Selecter }}}

" Generate Plugin List {{{ -----------------------------------------------------
function! s:generate_plugin_list(plugin_manager) abort
    echo a:plugin_manager
    let l:plugins = []

    " Visual Plugins {{{
    "   {'name': 'tomasr/molokai'},
    "   {'name': 'junegunn/rainbow_parentheses.vim'},
    let l:plugins += [
    \   {'name': 'bling/vim-airline'},
    \   {'name': 'vim-airline/vim-airline-themes'},
    \   {'name': 'luochen1990/rainbow'},
    \]

    if has('nvim')
        let l:plugins += [
        \   {'name': 'lukas-reineke/indent-blankline.nvim'},
        \   {'name': 'nvim-treesitter/nvim-treesitter', 'options': {'do': ':TSUpdate'}},
        \]
    else
        let l:plugins += [
        \   {'name': 'Yggdroot/indentLine'},
        \]
    endif

    if exists('*reltimefloat')
        let l:plugins += [
        \   {'name': 'Yggdroot/hiPairs'},
        \]
    endif

    if !g:windows
        let l:plugins += [
        \   {'name': 'ryanoasis/vim-devicons'},
        \]
    endif
    " Visual Plugins }}}

    " Navigation Plugins {{{
    let l:plugins += [
    \   {'name': 'justinmk/vim-dirvish'},
    \   {'name': 'scrooloose/nerdtree', 'options': {'on': 'NERDTreeToggle'}},
    \   {'name': 'easymotion/vim-easymotion'},
    \   {'name': 'aykamko/vim-easymotion-segments'},
    \   {'name': 'chaoren/vim-wordmotion'},
    \]

    if executable('fzf')
        Pack 'junegunn/fzf.vim'
        let l:plugins += [
        \   {'name': 'junegunn/fzf.vim'},
        \]
    elseif executable('go')
        let l:plugins += [
        \   {'name': 'scrooloose/nerdtree', 'options': {'do': {-> system('./install --all')}} },
        \   {'name': 'junegunn/fzf.vim'},
        \]
    else
        let l:plugins += [
        \   {'name': 'ctrlpvim/ctrlp.vim'},
        \]
    endif
    " Navigation Plugins }}}

    " Quality of Life Plugins {{{
    " \   {'name': 'jbgutierrez/vim-better-comments'},
    let l:plugins += [
    \   {'name': 'jdhao/better-escape.vim'},
    \   {'name': 'tpope/vim-commentary'},
    \   {'name': 'markonm/traces.vim'},
    \   {'name': 'andymass/vim-matchup'},
    \   {'name': 'junegunn/vim-easy-align'},
    \   {'name': 'Konfekt/FastFold'},
    \   {'name': 'lambdalisue/suda.vim'},
    \   {'name': 'sheerun/vim-polyglot'},
    \   {'name': (v:version < 800) ? 'PratikBhusal/pear-tree' : 'tmsvg/pear-tree'},
    \]

    if !has('nvim')
        let l:plugins += [
        \   {'name': 'tpope/vim-sensible'},
        \]

        if v:version >= 802
            let l:plugins += [
            \   {'name': 'axelf4/vim-strip-trailing-whitespace'},
            \]
        endif
    else
        let l:plugins += [
        \   {'name': 'axelf4/vim-strip-trailing-whitespace'},
        \]
    endif

    " Quality of Life Plugins }}}

    " Filetype Plugin - markdown {{{
    let l:plugins += [
    \   {'name': 'masukomi/vim-markdown-folding', 'options': {'for': 'markdown'}},
    \   {'name': 'tpope/vim-markdown', 'options': {'for': 'markdown'}},
    \]
    " Filetype Plugin - markdown }}}

    " Filetype Plugin - python {{{
    if has('python3') || has('python')
        let l:plugins += [
        \   {'name': 'python-mode/python-mode', 'options': {'for': 'python', 'branch': 'develop'}},
        \   {'name': 'tmhedberg/SimpylFold', 'options': {'for': 'python'}},
        \]
    endif
    " Fileytpe Plugin - python }}}

    " Filetype Plugin - cmake {{{
    if executable('cmake')
        let l:plugins += [
        \   {'name': 'pboettch/vim-cmake-syntax', 'options': {'for': 'cmake'}},
        \   {'name': 'tmhedberg/SimpylFold', 'options': {'for': 'cmake'}},
        \]
    endif
    " Filetype Plugin - cmake }}}

    " Filetype Plugin - latex {{{
    if executable('latexmk')
        let l:plugins += [
        \   {'name': 'lervag/vimtex', 'options': {'for': ['tex', 'latex']}},
        \]
    endif
    " Filetype Plugin - latex }}}

    " Filetype Plugin - java {{{
    if executable('java')
        let l:plugins += [
        \   {'name': 'uiiaoo/java-syntax.vim', 'options': {'for': 'java'}},
        \]
    endif
    " Filetype Plugin - java }}}

    " Filetype Plugin - java {{{
    if executable('java')
        let l:plugins += [
        \   {'name': 'uiiaoo/java-syntax.vim', 'options': {'for': 'java'}},
        \]
    endif
    " Filetype Plugin - java }}}

    " Git Integration {{{
    let l:plugins += [
    \   {'name': 'tpope/vim-fugitive'},
    \   {'name': 'airblade/vim-gitgutter'},
    \]
    " Git Integration }}}

    " Autocompletion {{{
    if executable('python3') && has('python3')
        let l:plugins += [
        \   {'name': 'SirVer/ultisnips'},
        \   {'name': 'honza/vim-snippets'},
        \]
    endif
    " Autocompletion }}}

    " Miscellaneous {{{
    if has('nvim')
        let l:plugins += [
        \   {'name': 'tpope/vim-sensible'},
        \]
    endif

    " Miscellaneous }}}

    " Plugins for Consideration {{{

    " Plugins for Consideration }}}

    " Direnv - Local Vim Configuration {{{
    if !g:windows && executable('direnv')
        call s:direnv_init()

        if exists('$DIRENV_VIM_DIR')
            let l:plugins += [
            \   {'name': $DIRENV_VIM_DIR},
            \]
        endif
    endif
    " Direnv - Local Vim Configuration }}}

    return l:plugins
endfunction
function! Global_test_generate_function_list() abort

    " for l:plugin in s:generate_plugin_list(s:select_plugin_manager())
    "     echo l:plugin['name']
    "     if has_key(l:plugin, 'options')
    "         echo l:plugin['options']
    "     else
    "         echo '{}'
    "     endif
    " endfor
    " return 'done'
    return s:generate_plugin_list(s:select_plugin_manager())
endfunction
" Generate Plugin List }}} ---------------------------------------------------------

" Vim-Plug {{{ -----------------------------------------------------------------
function! s:vim_plug() abort

" Vim-Plug automatic download {{{
" if empty(glob('$HOME/.config/vim/autoload/plug.vim'))
if !filereadable($XDG_CONFIG_HOME . '/vim/autoload/plug.vim')
endif
" }}}

call plug#begin('$HOME/.config/vim/bundle')

if g:windows
    Plug '$HOME/.config/vim/pack/osplugin/opt/osplugin-windows'
elseif g:linux
    Plug '$HOME/.config/vim/pack/osplugin/opt/osplugin-linux'
elseif g:macOS
    Plug '$HOME/.config/vim/pack/osplugin/opt/osplugin-mac'
endif

" if has('win32unix') || !has('gui_running')
"     if isdirectory(expand('$HOME/.vim/src/vim-SnippetsCompleteMe'))
"         Plug '$HOME/.config/vim/src/vim-SnippetsCompleteMe'
"         execute 'helptags ' .
"             \ expand('$HOME/.vim/src/vim-SnippetsCompleteMe/doc')
"     else
"         Plug 'PratikBhusal/vim-SnippetsCompleteMe'
"     endif
" endif
if isdirectory(expand('$HOME/.vim/src/vim-grip'))
    Plug '$HOME/.config/vim/src/vim-grip', { 'for' : 'markdown' }
    execute 'helptags ' . expand('$HOME/.vim/src/vim-grip/doc')
else
    Plug 'PratikBhusal/vim-grip', { 'for': 'markdown' }
endif

if isdirectory(expand('$HOME/.vim/pack/src/start/vim-darkokai'))
    Plug '$HOME/.config/vim/pack/src/start/vim-darkokai'
else
    Plug 'PratikBhusal/vim-darkokai'
endif

" Visual Plugins {{{
Plug 'tomasr/molokai'
Plug 'bling/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/indentLine'
if exists('*reltimefloat')
    Plug 'Yggdroot/hiPairs'
endif
Plug 'luochen1990/rainbow'
" Visual Plugins }}}

" Navigation Plugins {{{
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'easymotion/vim-easymotion'
Plug 'aykamko/vim-easymotion-segments'
Plug 'chaoren/vim-wordmotion'

" if executable('go')
"     if isdirectory($XDG_CONFIG_HOME . '/fzf'))
"         Plug '$HOME/.config/fzf'
"     else
"         Plug 'junegunn/fzf', { 'dir': '$HOME/.config/fzf', 'do': './install --all' }
"     endif
"     Plug 'junegunn/fzf.vim'
" else
"     Plug 'ctrlpvim/ctrlp.vim'
" endif

" Navigation Plugins }}}

" Filetype plugins {{{
if has('python3') || has('python')
    Plug 'python-mode/python-mode', { 'branch': 'develop' }
    Plug 'tmhedberg/SimpylFold', { 'for': 'python' }
endif
if executable('clang')
    Plug 'Rip-Rip/clang_complete',
    Plug 'rhysd/vim-clang-format'
endif
if executable('cmake')
    Plug 'pboettch/vim-cmake-syntax', { 'for': 'cmake' }
    Plug 'vhdirk/vim-cmake'
endif
if executable('latexmk')
    Plug 'lervag/vimtex', { 'for': ['tex', 'latex'] }
endif
" Filetype plugins }}}

" Syntax Plugins {{{
Plug 'sheerun/vim-polyglot'
Plug 'PratikBhusal/cSyntaxAfter'
" Syntax Plugins }}}

" Quality of life plugins {{{
" Plug 'rstacruz/vim-closer'
if v:version < 800
    Plug 'PratikBhusal/pear-tree'
else
    Plug 'tmsvg/pear-tree'
endif
Plug 'tpope/vim-commentary'
Plug 'markonm/traces.vim'
Plug 'andymass/vim-matchup'
" Plug 'jbgutierrez/vim-better-comments'
Plug 'ntpeters/vim-better-whitespace'
Plug 'junegunn/vim-easy-align'
Plug 'Konfekt/FastFold'
" Quality of life plugins }}}


Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'tpope/vim-dispatch'

if !has('nvim')
    Plug 'tpope/vim-sensible'
endif

Plug 'takac/vim-hardtime'

Plug 'tpope/vim-fugitive' | Plug 'airblade/vim-gitgutter'

if v:version >= 800
    Plug 'w0rp/ale'
endif

" Autocompletion Plugins {{{
" if has('python3') && ( has('nvim-0.3.0') || has('patch-8.1.001') ) && executable('node')
"     Plug 'neoclide/vim-node-rpc'
"     Plug 'Shougo/neco-vim'
"     Plug 'neoclide/coc-neco'
"     Plug 'neoclide/coc-sources'
"     Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
"     autocmd FileType json syntax match Comment +\/\/.\+$+
"     " Plug 'Shougo/deoplete.nvim'
"     " Plug 'roxma/nvim-yarp'
"     " Plug 'roxma/vim-hug-neovim-rpc'
"     " Plug 'Shougo/neco-vim'
"     " Plug 'zchee/deoplete-jedi'
" else
"     Plug 'lifepillar/vim-mucomplete'
" endif
" Plug 'lifepillar/vim-mucomplete'
" Autocompletion Plugins }}}

" Plugins for consideration {{{
" Async Autocompletion
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'
" Plug 'prabirshrestha/asyncomplete-lsp.vim'
" Plug 'prabirshrestha/asyncomplete-buffer.vim'
" Plug 'prabirshrestha/asyncomplete-ultisnips.vim'

Plug 'PratikBhusal/vim-darkokai'


if has('nvim')
    Plug 'RRethy/vim-hexokinase'
else
    Plug 'ap/vim-css-color'
endif


Plug 'jaredgorski/SpaceCamp'

" Better window resizing
Plug 'roxma/vim-window-resize-easy'

" Visualize undo tree
Plug 'mbbill/undotree'


" Better comments

" Plug 'vimwiki/vimwiki'

" Plug 'jbgutierrez/vim-better-comments'

" Add vim-clang-format to format my c-family code
" Plug 'Shougo/vimproc.vim', {'do' : 'make'}

" " Python Autocompletion
" Plug 'vim-scripts/pythoncomplete'

" Plug 'junegunn/fzf', { 'dir': '$HOME/.config/fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'

" add vim-lightline. May eventually replace vim-airline
" Plug 'itchyny/lightline.vim'

" Add a vim wiki for notetaking and other needs
" Plug 'vimwiki/vimwiki'

Plug 'editorconfig/editorconfig-vim'


Plug 'tweekmonster/startuptime.vim'


" if executable('tmux')
"     Plug 'christoomey/vim-tmux-navigator'
" endif

" Autocompletion Options
" Plug 'ajh17/VimCompletesMe'
" Plug 'lifepillar/vim-mucomplete'
" Plug 'ervandew/supertab'

" Have statusline show buffers
" Plug 'bling/vim-bufferline'

" Add better cwindow support
" Plug 'romainl/vim-qf'

"Add todo.txt support
Plug 'freitass/todo.txt-vim'

" Add camel/snake case motions

" }}}

" Direnv - Local vim configuration {{{ -----------------------------------------
if g:linux && executable('direnv')
    call s:direnv_init()

    if exists("$DIRENV_VIM_DIR")
        Plug $DIRENV_VIM_DIR
    endif

endif
" Direnv - Local vim configuration }}} -----------------------------------------

" on demand loading of NERD Tree
call plug#end()

endfunction
" Vim-Plug }}} -----------------------------------------------------------------

" PlugPac {{{ ------------------------------------------------------------------
function! s:plugpac() abort


call plugpac#begin()

if g:windows
    packadd osplugin-windows
elseif g:linux
    packadd osplugin-linux
elseif g:macOS
    packadd osplugin-mac
endif

" if has('win32unix') || !has('gui_running')
"     if isdirectory(expand('$HOME/.vim/src/vim-SnippetsCompleteMe'))
"         Pack '$HOME/.config/vim/src/vim-SnippetsCompleteMe'
"         execute 'helptags ' .
"             \ expand('$HOME/.vim/src/vim-SnippetsCompleteMe/doc')
"     else
"         Pack 'PratikBhusal/vim-SnippetsCompleteMe'
"     endif
" endif
" if isdirectory(expand('$HOME/.vim/pack/src/opt/vim-grip'))
if isdirectory(expand('$HOME/.config/vim/pack/src/opt/vim-grip'))
    autocmd LazyLoadPlugin Filetype markdown packadd vim-grip
    " Pack expand('file://$HOME/.config/vim/pack/src/opt/vim-grip'), { 'for': 'markdown' }
else
    Pack 'PratikBhusal/vim-grip', { 'for': 'markdown' }
endif

if !isdirectory(expand('$HOME/.config/vim/pack/src/start/vim-darkokai'))
    Pack 'PratikBhusal/vim-darkokai'
endif

" Visual plugins {{{
Pack 'tomasr/molokai', { 'type': 'opt' }
Pack 'bling/vim-airline' | Pack 'vim-airline/vim-airline-themes'
" add vim-lightline. May eventually replace vim-airline
" Pack 'itchyny/lightline.vim'
if has('nvim')
    " let g:indent_blankline_show_trailing_blankline_indent = v:false
    " let g:indent_blankline_debug = v:true
    Pack 'lukas-reineke/indent-blankline.nvim'

    Pack 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
else
    Pack 'Yggdroot/indentLine'
endif
Pack 'Yggdroot/hiPairs'
Pack 'luochen1990/rainbow'
" Pack 'junegunn/rainbow_parentheses.vim'
" Visual Packins }}}

" Navigation plugins {{{
Pack 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Replace Netrw with Dirvish {{{
Pack 'justinmk/vim-dirvish'
Pack 'roginfarrer/vim-dirvish-dovish'
let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
" Replace Netrw with Dirvish }}}

Pack 'easymotion/vim-easymotion'
Pack 'aykamko/vim-easymotion-segments'
Pack 'chaoren/vim-wordmotion'

if executable('fzf')
    Pack 'junegunn/fzf.vim'
elseif executable('go')
    Pack 'junegunn/fzf', { 'do': {-> system('./install --all')} }
    Pack 'junegunn/fzf.vim'
else
    Pack 'ctrlpvim/ctrlp.vim'
endif

" Navigation Packins }}}

" Filetype plugins {{{
if has('python3') || has('python')
    Pack 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
    Pack 'tmhedberg/SimpylFold', { 'for': 'python' }
    " Pack 'abarker/cyfolds', { 'for': 'python' }
endif
if executable('clang')
"     Pack 'Rip-Rip/clang_complete',
    " Pack 'rhysd/vim-clang-format'
endif
if executable('cmake')
    Pack 'pboettch/vim-cmake-syntax', { 'for': 'cmake' }
    " Pack 'vhdirk/vim-cmake'
    Pack 'ilyachur/cmake4vim'
endif
if executable('latexmk')
    Pack 'lervag/vimtex', { 'for': ['tex', 'latex'] }
endif
if executable('java')
    Pack 'uiiaoo/java-syntax.vim'
endif
" Filetype plugins }}}

" Syntax Packins {{{
Pack 'sheerun/vim-polyglot'
Pack 'PratikBhusal/cSyntaxAfter'
Pack 'aklt/plantuml-syntax'
" Syntax Packins }}}

" Quality of life plugins {{{
" Pack 'rstacruz/vim-closer'
Pack 'jdhao/better-escape.vim'
Pack 'tmsvg/pear-tree'
Pack 'tpope/vim-commentary'
Pack 'markonm/traces.vim'
Pack 'andymass/vim-matchup'
" Pack 'jbgutierrez/vim-better-comments'
Pack 'junegunn/vim-easy-align'
Pack 'Konfekt/FastFold'

if v:version >= 802
    Pack 'axelf4/vim-strip-trailing-whitespace'
else
    Pack 'ntpeters/vim-better-whitespace'
endif
" Quality of life plugins }}}


if executable('python3') && has('python3')
    Pack 'SirVer/ultisnips' | Pack 'honza/vim-snippets'
endif
Pack 'tpope/vim-dispatch'

if !has('nvim')
    Pack 'tpope/vim-sensible'
endif

Pack 'takac/vim-hardtime'

Pack 'tpope/vim-fugitive' | Pack 'airblade/vim-gitgutter'

if v:version >= 800
    Pack 'w0rp/ale'
endif

" Autocompletion plugins {{{
if ( has('nvim-0.3.0') || has('patch-8.1.001') ) && executable('node') && v:false
    Pack 'neoclide/vim-node-rpc'
    Pack 'Shougo/neco-vim'
    Pack 'neoclide/coc-neco'
    Pack 'neoclide/coc-sources'
    Pack 'neoclide/coc.nvim', {'branch': 'release'}
    autocmd LazyLoadPlugin FileType json syntax match Comment +\/\/.\+$+
    " Pack 'Shougo/deoplete.nvim'
    " Pack 'roxma/nvim-yarp'
    " Pack 'roxma/vim-hug-neovim-rpc'
    " Pack 'Shougo/neco-vim'
    " Pack 'zchee/deoplete-jedi'
elseif ( has('nvim-0.3.0') || has('patch-8.1.001') ) && v:false
    Pack 'prabirshrestha/async.vim'
    Pack 'prabirshrestha/vim-lsp'
    Pack 'prabirshrestha/asyncomplete.vim'
    Pack 'prabirshrestha/asyncomplete-lsp.vim'

    if executable('python3')
        Pack 'thomasfaingnaert/vim-lsp-snippets'
        Pack 'thomasfaingnaert/vim-lsp-ultisnips'
        Pack 'prabirshrestha/asyncomplete-ultisnips.vim'
    endif
    Pack 'mattn/vim-lsp-settings'
else
    " Pack 'lifepillar/vim-mucomplete'
endif
" Pack 'lifepillar/vim-mucomplete'
" Autocompletion plugins }}}

" Plugins for consideration {{{
" Async Autocompletion
" Pack 'prabirshrestha/asyncomplete.vim'
" Pack 'prabirshrestha/async.vim'
" Pack 'prabirshrestha/vim-lsp'
" Pack 'prabirshrestha/asyncomplete-lsp.vim'
" Pack 'prabirshrestha/asyncomplete-buffer.vim'
" Pack 'prabirshrestha/asyncomplete-ultisnips.vim'
Pack 'jdhao/better-escape.vim'
Pack 'haya14busa/incsearch.vim'
Pack 'haya14busa/incsearch-easymotion.vim'
Pack 'kovetskiy/sxhkd-vim'
Pack 'lambdalisue/suda.vim'
Pack 'ErichDonGubler/vim-sublime-monokai'
" Pack 'dylanaraps/root.vim'
Pack 'airblade/vim-rooter'
" Pack 'liuchengxu/vista.vim'
Pack 'bfrg/vim-cpp-modern'
" Pack 'wellle/context.vim'
" Pack 'chrisbra/csv.vim', { 'for': 'csv' }
Pack 'janko/vim-test'
Pack 'tpope/vim-surround'
Pack 'cakebaker/scss-syntax.vim'
if !g:windows
    Pack 'ryanoasis/vim-devicons'
endif
Pack 'thezeroalpha/vim-relatively-complete'

Pack 'Xuyuanp/nerdtree-git-plugin'

Pack 'masukomi/vim-markdown-folding', { 'for': 'markdown' }
Pack 'tpope/vim-markdown', { 'for': 'markdown' }
" Pack 'vim-pandoc/vim-pandoc', { 'for': 'markdown' }
" Pack 'vim-pandoc/vim-pandoc-syntax', { 'for': 'markdown' }
" Pack 'vim-pandoc/vim-pandoc-syntax'

" Pack 'goerz/jupytext.vim'

" if has('nvim')
"     Pack 'RRethy/vim-hexokinase' { 'do': {-> system('make hexokinase')} }
" else
"     Pack 'ap/vim-css-color'
" endif
Pack 'ap/vim-css-color'


" Better window resizing
Pack 'roxma/vim-window-resize-easy'

" Visualize undo tree
Pack 'mbbill/undotree'


" Better comments

" Pack 'vimwiki/vimwiki'

" Pack 'jbgutierrez/vim-better-comments'

" Add vim-clang-format to format my c-family code
" Pack 'Shougo/vimproc.vim', {'do' : 'make'}

" " Python Autocompletion
" Pack 'vim-scripts/pythoncomplete'

" Pack 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Pack 'junegunn/fzf.vim'

" add vim-lightline. May eventually replace vim-airline
" Pack 'itchyny/lightline.vim'

" Add a vim wiki for notetaking and other needs
" Pack 'vimwiki/vimwiki'


Pack 'editorconfig/editorconfig-vim'


Pack 'tweekmonster/startuptime.vim'


" if executable('tmux')
"     Pack 'christoomey/vim-tmux-navigator'
" endif

" Autocompletion Options
" Pack 'ajh17/VimCompletesMe'
" Pack 'lifepillar/vim-mucomplete'
" Pack 'ervandew/supertab'

" Have statusline show buffers
" Pack 'bling/vim-bufferline'

" Add better cwindow support
" Pack 'romainl/vim-qf'

"Add todo.txt support
Pack 'freitass/todo.txt-vim'

" Add camel/snake case motions

" }}}

" Direnv - Local vim configuration {{{ -----------------------------------------
if !g:windows && executable('direnv')
    call s:direnv_init()

    if exists('$DIRENV_VIM_DIR')
        Pack $DIRENV_VIM_DIR
    endif

endif
" Direnv - Local vim configuration }}} -----------------------------------------


call plugpac#end()
endfunction
" PlugPac }}} ------------------------------------------------------------------

function! s:direnv_init() abort "{{{
    let l:direnv_cmd = get(g:, 'direnv_cmd', 'direnv')
    if !executable(l:direnv_cmd)
        echoerr 'No Direnv executable, add it to your PATH or set g:direnv_cmd'
        return
    endif

    let l:cmd = [l:direnv_cmd, 'export', 'vim']
    let l:tmp = tempname()

    call system(join(l:cmd).' > '.l:tmp)
    execute 'source '.l:tmp

    call delete(l:tmp)
endfunction "}}}

function! s:direnv_test() abort "{{{
    let l:direnv_cmd = get(g:, 'direnv_cmd', 'direnv')
    if !executable(l:direnv_cmd)
        echoerr 'No Direnv executable, add it to your PATH or set g:direnv_cmd'
        return
    endif

    let l:cmd = l:direnv_cmd . ' export vim'
    for l:command in filter(split(system(l:cmd), '\n'), 'v:val =~# "^let"')
        execute l:command
    endfor
endfunction "}}}
