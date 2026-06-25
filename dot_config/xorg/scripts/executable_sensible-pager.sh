#!/usr/bin/env sh
#
# This code is released in public domain by Han Boetes <han@mijncomputer.nl>

# This script tries to exec a pager by trying some known pagers if $PAGER is
# not set.
#
# Distributions/packagers can enhance this script with a
# distribution-specific mechanism to find the preferred pager.

# We don't use 'more' because it will exit if the file is too short.
# Worst case scenario we'll open the file in your editor.
for page in "$PAGER" less most bat ~/.config/xorg/scripts/editor.sh; do
    if command -v "$page" > /dev/null 2>&1; then
        exec "$page" "$@"
    fi
done
