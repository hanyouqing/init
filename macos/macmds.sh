#!/bin/bash

hostname(){
    HOSTNAME="${$1:=YouqingsMBP}"
    sudo scutil --set HostName ${HOSTNAME}
    sudo scutil --set ComputerName ${HOSTNAME}
}

#
# Copy files from timemachine backup disk need to reset mode.
#      https://apple.stackexchange.com/questions/26776/what-is-the-mark-at-the-end-of-file-description
reset() {
    fd="$1"
    sudo xattr -r -c        ${fd}
    sudo chmod -R -N        ${fd}
    sudo chown -R $(whoami) ${fd}
}

exec "${@}"