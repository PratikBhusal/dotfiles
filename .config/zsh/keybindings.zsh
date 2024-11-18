#!/usr/bin/env sh

# If not running interactively, don't do anything
case "$-" in
    *i*) ;;
    *)   return ;;
esac

bindkey -r '^T'
bindkey '^P' fzf-file-widget
