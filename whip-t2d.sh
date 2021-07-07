#! /bin/bash

#Check root and if not root take permissions
## It is always better to do this.
## We will not face any further issues, during any sort of compulsory sudo commands; like the case for installing plugins in Dokku or Giving permissions to our scripts
if [ "$(whoami)" == "root" ] ; then
    echo "Nice you are running the script as root!"
else
    echo "Please! run the script with root access, without root access I cannot create plugins in Dokku"
    exit
fi

# Updating and Upgrading system
## Staying up to date is always good
if (whiptail --title "Updating System " --yes-button "Yes" --no-button "Skip"  --yesno "Do you wish to Update the system" 10 60) then
    echo "You chose to update"
    # Update and skip to next step
else
    echo "You chose to skip."
    # Should skip to next step
fi

# Confirming the existance of Dokku
## If exists, promt for update
## If not exits Let him download.
if which dokku >/dev/null; then
    echo "exists"
    # Promt for update
else
    echo "does not exist"
    # Show messagebox and make it mandatory to download and install dokku
fi

# Run the main dokku, i.e., whip-dokku
## Might look into other alternatives
## Jump to whip-dokku
## Download wget-dokku and run it
