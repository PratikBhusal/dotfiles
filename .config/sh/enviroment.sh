#!/usr/bin/env sh

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

case "$(uname -s)" in
    Linux*)     DOTFILES_MACHINE=Linux;;
    Darwin*)    DOTFILES_MACHINE=Mac;;
    *)          DOTFILES_MACHINE="UNKOWN"
esac
export DOTFILES_MACHINE


# Make Vim follow XDG Base Directory specification
export VIMINIT="if has('nvim') | so ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/init.vim | else | set nocp | so ${XDG_CONFIG_HOME:-$HOME/.config}/vim/vimrc | endif"
# export VIMINIT="set nocp | source ${XDG_CONFIG_HOME:-$HOME/.config}/vim/vimrc"

# Always include "-R" flag
export LESS="-R"

# For ls, remove quotes around names
export QUOTING_STYLE=literal
export CLICOLOR=1
XDG_RUNTIME_DIR=/run/user/$(id -u)
export XDG_RUNTIME_DIR

# Setup readline inputrc config
export INPUTRC="$HOME/.config/readline/inputrc"

command -v st      1> /dev/null 2>&1 && export TERMINAL="st"
command -v less    1> /dev/null 2>&1 && export PAGER="less"
command -v pyenv   1> /dev/null 2>&1 && eval   "$(pyenv init -)"
command -v firefox 1> /dev/null 2>&1 && export BROWSER="firefox"
command -v i3lock  1> /dev/null 2>&1 && export LOCKER="i3lock"
command -v grip  1> /dev/null 2>&1 && export GRIPHOME="$HOME/.config/grip"


# For `st` truecolor to work, we need to set `COLORTERM`
[ "$TERMINAL" = "st" ] && [ -z "$COLORTERM" ] && export COLORTERM=truecolor

# Opt-out of Microsoft telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Configure git-credential-manager for linux
if command -v git-credential-manager 1> /dev/null 2>&1 \
    && [ "$DOTFILES_MACHINE" = 'Linux' ]; then
    export GCM_CREDENTIAL_STORE=cache
    export GCM_CREDENTIAL_CACHE_OPTIONS="--timeout 300"
fi

# export QT_QPA_PLATFORMTHEME=gtk2
# export QT_QPA_PLATFORMTHEME=qt5ct
export QT_STYLE_OVERRIDE=kvantum

# shellcheck source=functions.d/path_manipulation.sh
[ -r "$HOME"/.config/sh/functions.d/path_manipulation.sh ] && \
    . "$HOME"/.config/sh/functions.d/path_manipulation.sh

# shellcheck source=functions.d/pacman.sh
[ -r "$HOME"/.config/sh/functions.d/pacman.sh ] && \
    . "$HOME"/.config/sh/functions.d/pacman.sh

# set PATH so it includes user's private bin if it exists
prepend_to_path "/usr/local/bin"
prepend_to_path "/usr/local/sbin"
prepend_to_path "$HOME/bin"
prepend_to_path "$HOME/.local/bin"
append_to_path "$HOME/.config/dotfiles/scripts"


# Add texlive
if [ -d "$HOME/.texlive/2023/" ]; then
    append_to_path "$HOME/.texlive/2023/sys/bin/x86_64-linux/"
    MANPATH=$MANPATH:$HOME/.texlive/2023/sys/texmf-dist/doc/man/
    INFOPATH=$INFOPATH:$HOME/.texlive/2023/sys/texmf-dist/doc/info/
    # export TEXMFCNF="$HOME/.texlive/2019/:"
fi


# Add rust cargo packages
# shellcheck source=.config/cargo/bin
append_to_path "$HOME/.cargo/bin"


# Append go binaries
append_to_path "$HOME/go/bin"

PATH=$(cleanup_path "$PATH")
MANPATH=$(cleanup_path "$MANPATH")
INFOPATH=$(cleanup_path "$INFOPATH")
