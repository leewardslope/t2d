#! /bin/bash

# Using tput will eliminate the usage of "-e" in echo, and can be used anywhere

RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 123)"
ENDCOLOR="$(tput setaf 7)"

echo "This is ${GREEN}Green ${ENDCOLOR}Color"
echo "This is ${RED}Red ${ENDCOLOR}Color"
echo "This is ${YELLOW}Yellow ${ENDCOLOR}Color"
echo "This is ${BLUE}Blue ${ENDCOLOR}Color"
