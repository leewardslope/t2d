#!/bin/bash
function random-string() {
        $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
}
random-string

# Can also be used as variable
## RANDOM_STRING="ledokku-$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)"
## echo "${RANDOM_STRING}





