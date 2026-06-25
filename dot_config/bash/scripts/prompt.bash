#!/usr/bin/env sh

INIT_PROMPT_COMMAND="$PROMPT_COMMAND"
BACKUP_PS1=${PS1:='[\u@\h \w]\n\$ '}

reset_prompt() {
    if [ "${screen_clear:='false'}" = 'true' ]; then
        unset screen_clear
        PS1="$BACKUP_PS1"
    else
        PS1="\\n$BACKUP_PS1"
    fi
}

init_prompt() {
    is_new_login="t"
    PROMPT_COMMAND='{
        if [ "$is_new_login" = "t" ]; then
            is_new_login="f"
            eval $INIT_PROMPT_COMMAND
        else
            unset is_new_login
            if [ "$INIT_PROMPT_COMMAND" ]; then
                PROMPT_COMMAND="$INIT_PROMPT_COMMAND; reset_prompt"
            else
                PROMPT_COMMAND="reset_prompt"
            fi
            reset_prompt
        fi
    }'
}

init_prompt
