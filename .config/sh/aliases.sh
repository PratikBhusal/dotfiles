#!/usr/bin/env sh

# If not running interactively, don't do anything
case "$-" in
    *i*) ;;
    *)   return ;;
esac

# enable color support of and add handy aliases
if [ "$DOTFILES_MACHINE" = 'Linux' ]; then
    if command -v dircolors >/dev/null 2>&1 ; then

        if [ -r ~/.dircolors ]; then
            eval "$(dircolors -b ~/.dircolors)"
        else
            eval "$(dircolors -b)"
        fi

        alias ls='ls -hp --group-directories-first --color=auto'
        # alias dir='dir --color=auto'
        # alias vdir='vdir --color=auto'

        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    else
        alias ls='ls -hp --group-directories-first'
    fi
elif [ "$DOTFILES_MACHINE" = 'Mac' ]; then
        alias ls='ls -hp'
fi

if command -v lsd >/dev/null; then
    alias ls='lsd -hF --group-dirs first'
    alias tree='lsd -hF --group-dirs first --tree'

elif [ "$DOTFILES_MACHINE" = 'Linux' ]; then
    if command -v dircolors >/dev/null 2>&1 ; then
        alias ls='ls -hp --group-directories-first --color=auto'
        # alias dir='dir --color=auto'
        # alias vdir='vdir --color=auto
    else
        alias ls='ls -hp --group-directories-first'
    fi
elif [ "$DOTFILES_MACHINE" = 'Mac' ]; then
    alias ls='ls -hp'
fi


if [ -d "$HOME/.dotfiles" ]; then
    alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    alias dotfilesedit='GIT_DIR=$HOME/.dotfiles ${VISUAL:-${EDITOR:-vim}}'
fi

alias cp='cp -i'
alias mv='mv -i'

# alias journalctl='sudo journalctl'
# alias systemctl='sudo systemctl'

alias tmux="tmux -2"

if [ "$LANG" = '' ]; then
    export LANG=en_US.UTF-8
fi

alias latexmk="latexmk -pdf"

alias mkdir="mkdir -vp"

if command -v bat >/dev/null; then
    alias cat="bat"
elif command -v batcat >/dev/null; then
    alias cat="batcat"
fi
command -v i3lock >/dev/null 2>&1 && alias i3lock="i3lock -c 202020"
command -v uxterm >/dev/null 2>&1 && alias xterm="uxterm"
command -v dragon-drag-and-drop >/dev/null 2>&1 && alias dragon="dragon-drag-and-drop"
command -v ncdu >/dev/null 2>&1 && alias du="ncdu"
command -v xdg-open >/dev/null 2>&1 && alias open="xdg-open"


if command -v ipython >/dev/null; then
    interactive_python () {
        if [ -z "$1" ]; then
            ipython
        else
            command python "$@"
        fi
    }
    alias python=interactive_python
    alias python3=interactive_python
fi

alias diff='diff -U 0'



# if command -v vim >/dev/null; then
#     alias vi="vim"
# elif command -v nvim >/dev/null; then
#     alias vi="nvim"
# fi

# export QT_STYLE_OVERRIDE=gtk
# export QT_SELECT=qt5

command -v mpv >/dev/null 2>&1 && alias streamaudio="mpv --no-video --no-cache --volume=50"
