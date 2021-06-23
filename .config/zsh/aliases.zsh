#!/usr/bin/env sh
# Keep it POSIX-compliant until I have no reason to

# shellcheck source=../sh/aliases.sh
[ -s ~/.config/sh/aliases.sh ] && . ~/.config/sh/aliases.sh

# nnn file manager
if [ "$(command -v nnn)" ] && [ -s ~/.config/nnn/misc/quitcd.bash_zsh ]; then
    . ~/.config/nnn/misc/quitcd.bash_zsh
    alias nnn="nnncd -Ad"
fi

if command -v trash >/dev/null 2>&1; then
    alias rm='echo "Use \"trash\". If you meant rm, use \"\\\rm\"."; false'
else
    alias rm='rm -i'
fi
