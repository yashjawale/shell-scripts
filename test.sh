#!/bin/bash

spinner_pid=

function start_spinner {
    set +m
    echo -n -e "$1         "
    { while : ; do for X in '  •     ' '   •    ' '    •   ' '     •  ' '      • ' '     •  ' '    •   ' '   •    ' '  •     ' ' •      ' ; do echo -en "\b\b\b\b\b\b\b\b$X" ; sleep 0.1 ; done ; done & } 2>/dev/null
    # while :; do for s in / - \\ \|; do printf "\r$s"; sleep .1; done; done
    spinner_pid=$!
}

function stop_spinner {
    { kill -9 $spinner_pid && wait; } 2>/dev/null
    set -m
    echo -en "\033[2K\r"
}

trap stop_spinner EXIT

start_spinner "Sleeping"
sleep 4
stop_spinner

start_spinner "Updating Brew"
brew update
stop_spinner

start_spinner "hello \nWith echo"
sleep 2
echo -e "\n\n THIS IS A OUTPUT"
sleep 2
stop_spinner
