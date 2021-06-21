#! /bin/bash

# Using "tput" will eliminate the usage of "-e" in echo, and can be used anywhere

RED="$(tput setaf 1)" # ${RED}
GREEN="$(tput setaf 2)" # ${GREEN}
YELLOW="$(tput setaf 3)" # ${YELLOW}
BLUE="$(tput setaf 6)" # ${BLUE}
END="$(tput setaf 7)" # ${END}

echo "This is ${GREEN}Green ${END}Color"
echo "This is ${RED}Red ${END}Color"
echo "This is ${YELLOW}Yellow ${END}Color"
echo "This is ${BLUE}Blue ${END}Color"