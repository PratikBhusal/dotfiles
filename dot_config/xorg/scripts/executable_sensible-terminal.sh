#!/usr/bin/env sh

# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License version 2 as published by the Free
# Software Foundation.

# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License version 2 for
# more details.

# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <https://www.gnu.org/licenses/>.

for term in "$TERMINAL" st alacritty x-terminal-emulator xfce4-terminal uxterm xterm; do
    if command -v "$term" > /dev/null 2>&1; then
        CMD="$term $*"
        break
    fi
done

[ ! "$CMD" ] && echo 'No terminal emulator found! Install one please.' && exit 1


CWD=''

if command -v xprop > /dev/null 2>&1; then
    PID=$(
        xprop -id "$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/ {print $NF}')" |
        grep -m 1 PID |
        cut -d " " -f 3
    )
    if [ -n "$PID" ]; then
        PROCESS=$(pstree -lpA "$PID" | tail -n 1 | awk -F'---' '{print $NF}')
        PID=$(echo "$PROCESS" | sed -re 's/[^0-9]//g')

        case "$PROCESS" in
            tmux* )
                # rm ~/debug.log
                # rm ~/tmux.info
                # echo "Focused Tmux Session (May not be active Windows):" >> ~/tmux.info
                # tmux display-message -ap >> ~/tmux.info

                # To get the pid of the actual process we find the pts of the
                # tmux process found above.
                # We can ignore the shellcheck because we are NOT after the PID.
                # shellcheck disable=SC2009
                PTS=$(ps -ef | grep "$PID" | grep -v 'grep' | awk '{print $6}')

                # find the tmux session that's attached to the pts
                # TMUX_CLIENT_SESSION=$(tmux list-clients -t /dev/${PTS} -F "#{client_session}")
                # printf "tmux list-clients info:\n%s\n\n" "$(tmux list-clients -t /dev/${PTS})" >> ~/debug.log
                # printf "tmux list-clients info path:\n%s\n\n" "$(tmux list-clients -t /dev/${PTS} -F '#{pane_current_path}')" >> ~/debug.log
                # printf "tmux list-windows info:\n%s\n\n" "$(tmux list-windows -t $TMUX_CLIENT_SESSION)" >> ~/debug.log
                # printf "tmux list-panes info:\n%s\n\n" "$(tmux list-panes -st $TMUX_CLIENT_SESSION)" >> ~/debug.log


                # # find the pane_pid of the session
                # PID=$(tmux list-panes -st $TMUX_CLIENT_SESSION  -F '#{pane_pid}')
                # printf "PID(s):\n%s\n\n" "$PID" >> ~/debug.log

                CWD=$(tmux list-clients -t /dev/"${PTS}" -F '#{pane_current_path}')

                # printf "CWD:\n%s\n" "$CWD" >> ~/debug.log
                ;;
            *     )
                if command -v xcwd > /dev/null 2>&1; then
                    CWD=$(xcwd)
                    case "$CWD" in
                        $HOME/* ) ;;
                        *       ) CWD=$HOME;;
                    esac
                elif [ -e "/proc/$PID/cwd" ]; then
                    CWD=$(readlink /proc/"$PID"/cwd)
                fi
                ;;
        esac
    fi

elif command -v xcwd > /dev/null 2>&1 ; then
    # Note: xcwd is currently NOT compatible with terminal multiplexers. Please
    # install xprop. The package name could be: xorg-xprop, x11-utils, etc.
    CWD=$(xcwd)
    case "$CWD" in
        $HOME/* ) ;;
        *       ) CWD=$HOME;;
    esac
fi

if [ -z "$OPEN_IN_TMUX" ]; then
    OPEN_IN_TMUX=1
fi

if [ $OPEN_IN_TMUX = 1 ] && command -v tmux > /dev/null 2>&1; then
    case "$CMD" in
        *-e* ) ;;
        *    )
            CMD="$CMD -e tmux"
            # if [ -z "$TMUX" ]; then
            #     TMUX_SESSION_ID="$(tmux ls | grep -vm1 attached | cut -d: -f1)"

            #     if [ "$TMUX_SESSION_ID" ]; then
            #         CMD="$CMD -e tmux attach-session -t $TMUX_SESSION_ID"
            #     else
            #         CMD="$CMD -e tmux"
            #     fi
            # else
            #     CMD="$CMD -e tmux"
            # fi
            ;;
    esac
fi

if [ -n "$CWD" ]; then
    cd "$CWD" && $CMD 1> /dev/null 2>&1
else
    $CMD 1> /dev/null 2>&1
fi
