#!/bin/bash

# Multiple correct answer type/ user can choose multiple options.

# whiptail --title "<checklist title>" --checklist "<text to show>" <height> <width> <list height> [ <tag> <item> <status> ] . . .
DISTROS=$(whiptail --title "Test Checklist Dialog" --checklist 
"Choose preferred Linux distros" 15 60 4 
"debian" "Venerable Debian" ON 
"ubuntu" "Popular Ubuntu" OFF 
"centos" "Stable CentOS" ON 
"mint" "Rising Star Mint" OFF 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your favorite distros are:" $DISTROS
else
    echo "You chose Cancel."
fi