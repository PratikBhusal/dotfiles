#!/usr/bin/env zsh


# Tip: use "zinit load ${PLUGIN NAME}" if you want to see reports ie tracking
# what the plugin does and unload the plugin. Otherwise, use "zinit light
# ${PLUGIN NAME}"

# Provide command autosuggestions
zinit light zsh-users/zsh-autosuggestions

# Mention aliases that you've set but are not using
# zinit light MichaelAquilina/zsh-you-should-use

# If a command was not found, mention some similarly names commands that could
# be downloaded
zinit snippet OMZ::plugins/command-not-found/command-not-found.plugin.zsh

# Iteractive cd
zinit snippet OMZ::plugins/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh

# Get the pure shell prompt plugin {{{
    autoload -U promptinit; promptinit

    export PURE_PROMPT_SYMBOL="❱ "
    export PURE_PROMPT_VICMD_SYMBOL="❰ "
    # export PURE_GIT_UP_ARROW=""
    # export PURE_GIT_DOWN_ARROW=""
    zstyle :prompt:pure:git:stash show yes
    zstyle :prompt:pure:path color bright-white
    zstyle :prompt:pure:git:branch color blue
    zstyle :prompt:pure:virtualenv color green


    # Can't get it to work with this just yet. Just installed via Arch User
    # Repository
    # prompt pure

    # Load the pure theme, with zsh-async library that's bundled with it.
    zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
    zinit light sindresorhus/pure
# Get the pure shell prompt plugin }}}

# zinit light denysdovhan/spaceship-prompt

# Add syntax highlighting
zinit light zdharma/fast-syntax-highlighting

# Add direnv support
zinit from"gh-r" as"program" mv"direnv* -> direnv" \
    atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
    pick"direnv" src="zhook.zsh" for \
        direnv/direnv
