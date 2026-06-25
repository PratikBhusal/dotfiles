#!/usr/bin/env sh
# `local` is supported by the interactive shells this file is sourced into.
# shellcheck disable=SC3043

# If not running interactively, don't do anything
case "$-" in
    *i*) ;;
    *)   return ;;
esac

if ! command -v mpv >/dev/null 2>&1; then
    return
fi

if ! command -v fzf >/dev/null 2>&1; then
    return
fi

streamaudio() {
    if [ "$#" -eq 1 ]; then
        case "$1" in
            --help|-h)
                \cat <<'EOF'
Usage:
  streamaudio
  streamaudio --choose
  streamaudio --random
  streamaudio URL [URL...]

Options:
  --choose    Pick from the built-in YouTube audio streams with fzf.
  --random    Play a random built-in YouTube audio stream.
  --help      Show this help text.
EOF
                return
                ;;
        esac
    fi

    local has_choose
    local has_random
    local arg
    for arg in "$@"; do
        case "$arg" in
            --choose) has_choose=1 ;;
            --random) has_random=1 ;;
        esac
    done

    if [ -n "$has_choose" ] && [ -n "$has_random" ]; then
        echo 'Error! Please provide only one of --choose or --random' >&2
        return 1
    fi

    streamaudio_mpv() {
        mpv --no-video --no-sub-auto --no-sub --cache-pause=yes --cache-pause-wait=10 "$@"
    }

    local entries
    entries=$(
        streamaudio_entry() {
            printf '%s\t%s\n' "$1" "$2"
        }

        streamaudio_entry \
            'lofi hip hop radio' \
            'https://www.youtube.com/watch?v=X4VbdwhkE10'
        streamaudio_entry \
            'asian lofi' \
            'https://www.youtube.com/watch?v=1Tl2FtV06qo'
        streamaudio_entry \
            'jazz lofi' \
            'https://www.youtube.com/watch?v=E2vONfzoyRI'
        streamaudio_entry \
            'classical music' \
            'https://www.youtube.com/watch?v=jXAEIWcGXwE'
        streamaudio_entry \
            'relaxing jazz' \
            'https://www.youtube.com/watch?v=A8jDx9TLMQc'
        streamaudio_entry \
            'chill guitar' \
            'https://www.youtube.com/watch?v=E_XmwjgRLz8'
    )

    local selection
    case "$#" in
        0)
            selection=$(printf '%s\n' "$entries" | sed -n '1p')
            ;;
        1)
            case "$1" in
                --choose)
                    selection=$(printf '%s\n' "$entries" | fzf --delimiter="$(printf '\t')" --with-nth=1)
                    if [ -z "$selection" ]; then
                        unset -f streamaudio_mpv
                        return 1
                    fi
                    ;;
                --random)
                    selection=$(printf '%s\n' "$entries" | awk 'BEGIN { srand() } { line[NR] = $0 } END { if (NR > 0) print line[int(rand() * NR) + 1] }')
                    ;;
                *)
                    streamaudio_mpv "$@"
                    # Preserve mpv's exit status before unsetting the helper.
                    local streamaudio_status
                    streamaudio_status=$?
                    unset -f streamaudio_mpv
                    return "$streamaudio_status"
                    ;;
            esac
            ;;
        *)
            streamaudio_mpv "$@"
            local streamaudio_status
            streamaudio_status=$?
            unset -f streamaudio_mpv
            return "$streamaudio_status"
            ;;
    esac

    local selected_url
    selected_url=$(printf '%s\n' "$selection" | cut -f 2-)
    if [ -z "$selected_url" ]; then
        unset -f streamaudio_mpv
        return 1
    fi

    streamaudio_mpv "$selected_url"
    local streamaudio_status
    streamaudio_status=$?
    unset -f streamaudio_mpv
    return "$streamaudio_status"
}
