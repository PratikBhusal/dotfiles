#!/usr/bin/env sh

function pacfindexec() {
  for ARG in $(pacman -Qql $1); do
    [ ! -d $ARG ] && [ -x $ARG ] && echo $ARG;
  done
}
