#!/usr/bin/env sh
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# shellcheck source=.config/sh/enviroment.sh
[ -r ~/.config/sh/enviroment.sh ] && . ~/.config/sh/enviroment.sh

# startx should always be the last line
[ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && startx
