#!/usr/bin/env sh

if [ -f "$HOME/.profile" ]; then
    # shellcheck source=../../.profile
    . "$HOME/.profile"
fi


command -v pipenv 1> /dev/null 2>&1 && eval "$(pipenv --completion)"
