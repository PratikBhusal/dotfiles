#!/usr/bin/env sh

if ! [ -x "$(command -v git)" ]; then
    echo 'Error! Please install git before trying to get dotfiles.' >&2
    exit 1
fi

if [ -d "$HOME"/.dotfiles ]; then
    echo "Bare Dotfiles repo already exists. If you want to get a fresh install, please delete it beforehand."
    exit 2
fi

git clone --bare git@github.com:PratikBhusal/dotfiles.git "$HOME"/.dotfiles
cd "$HOME" || exit 1

dotfiles() {
    git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME" "$@"
}
while ! dotfiles checkout; do
    mkdir -p ~/.dotfiles-backup
    dotfiles checkout 2>&1 | grep -E "^\\s+" | cut -f 2 | \
        sed 's/\(.*\)\//\1 /' | \
        awk 'NF!=1 {print $0; next} {print "." , $0}' | \
        xargs -l sh -c "mkdir -p ~/.dotfiles-backup/$0 && \
        mv ~/$0/$1 ~/.dotfiles-backup/$0/$1" 1> /dev/null 2>&1
done

dotfiles config user.email PratikBhusal@users.noreply.github.com

# if  [ -x "$(command -v git)" ] &&
#     [ -x "$(command -v rsync)" ] &&
#     [ ! -d "$HOME/.dotfiles" ]; then
#     git clone --separate-git-dir="$HOME"/.dotfiles git@github.com:PratikBhusal/dotfiles.git tmpdotfiles

#     rsync --recursive --verbose --links --exclude '.git' tmpdotfiles/ "$HOME"/
#     rm -r tmpdotfiles

#     dotfiles config --local status.showUntrackedFiles no

# elif [ ! -x "$(command -v git)" ] || [ ! -x "$(command -v rsync)" ]; then
#     echo "please install git and rsync before trying to install dotfiles"
# fi
