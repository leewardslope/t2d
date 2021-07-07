#! /bin/bash

if [ "$(whoami)" == "root" ] ; then
    echo "${YELLOW}Nice you are running the script as root!${END}"
else
    echo "${RED}Please! Run the script with root access${END}, without root access I cannot create plugins in Dokku"
    exit
fi