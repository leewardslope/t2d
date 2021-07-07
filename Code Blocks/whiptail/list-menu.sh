#!/bin/bash

# whiptail --title "<menu title>" --menu "<text to show>" <height> <width> <menu height> [ <tag> <item> ] . . 
CHOICE=$(
whiptail --notags --title "Menu Title" --menu "Press Enter to Choose your option" 50 60 2 \
    "funSBS" "=> option 1"   \
    "funADV" "=> option 2" 3>&2 2>&1 1>&3	
)
exitstatus=$?
if [ $exitstatus = 0 ]; then
    $CHOICE
else
    echo "You chose Cancel."
    exit
fi

# Menu with loop and case fucntionality
#! /bin/bash
while [ 1 ]
do
CHOICE=$(
whiptail --title "Operative Systems" --menu "Make your choice" 15 60 9 \
	"1)" "The name of this script."   \
	"2)" "Time since last boot." \
    "9)" "End script"  3>&2 2>&1 1>&3	
)

result=$(whoami)
case $CHOICE in
	"1)")
		result="I am $result, the name of the script is start"
	;;
	
    "2)")
        result="option 2"
	    echo "this is ${result}"
	;;

	"9)") exit
    ;;
esac
whiptail --msgbox "$result" 10 60
done