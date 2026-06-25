#!/usr/bin/env sh

# Execute all executable files (excluding templates and editor backups) in the
# $XDG_CONFIG_HOME/yadm/hooks/<hook_name>.d directory when run.
# This script is designed to be symlinked as post_merge, post_pull, post_rebase, or post_reset.

set -eu

# Source the shared library functions
LIB_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/yadm/lib"

# Get the hook name from the script name (e.g., post_merge, post_pull)
HOOK_NAME="$(basename "$0")"

# Directory to look for hook executables in
HOOK_D="${XDG_CONFIG_HOME:-$HOME/.config}/yadm/hooks/${HOOK_NAME}.d"

# Compute script directory for fallback path
if [ -n "${BASH_SOURCE:-}" ]; then
    # shellcheck disable=SC3054
    SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
else
    SCRIPT_DIR="$(dirname "$0")"
fi

# shellcheck source=../lib/resolve-d-directory.sh
. "${LIB_DIR}/resolve-d-directory.sh"

# Resolve the directory with fallback logic
HOOK_D="$(resolve_d_directory "$HOOK_D" "$SCRIPT_DIR" "$HOOK_NAME")"


# shellcheck source=../lib/run-d-directory.sh
. "${LIB_DIR}/run-d-directory.sh"

# Execute scripts in the directory
run_d_directory "$HOOK_D" "${HOOK_NAME} hook"
