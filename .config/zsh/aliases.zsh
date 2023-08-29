#!/usr/bin/env sh
# Keep it POSIX-compliant until I have no reason to

# shellcheck source=../sh/aliases.sh
[ -s ~/.config/sh/aliases.sh ] && . ~/.config/sh/aliases.sh

## Workaround for zsh completions not working with the dotfiles alias because it
## is not expanding out $HOME.
## In the future, we could try something like the following:
##
## -- Step 1 --
## # Add the following to zsh
## zstyle ':completion:*:*:git:*' user-commands dotfiles:'dotfiles dotfile git alias'
##
## -- Step 2 --
## edit /usr/share/zsh/functions/Completion/Unix/_git (around line 8444)
##
## Before:
## (( $+opt_args[--git-dir] )) && local -x GIT_DIR=${(Q)${~opt_args[--git-dir]}}
## (( $+opt_args[--work-tree] )) && local -x GIT_WORK_TREE=${(Q)${~opt_args[--work-tree]}}
##
## After:
## (( $+opt_args[--git-dir] )) && local -x GIT_DIR=${(Q)${(e)~opt_args[--git-dir]}}
## (( $+opt_args[--work-tree] )) && local -x GIT_WORK_TREE=${(Q)${(e)~opt_args[--work-tree]}}
##
## See:
## - https://www.zsh.org/mla/workers/2023/msg00282.html
## - https://github.com/ohmyzsh/ohmyzsh/issues/6137
## - https://www.google.com/search?q=zsh+git+work-tree+completion
## - https://www.zsh.org/mla/workers/2017/msg01186.html
## - https://unix.stackexchange.com/questions/350797/zsh-git-filename-completion-with-git-dir-work-tree-not-a-git-repo
## - https://www.zsh.org/mla/workers/2023/msg00272.html
##
##
## Alternatively, you can use '~' instead of $HOME and it should work out fine.
#if [ -d "$HOME/.dotfiles" ] && [ ~ = $HOME ]; then
#    alias dotfiles='git --git-dir ~/.dotfiles/ --work-tree ~'
#fi

# nnn file manager
if [ "$(command -v nnn)" ] && [ -s ~/.config/nnn/misc/quitcd.bash_zsh ]; then
    . ~/.config/nnn/misc/quitcd.bash_zsh
    alias nnn="nnncd -Ad"
fi

if command -v trash >/dev/null 2>&1; then
    alias rm='echo "Use \"trash\". If you meant rm, use \"\\\rm\"."; false'
else
    alias rm='rm -i'
fi
