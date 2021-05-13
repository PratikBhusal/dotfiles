#!/usr/bin/env sh
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

case "$(uname -s)" in
    Linux*)     DOTFILES_MACHINE=Linux;;
    Darwin*)    DOTFILES_MACHINE=Mac;;
    *)          DOTFILES_MACHINE="UNKOWN"
esac
export DOTFILES_MACHINE


# Make Vim follow XDG Base Directory specification
export VIMINIT="if has('nvim') | so ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/init.vim | else | set nocp | so ${XDG_CONFIG_HOME:-$HOME/.config}/vim/vimrc | endif"
# export VIMINIT="set nocp | source ${XDG_CONFIG_HOME:-$HOME/.config}/vim/vimrc"


# shellcheck source=.config/sh/functions.sh
[ -r ~/.config/sh/functions.sh ] && . ~/.config/sh/functions.sh

# if running bash
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
    # shellcheck source=.bashrc
    . "$HOME/.bashrc"
fi

# For ls, remove quotes around names
export QUOTING_STYLE=literal
export CLICOLOR=1

# Setup readline inputrc config
export INPUTRC="$HOME/.config/readline/inputrc"

# set PATH so it includes user's private bin if it exists
prepend_to_path "/usr/local/bin"
prepend_to_path "$HOME/bin"
prepend_to_path "$HOME/.local/bin"
append_to_path "$HOME/.config/dotfiles/scripts"

command -v st      1> /dev/null 2>&1 && export TERMINAL="st"
command -v less    1> /dev/null 2>&1 && export PAGER="less"
command -v pyenv   1> /dev/null 2>&1 && eval   "$(pyenv init -)"
command -v firefox 1> /dev/null 2>&1 && export BROWSER="firefox"
command -v i3lock  1> /dev/null 2>&1 && export LOCKER="i3lock"

command -v grip  1> /dev/null 2>&1 && export GRIPHOME="$HOME/.config/grip"

if command -v xrandr 1> /dev/null 2>&1; then
    PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"
    export PRIMARY_DISPLAY
fi


# Add texlive
if [ -d "$HOME/.texlive/2019/" ]; then
    append_to_path "$HOME/.texlive/2019/bin/x86_64-linux/"
    MANPATH=$MANPATH:$HOME/.texlive/2019/texmf-dist/doc/man/
    INFOPATH=$INFOPATH:$HOME/.texlive/2019/texmf-dist/doc/info/
    # export TEXMFCNF="$HOME/.texlive/2019/:"
fi

# Opt-out of Microsoft telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Add rust cargo packages
# shellcheck source=.config/cargo/bin
append_to_path "$HOME/.cargo/bin"

PATH=$(cleanup_path "$PATH")
MANPATH=$(cleanup_path "$MANPATH")
INFOPATH=$(cleanup_path "$INFOPATH")

# startx should always be the last line
[ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && startx


if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
    eval "$(direnv hook bash)"
fi
