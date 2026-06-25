#!/usr/bin/env sh
#
# This code is released in public domain by Han Boetes <han@mijncomputer.nl>
#
# This script tries to exec an editor by trying some known editors if $EDITOR is
# not set.
#
# Distributions/packagers can enhance this script with a distribution-specific
# mechanism to find the preferred editor

# Hopefully one of these is installed
for edit in "$VISUAL" "$EDITOR" nvim vim vi gvim gedit; do
    if command -v "$edit" > /dev/null 2>&1; then
        exec "$edit" "$@"
    fi
done
