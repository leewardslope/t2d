#! /bin/bash

# This script will automate the process of downloading other reqiurired scripts and needs.

# Using tput will eliminate the usage of "-e" in echo, and can be used anywhere
RED="$(tput setaf 1)" # ${RED}
GREEN="$(tput setaf 2)" # ${GREEN}
YELLOW="$(tput setaf 3)" # ${YELLOW}
BLUE="$(tput setaf 6)" # ${BLUE}
END="$(tput setaf 7)" # ${END}

function select_option {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}

function select_opt {
    select_option "$@" 1>&2
    local result=$?
    echo $result
    return $result
}


# array=("Manual")
clear
echo "${YELLOW}Do you have dokku in your system/VPS?${END}"
options=("${BLUE}Yes${END}: Skip dokku installation" "${BLUE} No${END}: Install Dokku(Don't use this to Update dokku)" "${array[@]}") # join arrays to add some variable array
case `select_opt "${options[@]}"` in
    0) echo "Skipping dokku installation";;
    1)
        echo "${YELLOW}Downloading Dokku from its Official Repository${END}"
        wget https://raw.githubusercontent.com/dokku/dokku/v0.24.10/bootstrap.sh
        wait
        sudo DOKKU_TAG=v0.24.10 bash bootstrap.sh &
        process_id=$!
        wait $process_id
        echo "Exit status: $?";
        echo "${RED}Before continuing forward, verify Dokku installation by visiting your IP address in your local machine browser${END}";;
    *) echo "selected ${options[$?]}";;
esac

echo "${YELLOW}Download new script and save a copy of your old script?${END}"
options=("${BLUE}YES${END}: Download the Updated Version" "${BLUE} NO${END}: Continue the with Old version" "${array[@]}") # join arrays to add some variable array
case `select_opt "${options[@]}"` in
    0) 
    echo "you choose to download new script"
    FILE=easydokku.sh
    if [ -f "$FILE" ]; then
        echo "$FILE exists => saving it in old-easydokku.sh"
        sudo cp easydokku.sh old-easydokku.sh
        wait 
        echo "updating to new file"
        sudo rm -r easydokku.sh
        wget https://raw.githubusercontent.com/akhil-naidu/t2d/master/easydokku.sh
        wait
        echo "Downloaded New file"
    else 
        echo "$FILE does not exist."
        echo "Dowloading the latest file"
        wget https://raw.githubusercontent.com/akhil-naidu/t2d/master/easydokku.sh
        wait
    fi;;  
    1) 
    FILE=easydokku.sh
    if [ -f "$FILE" ]; then
        echo "$FILE exists => using easydokku.sh"
        sudo chmod +x easydokku.sh
    else 
        echo "$FILE does not exist."
        echo "Dowloading the latest file"
        wget https://raw.githubusercontent.com/akhil-naidu/t2d/master/easydokku.sh
        wait
        sudo chmod +x easydokku.sh
    fi;;
    *) echo "selected ${options[$?]}";;
esac

chmod +x easydokku.sh
./easydokku.sh