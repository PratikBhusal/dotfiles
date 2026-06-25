#!/usr/bin/env sh

# If not running interactively, don't do anything
case "$-" in
    *i*) ;;
    *)   return ;;
esac

sshcd() {
    ssh -t "$1" "cd \"$2\"; exec \$SHELL -l";
}

svgtopng() {
    basename "$1" .svg | xargs -I {} inkscape -b FFFFFF -d 384 {}.svg -o {}.png
}

mkchdir () {
    MKDIR_CMD="mkdir"
    if man $MKDIR_CMD | grep -E "^\s+\-.*v\b" > /dev/null; then
        MKDIR_CMD="$MKDIR_CMD -vp"
    else
        MKDIR_CMD="$MKDIR_CMD -p"
    fi

    # Taken & modified from: https://unix.stackexchange.com/a/9124
    case "$1" in
        */..|*/../ ) cd -- "$1"                                                         || exit;; # directory exists
        /*/../*    ) (cd "${1%/../*}/.."   && $MKDIR_CMD "./${1##*/../}") && cd -- "$1" || exit;;
        /*         ) $MKDIR_CMD "$1"       && cd "$1"                                   || exit;;
        */../*     ) (cd "./${1%/../*}/.." && $MKDIR_CMD "./${1##*/../}") && cd "./$1"  || exit;;
        ../*       ) (cd ..                && $MKDIR_CMD "${1#.}")        && cd "$1"    || exit;;
        *          ) $MKDIR_CMD "./$1"     && cd "./$1"                                 || exit;;
    esac
}
