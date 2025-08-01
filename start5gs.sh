#!/bin/bash

restoreCursor() {
    tput cnorm
}

displayLoadingAnimation() {
    local delay=0.15
    local pid=$!
    sudo tput civis

    echo -n "Starting 5G Core..."

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

startCore() {
    sudo systemctl restart open5gs-mmed
    sudo systemctl restart open5gs-sgwcd
    sudo systemctl restart open5gs-smfd
    sudo systemctl restart open5gs-amfd
    sudo systemctl restart open5gs-sgwud
    sudo systemctl restart open5gs-upfd
    sudo systemctl restart open5gs-hssd
    sudo systemctl restart open5gs-pcrfd
    sudo systemctl restart open5gs-nrfd
    sudo systemctl restart open5gs-scpd
    sudo systemctl restart open5gs-seppd
    sudo systemctl restart open5gs-ausfd
    sudo systemctl restart open5gs-udmd
    sudo systemctl restart open5gs-pcfd
    sudo systemctl restart open5gs-nssfd
    sudo systemctl restart open5gs-bsfd
    sudo systemctl restart open5gs-udrd
    sudo systemctl restart open5gs-webui
}

trap restoreCursor EXIT

startCore &

displayLoadingAnimation

echo -e "\n\e[32mCore Started\e[0m"
