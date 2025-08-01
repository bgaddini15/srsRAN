#!/bin/bash

restoreCursor() {
    tput cnorm
}

displayLoadingAnimation() {
    local delay=0.15
    local pid=$!
    sudo tput civis

    echo -n "Stopping 5G Core..."

    while kill -0 $pid 2>/dev/null
    do
        echo -en "\e[3D..."
        sleep $delay
        echo -en "\e[3D\u00B7.."
        sleep $delay
        echo -en "\e[3D.\u00B7."
        sleep $delay
        echo -en "\e[3D..\u00B7"
        sleep $delay
        echo -en "\e[3D..."
        sleep $delay
        echo -en "\e[3D..."
        sleep $delay
        echo -en "\e[3D..."
        sleep $delay
    done

    tput cnorm
}

stopCore() {
    sudo systemctl stop open5gs-mmed
    sudo systemctl stop open5gs-sgwcd
    sudo systemctl stop open5gs-smfd
    sudo systemctl stop open5gs-amfd
    sudo systemctl stop open5gs-sgwud
    sudo systemctl stop open5gs-upfd
    sudo systemctl stop open5gs-hssd
    sudo systemctl stop open5gs-pcrfd
    sudo systemctl stop open5gs-nrfd
    sudo systemctl stop open5gs-scpd
    sudo systemctl stop open5gs-seppd
    sudo systemctl stop open5gs-ausfd
    sudo systemctl stop open5gs-udmd
    sudo systemctl stop open5gs-pcfd
    sudo systemctl stop open5gs-nssfd
    sudo systemctl stop open5gs-bsfd
    sudo systemctl stop open5gs-udrd
    sudo systemctl stop open5gs-webui
}

trap restoreCursor EXIT

stopCore &

displayLoadingAnimation

echo -e "\n\e[32mCore Stopped\e[0m"
