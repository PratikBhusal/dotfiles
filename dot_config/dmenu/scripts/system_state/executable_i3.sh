#!/usr/bin/env sh

PROMPT="What state do you want the computer to be in?"
OPTIONS="cancel\nlock\nlogout\nsuspend\nhibernate\nreboot\nshutdown"


confirm() {
    [ "$( printf "No\nYes" | dmenu -i -p "Are you sure you want to $1?")" = "Yes" ] && return 0
}

case $(printf "%b" "$OPTIONS" | dmenu -i -p "$PROMPT")  in
    lock      ) ~/.config/xorg/scripts/sensible-locker.sh;;
    logout    ) i3-msg -q exit;;
    suspend   ) ~/.config/xorg/scripts/sensible-locker.sh && systemctl suspend;;
    hibernate ) ~/.config/xorg/scripts/sensible-locker.sh && systemctl hibernate;;
    reboot    ) confirm "reboot" && systemctl reboot;;
    shutdown  ) confirm "shutdown" && systemctl poweroff -i;;
esac
