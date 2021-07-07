#! /bin/bash

IP="$(ifconfig | grep broadcast | awk '{print $2}')"
OS=$( $(compgen -G "/etc/*release" > /dev/null) && cat /etc/*release | grep ^NAME | tr -d 'NAME="' || echo "${OSTYPE//[0-9.]/}")
