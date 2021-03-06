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
    # OS X v10.9.5, v10.10.4 or later
    sudo killall -HUP mDNSResponder

    # OS X v10.10 through v10.10.3
    which discoveryutil && sudo discoveryutil mdnsflushcache

    # OS X v10.6 through v10.6.8
    sudo dscacheutil -flushcache

    # Clear Chrome DNS
    # chrome://net-internals/#dns
}

vpn() {
    local VPN_NAME="VPN (Office)"
    local STATUS=$(networksetup -showpppoestatus "$VPN_NAME")
    local ACTION=$1

    if [ $STATUS != "${ACTION}ed" ]; then
      networksetup -${ACTION}pppoeservice "$VPN_NAME"
      sleep 1
      STATUS=$(networksetup -showpppoestatus "$VPN_NAME")
      COUNTER=0
      while [ $STATUS != "${ACTION}ed" ] && [ $COUNTER -lt 30 ]; do
        let COUNTER=COUNTER+1
        sleep 1
        echo "${ACTION}ing from $VPN_NAME... ($COUNTER)"
        STATUS=$(networksetup -showpppoestatus "$VPN_NAME")
      done
    fi
echo "${ACTION}ed" 

networksetup -listallnetworkservices
networksetup -showpppoestatus "Tubi SF Office (Beijing PoP)"
# 
}

vpn() {
  bash ~/.bash_scripts/vpn.sh connect
}
vpnoff() {
  bash ~/.bash_scripts/vpn.sh disconnect
}

exec "${@}"
