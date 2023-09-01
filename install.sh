#!/usr/bin/env sh

if ! [ -x "$(command -v git)" ]; then
    echo 'Error! Please install git before trying to get dotfiles.' >&2
    exit 1
fi

if [ -d "$HOME"/.dotfiles ]; then
    echo "Bare Dotfiles repo already exists. If you want to get a fresh install, please move/delete it."
    exit 2
fi

# Utilize `dotfiles fetch --deepen=<depth>` to increase depth if rebasing
git clone                                    \
    --single-branch                          \
    --depth 1                                \
    --separate-git-dir="$HOME"/.dotfiles     \
    git@github.com:PratikBhusal/dotfiles.git \
    "$HOME"/tmpdotfiles                      \
&& \rm tmpdotfiles/.git

cd "$HOME" || exit 3

dotfiles() {
    git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME" "$@"
}

EXISTING_FILES="$(dotfiles status --porcelain --untracked-files=no \
    | grep -e '^\s[MT]' \
    | cut -d ' ' -f 3 \
)"
if echo "$EXISTING_FILES" | head -c1 | grep -e '.'; then
    mkdir -p ~/.dotfiles-backup

    echo "$EXISTING_FILES"                          \
    | sed 's/\(.*\)\//\1 /'                         \
    | awk 'NF!=1 {print $0; next} {print "." , $0}' \
    | awk 'BEGIN {h=" \"$HOME\"/"}
      { print "mkdir -p" h ".dotfiles-backup/" $1, "&& cp" h $1 "/" $2 h ".dotfiles-backup/" $1 "/" $2 }' \
    | sh
fi

dotfiles config user.name  PratikBhusal
dotfiles config user.email PratikBhusal@users.noreply.github.com

if [ -x "$(command -v rsync)" ]; then
    # Formatting & Running Shell Script:
    # ------------------------------------------------------------------------------
    # $ \
    # time \
    #     rsync --recursive --links tmpdotfiles/ "$HOME"/
    # rsync --recursive --links tmpdotfiles/ "$HOME"/  0.06s user 0.03s system 107% cpu 0.087 total
    # Total Time: 0.087
    rsync --recursive --verbose --links tmpdotfiles/ "$HOME"/
    \rm -rf tmpdotfiles
else
    # Make directories then copy files
    #
    # $
    # time
    #     {
    #         find ./tmpdotfiles -type d \
    #         | cut -d '/' -f 3- \
    #         | awk -F '\n' 'BEGIN {h="$HOME/"} { print "mkdir -p \"" h $1 "\"" }' \
    #         &&
    #         find ./tmpdotfiles \( -type f -o -type l \) \
    #         | cut -d '/' -f 3-         \
    #         | awk -F '\n' 'BEGIN {h="$HOME/"}
    #           { print "cp -P \"" h "tmpdotfiles/" $1 "\" \"" h $1 "\"" }'
    #     } | sh
    # { find ./tmpdotfiles -type d | cut -d '/' -f 3- | awk -F '\n'  && find  \(  f}  0.01s user 0.00s system 178% cpu 0.007 total
    # sh  0.19s user 0.09s system 104% cpu 0.270 total
    # Total Time: 0.277
    {
        find ./tmpdotfiles -type d \
        | cut -d '/' -f 3- \
        | awk -F '\n' 'BEGIN {h="$HOME/"} { print "mkdir -p \"" h $1 "\"" }' \
        &&
        find ./tmpdotfiles \( -type f -o -type l \) \
        | cut -d '/' -f 3-         \
        | awk -F '\n' 'BEGIN {h="$HOME/"}
          { print "cp -P \"" h "tmpdotfiles/" $1 "\" \"" h $1 "\"" }'
    } | sh
    \rm -rf tmpdotfiles
fi

# dotfiles config --local status.showUntrackedFiles no
dotfiles config --local core.worktree "$HOME"

# Use default pager if delta diff tool does not exist
if ! command -v delta 1> /dev/null 2>&1; then
    git config --global --unset core.pager
fi

# Use default diff tool if nvim does not exist
if ! command -v nvim 1> /dev/null 2>&1; then
    git config --global --unset diff.tool
fi
