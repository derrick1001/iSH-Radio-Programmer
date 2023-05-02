#!/bin/sh

# RB v7 usb mount point is usb1-part1/ for hexS device

# Some variables to color the output
NC="\e[0m"
RED="\e[1;31m"
GREEN="\e[1;32m"
BLUE="\e[1;34m"
MAGENTA="\e[1;38;5;213m"
PADDING='---------------------------------------------------'

# Menu return function, may use at later date
#return_func () {
#    echo -n "Return to menu?: " ; read choice
#    if [ $choice -eq "y" ]; then
#        echo "$GREEN$PADDING$NC"
#        PTP850_func
#    else
#        exit 0
#    fi
#}

# Progress bar for 820 reboot
progress_820_func () {

    sleep 1
    echo -ne $MAGENTA'==                           ['$GREEN'0%'$MAGENTA']\r' # 29 spaces
    sleep 17
    echo -ne '===                          ['$GREEN'10%'$MAGENTA']\r'
    sleep 17
    echo -ne '======                       ['$GREEN'15%'$MAGENTA']\r'
    sleep 17
    echo -ne '========                     ['$GREEN'20%'$MAGENTA']\r'
    sleep 17
    echo -ne '==========                    ['$GREEN'25%'$MAGENTA']\r'
    sleep 52
    echo -ne '==============               ['$GREEN'40%'$MAGENTA']\r'
    sleep 52
    echo -ne '=====================        ['$GREEN'60%'$MAGENTA']\r'
    sleep 52
    echo -ne '=========================    ['$GREEN'80%'$MAGENTA']\r'
    sleep 52
    echo -e '==============================['$GREEN'100%'$MAGENTA']'$NC
    sleep 3
}

# Progress bar for 850 reboot
progress_850_programming_func () {

    sleep 1
    echo -ne $MAGENTA'==                           ['$GREEN'0%'$MAGENTA']\r' # 29 spaces
    sleep 12
    echo -ne '======                       ['$GREEN'20%'$MAGENTA']\r'
    sleep 12
    echo -ne '==============               ['$GREEN'40%'$MAGENTA']\r'
    sleep 12
    echo -ne '=====================        ['$GREEN'60%'$MAGENTA']\r'
    sleep 12
    echo -ne '=========================    ['$GREEN'80%'$MAGENTA']\r'
    sleep 12
    echo -e '==============================['$GREEN'100%'$MAGENTA']'$NC
    sleep 3
}
progress_850_func () {

    sleep 1
    echo -ne $MAGENTA'==                           ['$GREEN'0%'$MAGENTA']\r' # 29 spaces
    sleep 13
    echo -ne '===                          ['$GREEN'10%'$MAGENTA']\r'
    sleep 13
    echo -ne '======                       ['$GREEN'20%'$MAGENTA']\r'
    sleep 26
    echo -ne '==============               ['$GREEN'40%'$MAGENTA']\r'
    sleep 26
    echo -ne '=====================        ['$GREEN'60%'$MAGENTA']\r'
    sleep 26
    echo -ne '=========================    ['$GREEN'80%'$MAGENTA']\r'
    sleep 26
    echo -e '==============================['$GREEN'100%'$MAGENTA']'$NC
    sleep 3
}

product_func () {

    # User menu to get things started
    echo
    echo -e $BLUE"Choose a product from the list to program..."$NC
    echo
        echo -e $GREEN"1)$NC Cambium 820S/C/E"
    echo
        echo -e $GREEN"2)$NC Cambium 850S/C/E"
    echo
    echo -en $BLUE"Choice: "$NC ; read product

    # If statement to decide what product we are working with
    if [ $product -eq 1 ]; then
        echo -e "$GREEN$PADDING$NC"
        PTP820_func
    elif [ $product -eq 2 ]; then
        echo -e "$GREEN$PADDING$NC"
        echo
        echo -e $BLUE"Choose the frequency of the radio..."$NC
        echo
        echo -e $GREEN"1)$NC 11Ghz"
        echo
        echo -e $GREEN"2)$NC 18Ghz"
        echo
        echo -en $BLUE"Choice: "$NC ; read freq 
        if [ $freq -eq 1 ]; then
            echo -e "$GREEN$PADDING$NC"
            PTP850_11_func
        elif [ $freq -eq 2 ]; then
            echo -e "$GREEN$PADDING$NC"
            PTP850_18_func
        else
            echo -e $RED"Select a number from the list..."$NC
            sleep 2
            product_func
        fi
    else
        echo -e $RED"Select a number from the list..."$NC
        sleep 2
        product_func
    fi
}

PTP820_func () {

    # User friendly menu for the user
    echo
    echo -e $BLUE"Choose an option from the list below..."$NC
    echo
        echo -e $GREEN"1)$NC Upload 820 Software"
    echo
        echo -e $GREEN"2)$NC Program 820 HI"
    echo
        echo -e $GREEN"3)$NC Program 820 LO"
    echo
        echo -e $GREEN"4)$NC Change 820 LO IP"
    echo
        echo -e $GREEN"5)$NC Check Radio Connectivity"
    echo
        echo -e $GREEN"6)$NC Get Link Status"
    echo
        echo -e $GREEN"7)$NC Check Software Version"
    echo
        echo -e $GREEN"8)$NC Exit"
    echo
    echo -ne $BLUE"Choice: "$NC ; read answer

    # Case statement for actions based on number selected
    case "$answer" in
        1)
            echo -e "$GREEN$PADDING$NC"
            /bin/sh /root/iSH-scripts/820S-software.sh 192.168.1.15 | telnet 192.168.1.1 
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Done!!"$NC
            sleep 2
            echo -e $BLUE"Rebooting..."$NC
            progress_820_func
            echo -e "$GREEN$PADDING$NC"
            # if statement to check when radio is back
            PTP820_func
            ;;
        2)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Programming radio..."$NC
            /bin/sh /root/iSH-scripts/820S-import-HI-template.sh 192.168.1.15 | telnet 192.168.1.1 > import_820_HI.txt 2>&1 &
            progress_850_programming_func
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Done!!"$NC
            sleep 2
            echo -e $BLUE"Rebooting..."$NC
            progress_820_func
            echo -e "$GREEN$PADDING$NC"
            # if statement to check if radio is back online
            PTP820_func
            ;;
        3)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Programming radio..."$NC
            /bin/sh /root/iSH-scripts/820S-import-LO-template.sh 192.168.1.15 | telnet 192.168.1.1 > import_820_LO.txt 2>&1 &
            progress_850_programming_func
           echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Done!!"$NC
            sleep 2
            echo -e $BLUE"Rebooting..."$NC
            progress_820_func
            echo -e "$GREEN$PADDING$NC"
            # if statement to check if radio is back online
            PTP820_func
            ;;
        4)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Changing radio IP..."$NC
            /bin/sh /root/iSH-scripts/setip.sh | telnet 192.168.1.1 > /dev/null 2>&1
            sleep 8

            # Use ping to test radio connectivity
            ping -c 5 192.168.1.2 > /dev/null 2>&1

            # Evaluate exit code to determine if ping was successful
            if [ "$(echo $?)" -eq 0 ]; then
                echo
                echo -e $BLUE"IP has been changed!!!"$NC
                echo -e "$GREEN$PADDING$NC"
            else
                echo
                echo -e $RED"Something went wrong, try again."$NC
                echo -e "$GREEN$PADDING$NC"
            fi
            sleep 2
            PTP820_func
            ;;
        5)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Testing radio connectivity..."$NC
            
            # Use ping to test radio connectivity
            ping -c 3 192.168.1.1 > /dev/null || ping -c 3 192.168.1.2 > /dev/null 2>&1 
            
            # Evaluate exit code to determine if ping was successful
            if [ "$(echo $?)" -eq 0 ]; then
                echo
                echo -e $BLUE"Radio connection is good."$NC
            else
                echo
                echo -e $RED"No connection to radio, check wireless connectivity and cabling and try again."$NC
            fi

            echo -e "$GREEN$PADDING$NC"
            sleep 4
            PTP820_func
            ;;
        6)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Getting link info..."$NC
            
            # Block to check which radio we are connected to
            ping -c 3 192.168.1.1 > /dev/null
            if [ "$(echo $?)" -eq 0 ]; then
                /bin/sh /root/iSH-scripts/get-820-link-status.sh | telnet 192.168.1.1 > link-status.txt 2>&1
            else
                /bin/sh /root/iSH-scripts/get-820-link-status.sh | telnet 192.168.1.2 > link-status.txt 2>&1
            fi

            sleep 1
            echo -e "$GREEN$PADDING$NC"
            grep 'dBm' link-status.txt | cut -f 5-8 -d " " 
            grep 'MSE' link-status.txt
            echo -e "$GREEN$PADDING$NC"
            grep 'Current' link-status.txt
            echo -e "$GREEN$PADDING$NC"
            sleep 2
            PTP820_func
            ;;
         7)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Getting software version..."$NC

            # Same block from option 6
            ping -c 3 192.168.1.1 > /dev/null
            if [ "$(echo $?)" -eq 0 ]; then
                /bin/sh /root/iSH-scripts/get-software-version.sh | telnet 192.168.1.1 > software-version.txt 2>&1
            else
                /bin/sh /root/iSH-scripts/get-software-version.sh | telnet 192.168.1.2 > software-version.txt 2>&1
            fi

            echo -e "$GREEN$PADDING$NC"
            grep 'version:' software-version.txt 
            echo -e "$GREEN$PADDING$NC"
            sleep 2
            PTP820_func
            ;;   
        8)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Terminating..."$NC
            echo
            sleep 1
            echo -ne $MAGENTA"<('-'<) " ; sleep 1 ; echo -n "(>'-')> " ; sleep 1 ; echo -n "^(' - ')^ " ; sleep 1 ; echo -n "<('-'<) " ; sleep 1 ; echo -e "(>'-')>"$NC
            echo -e "$GREEN$PADDING$NC"
            sleep 1
            exit 0
            ;;

        *)
            echo -e "$GREEN$PADDING$NC"
            echo -e $RED"Pick a number dumbass o_0"$NC
            echo -e "$GREEN$PADDING$NC"
            ;;
    esac
}
PTP850_18_func () {

    # User friendly menu for the user
    echo
    echo -e $BLUE"Choose an option from the list below..."$NC
    echo
        echo -e $GREEN"1)$NC Upload 850_18 Software"
    echo
        echo -e $GREEN"2)$NC Program 850_18 HI"
    echo
        echo -e $GREEN"3)$NC Program 850_18 LO"
    echo
        echo -e $GREEN"4)$NC Change 850_18 LO IP"
    echo
        echo -e $GREEN"5)$NC Check Radio Connectivity"
    echo
        echo -e $GREEN"6)$NC Get Link Status"
    echo
        echo -e $GREEN"7)$NC Check Software Version"
    echo
        echo -e $GREEN"8)$NC Turn Telnet ON"
    echo
        echo -e $GREEN"9)$NC Exit"
    echo
        echo -e $GREEN"10)$NC Back"
    echo
    echo -ne $BLUE"Choice: "$NC ; read answer

    # Case statement for actions based on number selected
    case "$answer" in
        1)
            echo -e "$GREEN$PADDING$NC"
            /bin/sh /root/iSH-scripts/850C-software.sh 192.168.1.15 | telnet 192.168.1.1 
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Done!!"$NC
            sleep 2
            echo -e $BLUE"Rebooting..."$NC
            progress_850_func
            #sleep 130
            echo -e "$GREEN$PADDING$NC"
            # if statement to check when radio is back
            PTP850_18_func
            ;;
        2)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Programming radio..."$NC
            /bin/sh /root/iSH-scripts/850C-import-18Ghz-HI-template.sh 192.168.1.15 | telnet 192.168.1.1 > import_850_18_HI.txt 2>&1 &
            progress_850_programming_func
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Done!!"$NC
            sleep 2
            echo -e $BLUE"Rebooting..."$NC
            progress_850_func
            #sleep 130
            echo -e "$GREEN$PADDING$NC"
            # if statement to check if radio is back online
            PTP850_18_func
            ;;
        3)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Programming radio..."$NC
            /bin/sh /root/iSH-scripts/850C-import-18Ghz-LO-template.sh 192.168.1.15 | telnet 192.168.1.1 > import_850_18_LO.txt 2>&1 &
            progress_850_programming_func
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Done!!"$NC
            sleep 2
            echo -e $BLUE"Rebooting..."$NC
            progress_850_func
            #sleep 130
            echo -e "$GREEN$PADDING$NC"
            # if statement to check if radio is back online
            PTP850_18_func
            ;;
        4)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Changing radio IP..."$NC
            /bin/sh /root/iSH-scripts/setip.sh | telnet 192.168.1.1 > /dev/null 2>&1
            sleep 9
            ping -c 5 192.168.1.2 > /dev/null
            if [ "$(echo $?)" -eq 0 ]; then
                echo
                echo -e $BLUE"IP has been changed!!!"$NC
                echo -e "$GREEN$PADDING$NC"
            else
                echo
                echo -e $RED"Something went wrong, try again."$NC
                echo -e "$GREEN$PADDING$NC"
            fi
            sleep 2
            PTP850_18_func
            ;;
        5)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Testing radio connectivity..."$NC
            
            # Use ping to test radio connectivity
            ping -c 3 192.168.1.1 > /dev/null || ping -c 3 192.168.1.2 > /dev/null
            
            # Evaluate exit code to determine if ping was successful
            if [ "$(echo $?)" -eq 0 ]; then
                echo
                echo -e $BLUE"Radio connection is good."$NC
            else
                echo
                echo -e $RED"No connection to radio, check wireless connectivity and cabling and try again."$NC
            fi

            echo -e "$GREEN$PADDING$NC"
            sleep 4
            PTP850_18_func
            ;;
        6)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Getting link info..."$NC
            
            # Block to check which radio we are connected to
            ping -c 3 192.168.1.1 > /dev/null
            if [ "$(echo $?)" -eq 0 ]; then
                /bin/sh /root/iSH-scripts/get-850-link-status.sh | telnet 192.168.1.1 > link-status.txt 2>&1
            else
                /bin/sh /root/iSH-scripts/get-850-link-status.sh | telnet 192.168.1.2 > link-status.txt 2>&1
            fi

            sleep 1
            echo -e "$GREEN$PADDING$NC"
            grep 'dBm' link-status.txt | cut -f 5-8 -d " "
            grep 'MSE' link-status.txt
            echo -e "$GREEN$PADDING$NC"
            grep 'Current' link-status.txt
            echo -e "$GREEN$PADDING$NC"
            sleep 2
            PTP850_18_func
            ;;
         7)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Getting software version..."$NC

            # Same block from option 6
            ping -c 3 192.168.1.1 > /dev/null
            if [ "$(echo $?)" -eq 0 ]; then
                /bin/sh /root/iSH-scripts/get-software-version.sh | telnet 192.168.1.1 > software-version.txt 2>&1
            else
                /bin/sh /root/iSH-scripts/get-software-version.sh | telnet 192.168.1.2 > software-version.txt 2>&1
            fi

            echo -e "$GREEN$PADDING$NC"
            grep 'version:' software-version.txt 
            echo -e "$GREEN$PADDING$NC"
            sleep 2
            PTP850_18_func
            ;;   
        8)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Enabling Telnet Admin..."$NC
            sleep 2
            /bin/sh /root/iSH-scripts/telneton.sh | ssh admin@192.168.1.1 > /dev/null
            echo -e "$GREEN$PADDING$NC"
            sleep 2
            PTP850_18_func
            ;;
        9)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Terminating..."$NC
            echo
            sleep 1
            echo -ne $MAGENTA"<('-'<) " ; sleep 1 ; echo -n "(>'-')> " ; sleep 1 ; echo -n "^(' - ')^ " ; sleep 1 ; echo -n "<('-'<) " ; sleep 1 ; echo -e "(>'-')>"$NC
            echo -e "$GREEN$PADDING$NC"
            sleep 1
            exit 0
            ;;
        10)
            product_func
            ;;
        *)
            echo -e "$GREEN$PADDING$NC"
            echo -e $RED"Pick a number dumbass o_0"$NC
            echo -e "$GREEN$PADDING$NC"
            PTP850_18_func
            sleep 3
            ;;
    esac
}
PTP850_11_func () {

    # User friendly menu for the user
    echo
    echo -e $BLUE"Choose an option from the list below..."$NC
    echo
        echo -e $GREEN"1)$NC Upload 850_11 Software"
    echo
        echo -e $GREEN"2)$NC Program 850_11 HI"
    echo
        echo -e $GREEN"3)$NC Program 850_11 LO"
    echo
        echo -e $GREEN"4)$NC Change 850_11 LO IP"
    echo
        echo -e $GREEN"5)$NC Check Radio Connectivity"
    echo
        echo -e $GREEN"6)$NC Get Link Status"
    echo
        echo -e $GREEN"7)$NC Check Software Version"
    echo
        echo -e $GREEN"8)$NC Turn Telnet ON"
    echo
        echo -e $GREEN"9)$NC Exit"
    echo
        echo -e $GREEN"10)$NC Back"
    echo
    echo -ne $BLUE"Choice: "$NC ; read answer

    # Case statement for actions based on number selected
    case "$answer" in
        1)
            echo -e "$GREEN$PADDING$NC"
            /bin/sh /root/iSH-scripts/850C-software.sh 192.168.1.15 | telnet 192.168.1.1 
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Done!!"$NC
            sleep 2
            echo -e $BLUE"Rebooting..."$NC
            progress_850_func
            #sleep 130
            echo -e "$GREEN$PADDING$NC"
            # if statement to check when radio is back
            PTP850_11_func
            ;;
        2)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Programming radio..."$NC
            /bin/sh /root/iSH-scripts/850C-import-11Ghz-HI-template.sh 192.168.1.15 | telnet 192.168.1.1 > import_850_HI.txt 2>&1 &
            progress_850_programming_func
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Done!!"$NC
            sleep 2
            echo -e $BLUE"Rebooting..."$NC
            progress_850_func
            #sleep 130
            echo -e "$GREEN$PADDING$NC"
            # if statement to check if radio is back online
            PTP850_11_func
            ;;
        3)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Programming radio..."$NC
            /bin/sh /root/iSH-scripts/850C-import-11Ghz-LO-template.sh 192.168.1.15 | telnet 192.168.1.1 > import_850_LO.txt 2>&1 &
            progress_850_programming_func
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Done!!"$NC
            sleep 2
            echo -e $BLUE"Rebooting..."$NC
            progress_850_func
            #sleep 130
            echo -e "$GREEN$PADDING$NC"
            # if statement to check if radio is back online
            PTP850_11_func
            ;;
        4)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Changing radio IP..."$NC
            /bin/sh /root/iSH-scripts/setip.sh | telnet 192.168.1.1 > /dev/null 2>&1
            sleep 9
            ping -c 5 192.168.1.2 > /dev/null
            if [ "$(echo $?)" -eq 0 ]; then
                echo
                echo -e $BLUE"IP has been changed!!!"$NC
                echo -e "$GREEN$PADDING$NC"
            else
                echo
                echo -e $RED"Something went wrong, try again."$NC
                echo -e "$GREEN$PADDING$NC"
            fi
            sleep 2
            PTP850_11_func
            ;;
        5)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Testing radio connectivity..."$NC
            
            # Use ping to test radio connectivity
            ping -c 3 192.168.1.1 > /dev/null || ping -c 3 192.168.1.2 > /dev/null
            
            # Evaluate exit code to determine if ping was successful
            if [ "$(echo $?)" -eq 0 ]; then
                echo
                echo -e $BLUE"Radio connection is good."$NC
            else
                echo
                echo -e $RED"No connection to radio, check wireless connectivity and cabling and try again."$NC
            fi

            echo -e "$GREEN$PADDING$NC"
            sleep 4
            PTP850_11_func
            ;;
        6)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Getting link info..."$NC
            
            # Block to check which radio we are connected to
            ping -c 3 192.168.1.1 > /dev/null
            if [ "$(echo $?)" -eq 0 ]; then
                /bin/sh /root/iSH-scripts/get-850-link-status.sh | telnet 192.168.1.1 > link-status.txt 2>&1
            else
                /bin/sh /root/iSH-scripts/get-850-link-status.sh | telnet 192.168.1.2 > link-status.txt 2>&1
            fi

            sleep 1
            echo -e "$GREEN$PADDING$NC"
            grep 'dBm' link-status.txt | cut -f 5-8 -d " "
            grep 'MSE' link-status.txt
            echo -e "$GREEN$PADDING$NC"
            grep 'Current' link-status.txt
            echo -e "$GREEN$PADDING$NC"
            sleep 2
            PTP850_11_func
            ;;
         7)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Getting software version..."$NC

            # Same block from option 6
            ping -c 3 192.168.1.1 > /dev/null
            if [ "$(echo $?)" -eq 0 ]; then
                /bin/sh /root/iSH-scripts/get-software-version.sh | telnet 192.168.1.1 > software-version.txt 2>&1
            else
                /bin/sh /root/iSH-scripts/get-software-version.sh | telnet 192.168.1.2 > software-version.txt 2>&1
            fi

            echo -e "$GREEN$PADDING$NC"
            grep 'version:' software-version.txt 
            echo -e "$GREEN$PADDING$NC"
            sleep 2
            PTP850_11_func
            ;;   
        8)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Enabling Telnet Admin..."$NC
            sleep 2
            /bin/sh /root/iSH-scripts/telneton.sh | ssh admin@192.168.1.1 > /dev/null
            echo -e "$GREEN$PADDING$NC"
            sleep 2
            PTP850_11_func
            ;;
        9)
            echo -e "$GREEN$PADDING$NC"
            echo -e $BLUE"Terminating..."$NC
            echo
            sleep 1
            echo -ne $MAGENTA"<('-'<) " ; sleep 1 ; echo -n "(>'-')> " ; sleep 1 ; echo -n "^(' - ')^ " ; sleep 1 ; echo -n "<('-'<) " ; sleep 1 ; echo -e "(>'-')>"$NC
            echo -e "$GREEN$PADDING$NC"
            sleep 1
            exit 0
            ;;
        10)
            product_func
            ;;
        *)
            echo -e "$GREEN$PADDING$NC"
            echo -e $RED"Pick a number dumbass o_0"$NC
            echo -e "$GREEN$PADDING$NC"
            PTP850_11_func
            sleep 3
            ;;
    esac
}
product_func
