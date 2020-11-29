#! /bin/bash

POWERED_ON=$(echo show | bluetoothctl | grep "Powered: yes" | wc -c)
CONNECTED=$(echo info | bluetoothctl | grep "Device" | wc -c)

function state() {
    if [[ "$POWERED_ON" -eq "0" ]]
    then
        echo "%{F#555}"
    else
        if [[ "$CONNECTED" -eq "0" ]]
        then
            echo ""
        else
            echo "%{F#44F}"
        fi
    fi
}

function toggle() {
    if [[ $POWERED_ON -eq 0 ]]
    then
        bluetoothctl power on
    else
        bluetoothctl power off
    fi
}

function connect() {
    DEVICES=("$(bluetoothctl paired-devices | cut -d' ' -f2)")

    for DEVICE in "${DEVICES[@]}"
    do
        bluetoothctl connect "$DEVICE"
    done
}

# Polybar calls the script and passes the function name.
$1
