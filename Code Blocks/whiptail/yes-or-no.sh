#!/bin/bash

# Options as Yes or No
# whiptail --title "<dialog box title>" --yesno "<text to show>" <height> <width>

if (whiptail --title "Test Yes/No Box" --yesno "Choose between Yes and No." 10 60) then
    echo "You chose Yes. Exit status was $?."
else
    echo "You chose No. Exit status was $?."
fi

# Own Options, to replace yes or no
if (whiptail --title "Test Yes/No Box" --yes-button "Skittles" --no-button "M&M's"  --yesno "Which do you like better?" 10 60) then
    echo "You chose Skittles Exit status was $?."
else
    echo "You chose M&M's. Exit status was $?."
fi