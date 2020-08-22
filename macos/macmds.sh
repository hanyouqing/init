#!/bin/bash

hostname() {
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

# @reference:
#   https://support.apple.com/en-us/HT202516
flushdns() {
    # OS X v10.10.4 or later
    sudo killall -HUP mDNSResponder

    # OS X v10.10 through v10.10.3
    sudo discoveryutil mdnsflushcache

    # OS X v10.9.5 and earlier
    sudo killall -HUP mDNSResponder

    # OS X v10.6 through v10.6.8
    sudo dscacheutil -flushcache
}

exec "${@}"
