#!/usr/bin/env zsh

command -v pokemon-colorscripts 1> /dev/null 2>&1 && pokemon-colorscripts -r

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

# Enable colors and changeprompt
autoload -U colors && colors

[ "$LANG" = '' ] && export LANG=en_US.UTF-8

# shellcheck source=.config/sh/functions.d/extract_audio.sh
[ -s ~/.config/sh/functions.d/extract_audio.sh ] && . ~/.config/sh/functions.d/extract_audio.sh

# shellcheck source=.config/zsh/aliases.zsh
[ -s ~/.config/zsh/aliases.zsh ] && . ~/.config/zsh/aliases.zsh


# shellcheck source=.config/zsh/functions.zsh
[ -s ~/.config/zsh/functions.zsh ] && . ~/.config/zsh/functions.zsh


if command -v nvim 1> /dev/null 2>&1; then
    export VISUAL="nvim"
    export EDITOR="$VISUAL"
elif command -v vim 1> /dev/null 2>&1; then
    export VISUAL=vim
    export EDITOR="$VISUAL"
fi


# History in cache directory:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.cache/zsh/history

# Enable command auto-completion
# autoload -Uz compinit
# zmodload zsh/complist

# if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
#     compinit;
# else
#     compinit -C;
# fi;
zmodload zsh/complist

# Arrow-key driven interface
zstyle ':completion:*' menu select

# Have same colors as the ls command for files
# eval "$(dircolors)" # Do not need to call if done in aliases.zsh file
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# disable auto-completion for aliases
# setopt COMPLETE_ALIASES

# Change directory via directory name
setopt autocd

# Auto complete with case insenstivity
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Rehash every so oftern
zstyle ':completion:*' rehash true


# Vim-mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char
# Fix backspace bug when switching modes
bindkey "^?" backward-delete-char


# In normal mode, type spacebar to edit command in vim
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd ' ' edit-command-line


# Change cursor shape for different vi modes {{{
# Set cursor style (DECSCUSR), VT520.
# 0 -> blinking block.
# 1 -> blinking block (default).
# 2 -> steady block.
# 3 -> blinking underline.
# 4 -> steady underline.
# 5 -> blinking bar, xterm.
# 6 -> steady bar, xterm.


_use_beam_cursor() {
   echo -ne '\e[6 q'
}

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
     _use_beam_cursor
  fi
}
zle -N zle-keymap-select

zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[6 q"
}
zle -N zle-line-init

precmd_functions+=(_use_beam_cursor)
# Change cursor shape for different vi modes }}}

# Load fzf default settings
command -v fzf 1> /dev/null 2>&1 && [ -f ~/.fzf.zsh ] && . ~/.fzf.zsh

# TODO: Look into a different plugin manager
#
# See:
# - https://github.com/rossmacarthur/zsh-plugin-manager-benchmark/tree/master
# - https://github.com/romkatv/zsh-bench/tree/master
# - https://github.com/mattmc3/zsh_unplugged

# Zim plugin manager {{{
zstyle ':zim:zmodule' use 'degit'

ZIM_HOME="${XDG_CACHE_HOME}"/zim

if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
  # source ${ZIM_HOME}/zimfw.zsh init -q
fi

# Initialize modules.
source ${ZIM_HOME}/init.zsh
# Zim plugin manager }}}

# shellcheck source=.config/nnn/config
[ -s ~/.config/nnn/config ] && . ~/.config/nnn/config

# Setup pipx
if command -v pipx 1> /dev/null 2>&1; then
    autoload -U bashcompinit
    bashcompinit
    eval "$(register-python-argcomplete pipx)"
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/plugin-configuration/powerlevel10k.zsh ]] || source ~/.config/zsh/plugin-configuration/powerlevel10k.zsh
