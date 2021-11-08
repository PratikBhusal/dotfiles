#!/usr/bin/env sh
# shellcheck disable=SC3043

extract_audio() {
    if ! [ -x "$(command -v ffmpeg)" ]  || \
       ! [ -x "$(command -v ffprobe)" ] || \
       ! [ -x "$(command -v fzf)" ];    then
        echo 'Error! Please install ffmpeg, ffprobe, and fzf' >&2
        exit 1
    fi

    # Extract (multiple) audio tracks based on entries list. Final sed command
    # remove any lines with only whitespace.
    local audio_tracks
    audio_tracks=$(
        ffprobe                                    \
            -v error                               \
            -select_streams a                      \
            -show_entries stream=index,codec_name  \
            -of default=noprint_wrappers=1:nokey=1 \
            "$1"                                   \
        | paste -d ' ' - -                         \
        | sed                                      \
            -e  's/^[ \t\v\f\n\r]*//'              \
            -e 's/[ \t\v\f\n\r]*$//'               \
            -e '/^$/d'
    )


    local selection
    case "$(printf "%s\n" "$audio_tracks"| wc -l)" in
        *0*)
            echo 'Error! No tracks found!' >&2
            ;;
        *1*)
            selection="$audio_tracks"
            ;;
        *[23456789]*)
            selection="$(printf "%s\n" "$audio_tracks"| fzf)"
            ;;
        *)
            echo "Error! Unknown Input Processing: $audio_tracks" >&2
            exit 2
    esac

    local filename
    filename=$(basename "$1")

    local output_filename
    output_filename="${filename%.*}.$(printf "%s\n" "$selection" | awk '{ print $2 }')"
    ffmpeg                                                                \
        -i "$1"                                                           \
        -map 0:a:"$(printf "%s\n" "$selection" | awk '{ print $1 - 1 }')" \
        -c copy                                                           \
        "$output_filename"
    echo "$output_filename"
}
