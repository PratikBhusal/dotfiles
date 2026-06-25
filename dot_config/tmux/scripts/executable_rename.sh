#!/usr/bin/env sh

command -v dmenu > /dev/null 2>&1 || return

target=$(printf 'cancel\nsession\nwindow' | dmenu -b -p "Which one do you want to modify?")

if [ "$target" = 'session' ]; then
    tmux command-prompt -I "#S" "rename-$target -- '%%'"
elif [ "$target" = 'window' ]; then
    tmux command-prompt -I "#W" "rename-$target -- '%%'"
fi
# tmux command-prompt -p "Please enter new $target name:" "rename-$target '%1'"
