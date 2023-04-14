#!/usr/bin/env sh

# i3lockARGS=("-c" "202020")

# Hopefully one of these is installed
for lock in "$LOCKER" i3lock slock; do
    lockname="$(echo "$lock" | cut -d " " -f1)"
    if command -v "$lockname" > /dev/null 2>&1; then
        if [ "$lockname" = "i3lock" ]; then
            # exec "$lockname" "-c" "202020" "$@"
            exec "$lockname" "-c" "000000" "$@"
        else
            exec "$lock" "$@"
        fi
    fi
done


# !/usr/bin/env bash
# # Hopefully one of these is installed
# for lock in "$LOCKER" i3lock slock; do
#     lockname="$(echo "$lock" | cut -d " " -f1)"
#     if command -v "$lockname" > /dev/null 2>&1; then
#         read -ra CMD <<< "$lock"
#         exec "${CMD[@]}" "$@"
#     fi
# done
