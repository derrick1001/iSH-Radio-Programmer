#!/bin/sh
BLUE="\e[1;34m"
NC="\e[0m"
RED="\e[1;31m"
echo -e $BLUE"Testing radio connectivity..."$NC

# Use ping to test radio connectivity
ping -c 5 192.168.1.1 > /dev/null

# Evaluate exit code to determine if ping was successful
if [ "$(echo $?)" -eq 0 ]; then
    echo
    echo -e $BLUE"Radio connection is good."$NC
else
    echo
    echo -e $RED"No connection to radio, check wireless connectivity and cabling and try again."$NC
fi
