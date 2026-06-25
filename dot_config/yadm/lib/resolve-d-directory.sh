#!/usr/bin/env sh
# `local` is supported by many shells. Most likely, we are not running in a
# truly POSIX shell. It should be safe to ignore this warning.
# shellcheck disable=SC3043

# Shared library function for resolving .d directory paths with fallback
# This file is meant to be sourced by other scripts

# Resolve a .d directory path with fallback logic
# Usage: resolve_d_directory <preferred_path> <fallback_dir> <fallback_base_name>
#   preferred_path: The preferred directory path (e.g., XDG config path)
#   fallback_dir: Directory for fallback (e.g., script directory).
#                 Fallback path is "${fallback_dir}/${fallback_base_name}.d".
#   fallback_base_name: The base name for fallback (e.g., "bootstrap", "post_merge")
# Returns: The resolved directory path via echo
resolve_d_directory() {
    local preferred_path="$1"
    local fallback_dir="$2"
    local fallback_base_name="$3"
    local resolved_path

    # If preferred path exists, return it immediately
    if [ -d "$preferred_path" ]; then
        echo "$preferred_path"
        return
    fi

    echo "Warning: $fallback_base_name directory '$preferred_path' not found." >&2

    # Try fallback_dir path
    resolved_path="${fallback_dir}/${fallback_base_name}.d"
    echo "Trying fallback: $resolved_path" >&2
    if [ -d "$resolved_path" ]; then
        echo "$resolved_path"
        return
    fi
    echo "Warning: Fallback directory '$resolved_path' also not found." >&2

    # Try BASH_SOURCE[0].d if in bash
    if [ -n "${BASH_SOURCE:-}" ]; then
        # shellcheck disable=SC3054
        resolved_path="${BASH_SOURCE[0]}.d"
        echo "Trying fallback: $resolved_path" >&2
        if [ -d "$resolved_path" ]; then
            echo "$resolved_path"
            return
        fi
        echo "Warning: Fallback directory '$resolved_path' also not found." >&2
    fi

    # Try $0.d as final fallback
    resolved_path="${0}.d"
    echo "Trying fallback: $resolved_path" >&2
    if [ -d "$resolved_path" ]; then
        echo "$resolved_path"
        return
    fi
    echo "Warning: Fallback directory '$resolved_path' also not found." >&2

    # None found, return the last candidate attempted
    echo "$resolved_path"
}
