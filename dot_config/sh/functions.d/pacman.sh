#!/usr/bin/env sh

# If not running interactively, don't do anything
case "$-" in
    *i*) ;;
    *)   return ;;
esac

pacfindexec() {
  for ARG in $(pacman -Qql $1); do
    [ ! -d $ARG ] && [ -x $ARG ] && echo $ARG;
  done
}
