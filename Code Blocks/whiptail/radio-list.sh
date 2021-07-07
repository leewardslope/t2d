#! /bin/bash

# Among all the options can take only one input.
# Single correct answer.

DISTROS=$(whiptail --title "Test Radio Dialog" --radiolist "What is the Linux distro of your choice?" 15 60 4 \
"debian" "Venerable Debian" ON \ 
"ubuntu" "Popular Ubuntu" OFF \
"centos" "Stable CentOS" OFF \
"mint" "Rising Star Mint" OFF 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "The chosen distro is:" $DISTROS
else
    echo "You chose Cancel."
fi
