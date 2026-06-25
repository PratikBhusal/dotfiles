#!/usr/bin/env sh
# `local` is supported by many shells. Most likely, we are not running in a
# truly POSIX shell. It should be safe to ignore this warning.
# shellcheck disable=SC3043

# Shared library function for executing scripts in .d directories
# This file is meant to be sourced by other scripts

# Execute all executable files in a .d directory
# Usage: run_d_directory <directory_path> <error_prefix>
#   directory_path: Path to the .d directory
#   error_prefix: Prefix for error messages (e.g., "bootstrap", "post_merge hook")
run_d_directory() {
    local dir_path="$1"
    local error_prefix="$2"

    # If directory does not exist, exit with error
    if [ ! -d "$dir_path" ]; then
        echo "Error: $error_prefix directory '$dir_path' not found" >&2
        exit 1
    fi

    find -L "$dir_path" -type f | sort | while IFS= read -r script; do
        # 1. Check that the file is executable. If not an executable file, skip.
        [ -x "$script" ] || continue
        # 2. Check that the does not contain the substring '##' (ie
        #    template files) nor end with '~' (ie editor backup files)
        case "$script" in
        *'##'*) continue ;;
        *'~') continue ;;
        esac

        # Check that the script ran successfully. If not, throw an error.
        if ! "$script"; then
            echo "Error: $error_prefix '$script' failed" >&2
            exit 1
        fi
    done
}
