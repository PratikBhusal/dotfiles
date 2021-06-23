#!/usr/bin/env sh

prepend_to_path() {
  if [ -d "$1" ]; then
    case ":$PATH:" in
      *":$1:"*) :;; # already there
      *) export PATH="$1:$PATH";;
    esac
  fi
}

append_to_path() {
  if [ -d "$1" ]; then
    case ":$PATH:" in
      *":$1:"*) :;; # already there
      *) export PATH="$PATH:$1";;
    esac
  fi
}

cleanup_path() {
    echo "$1" | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}'
}
