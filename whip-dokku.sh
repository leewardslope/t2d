#! /bin/bash

# This script is used to configure the essentials of t2d.
## 1 => A small message about the script, to notify issues to the user.
## 2 => Allowing the user to choose, "How they want to use t2d?"(Manual/Automatic).
## 3 => Automatic Script Menu
## 4 => Manual Script Menu
## 5 => 
## 6 => 

# Using tput will eliminate the usage of "-e" in echo, and can be used anywhere
## Color Palet
## Should exist in every script
RED="$(tput setaf 1)" # ${RED}
GREEN="$(tput setaf 2)" # ${GREEN}
YELLOW="$(tput setaf 3)" # ${YELLOW}
BLUE="$(tput setaf 123)" # ${BLUE}
END="$(tput setaf 7)" # ${END

# Finding Information about your device
## Basic VPS info
## Should exist in every script
IP="$(ifconfig | grep broadcast | awk '{print $2}')"
OS=$( $(compgen -G "/etc/*release" > /dev/null) && cat /etc/*release | grep ^NAME | tr -d 'NAME="' || echo "${OSTYPE//[0-9.]/}")
# DOKKU_VERSION=

# Introduction
## Here we create a Message Box and will wait for the Reply and will forward to main Setup Menu


# Setup Menu
## user will get option to choose, "Advanced Setup" or "Step by Step setup"
## Radio List of two options, can choose only one


# Advanced Setup
## Will be updated once we finish configuring all "Step by Step" setups


# Step by Step Setup
## Automatic or Skip to a particular section
## Radio List of two options


# Skip to a Particular Section
## Will be configured once all the Automatic Configurations are done.
## Radio list of around five options


# Automatic
## User will choose his desired platform, for staters we will add only one app Forem.
## Radio list of around five options


# Download the respective script and Jump to installing that, may be whip-forem.sh
## Installing Forem as my starting App.
## Able to finish such a complex app, will give all the necessary blocks to complete any other project
## Step up Step Process, From here, things will be more focused on Automation
