#!/usr/bin/env sh

if [ -f "$HOME/.profile" ]; then
    # shellcheck source=../../.profile
    . "$HOME/.profile"
fi

eval "$(pipenv --completion)"
# eval "$(direnv hook zsh)"
. ~/.fzf.zsh
