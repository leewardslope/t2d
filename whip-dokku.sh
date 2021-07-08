#! /bin/bash

# This script is used to configure the essentials of t2d and install insatll Forem(for now)
## 1 => Check whether the program/application, "Whiptails" exists or not.
## 2 => Making sure that the script is runing with root permissions.
## 3 => Update and Upgrade the VPS.
## 4 => Check whether the program/application, "Dokku" was Installed or not.
## 5 => Upgrading dokku to the latest version.
## 6 => Downloading the latest whip-dokku.sh or easydokku.sh and placing in users VPS.
## 7 => A small message about the script, to notify issues to the user.
## 8 => Allowing the user to choose, "How they want to use t2d?"(Manual/Automatic).
## 9 => Automatic Script Menu
## 10 => Manual Script Menu

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
function funIntro() #Added Color
{
    cf=$1
    carry=$2
    iam="funIntro"
    : '
    # Commenting Intro as I believe it is not necessary! Will open this if I want to give any notification.

    whiptail --title "A small Notification" --msgbox "Presently this script offers Two Important Fucntions.\n
    1. Automatic (Step by Step Insatllation)
    2. Manual (Advanced)\n=> Advanced/Manual version is a TUI-CLI version for Dokku\n=> The Automatic script is written keeping beginners in mind,\n" 20 70
    whiptail --title "A small Notification" --msgbox "Every Automatic Script works like an Q & A session.\n
    1. At the start of Automatic script you can see a prompt of prerequisites.\n
    2. Assuring that you know all prerequsites will make it easy to install.\n" 20 70
    wait
    '
    funMainmenu $iam $carry
}

# Main Menu
## Here user will can create a new app or update his existing app.
function funMainmenu()
{
    cf=$1
    carry=$2
    iam=funMainmenu
    CHOICE=$(
    whiptail --notags --title "Choose your Setup" --menu "Press Enter to confirm your choice" 10 60 2 \
        "funSetup" " Create a New App "   \
        "funUpdatemenu" " Update Existing App " 3>&2 2>&1 1>&3	
    )
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        $CHOICE $iam $carry
    else
        echo "You chose Cancel."
        exit
    fi
}

# Update Menu
function funUpdatemenu()
{
    cf=$1
    carry=$2
    iam=funUpdatemenu
    echo "$(dokku apps:list | grep -v "==")" > test.tmp
    INPUT="test.tmp"
    COUNT=$(grep "" -c $INPUT)
    if [[ $COUNT -eq 1 ]]
    then
        APP=$(cat $INPUT)
        funUpdateapp $iam $carry
    else
        : ' #This is used to read like by line, working.
        while IFS= read -r line
        do
        echo "$line"
        done < "$INPUT"
        rm -r test.tmp

        # I can also use For loop
        for OUTPUT in $(cat test.tmp)
        do
            echo $OUTPUT
            sleep 1
        done
        '
        APP=$(whiptail --title "Enter the Name of your App" --inputbox "Here is a list of your Existings Apps:\n$(cat -n test.tmp)" 15 60 3>&1 1>&2 2>&3)
        exitstatus=$?
        if [ $exitstatus = 0 ]; then
            echo "Your Choosen App:" $APP
            for OUTPUT in $(cat test.tmp)
            do
                if [[ "$OUTPUT" == "$APP" ]];
                then
                    funUpdateapp $iam $carry
                    break
                else
                    echo "Continuing the loop to check other values"
                fi
            done
            whiptail --title "Error" --msgbox "You might have enetred a wrong APP name; Choose Ok to re-enter/continue." 10 60
            funUpdatemenu
        else
            echo "You Chose to Cancel"
        fi
    fi
}
#Update App
## Here user can update his existing app, it can be any app, that is installed in Dokku
function funUpdateapp()
{
    cf=$1
    carry=$2
    iam=funUpdateapp
    # Check if any apps exists and pop a screen to choose the app he want to update
    # If only one app exists try to automate this step.
    # Once the app is selected he can choose another particular section
        # Change Name
            # Give Warning for not to change
        # Update ENV variables
        # Update App
        # Change Domain Name
        # Add a New Buildpack
        # Add a New Plugin
        # Other
    while [ 1 ]
    do
    CHOICE=$(
    whiptail --title "Updating the App: $APP" --menu "Choose the section you want to update" 20 60 6 \
        "1)" "Add/Update ENV Varibales."   \
        "2)" "Update to the Latest Version." \
        "3)" "Change Your Domain Name" \
        "4)" "Add a New Plugin" \
        "5)" "Add a New Buildpack" \
        "9)" "End script"  3>&2 2>&1 1>&3	
    )

    result=$(whoami)
    case $CHOICE in
        "1)")
            funENV $iam $carry
            wait
            result="Let me know, if you find any errors or need updates to the script"
        ;;
        
        "2)")
            if [[ "$APP" == nforem ]];
            then
                dokku git:sync --build nforem https://github.com/akhil-naidu/forem.git
                wait
                result="Let me know, if you find any errors or need updates to the script"
            else
                result="Coming Soon"
            fi
        ;;

        "3)")
            result="Coming Soon"
        ;;

        "4)")
            result="Coming Soon"
        ;;

        "5)")
            result="Coming Soon"
        ;;
        "9)") 
        echo "Going to delete this now" >> test.tmp #Prevents error, if the file doesnot exists
        rm -r test.tmp
        exit
        ;;
    esac
    whiptail --msgbox "$result" 10 60
    done
}

# Setup Menu
## user will get option to choose, "Advanced Setup" or "Step by Step setup"
## Radio List of two options, can choose only one
function funSetup()
{
    cf=$1
    carry=$2
    iam=funSetup
    CHOICE=$(
    whiptail --notags --title "Choose your Setup" --menu "Press Enter to confirm your choice" 10 60 2 \
        "funSBS" " Step by Step Setup "   \
        "funAdv" " Advanced Setup " 3>&2 2>&1 1>&3	
    )
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        $CHOICE $iam $carry
    else
        echo "You chose Cancel."
        exit
    fi
}

# Advanced Setup
## Will be updated once we finish configuring all "Step by Step" setups
function funAdv()
{
    cf=$1
    carry=0
    clear
    iam=funAdv
    CHOICE=$(
    whiptail --notags --title "Advanced/Manual Setup" --menu "Press Enter to confirm your choice" 15 60 6 \
        "funApps" " Apps " \
        "funPlugins" " Plugins " \
        "funDatabase" " Database " \
        "funBuildpacks" " Buildpacks " \
        "funOthers" " Others " \
        "funSBS" " I prefer Step by Step setup " 3>&2 2>&1 1>&3
    )
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        echo "your chose $CHOICE"
        whiptail --title "Under Construction" --msgbox "Advanced Setup is under construction. Cick Ok to continue with Step by Step setup" 10 60
        funSBS $iam $carry
    else
        echo "You chose Cancel."
        exit
    fi
}

# Step by Step Setup
## Automatic or Skip to a particular section
## Radio List of two options
function funSBS()
{
    cf=$1
    carry=1
    iam=funSBS
    CHOICE=$(
    whiptail --notags --title "Automatic Setup" --menu "Press Enter to confirm your choice" 15 60 6 \
        "funForem" " Forem " \
        "funWordpress" " Wordpress " \
        "funGhost" " Ghost " \
        "funOpenVPN" " OpenVPN " \
        "funCommento" " Commento " \
        "funENV" " Configure ENV Varibales for an Existing App" 3>&2 2>&1 1>&3
    )
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        # $CHOICE $iam $carry
        if [[ "$CHOICE" == "funForem" ]];
        then
            $CHOICE $iam $carry
        else
            whiptail --title "Under Construction" --msgbox " Choose Ok to re-visit App Selection Menu." 10 60
            funSBS $iam $carry
        fi
    else
        echo "You chose Cancel."
        exit
    fi
}

# Skip to a Particular Section
## Will be configured once all the Automatic Configurations are done.
## Around 5 fucntions
function funENV()
{
    cf=$1
    carry=$2
    iam=funENV

    while true; do
        read -r -p "${YELLOW}    Do you wish to manually add a new ENV varibale?${END} (Y/N): " answer
        case $answer in
            [Yy]* )
                    read -r -p "${GREEN}    Name of ENV Varibale:${END} " ENV 
                    read -r -p "${GREEN}    Value of $ENV =${END} " ENV_VALUE
                    dokku config:set nforem --no-restart $ENV="$ENV_VALUE"
                    wait
                    echo "$ENV=$ENV_VALUE" ;;
            [Nn]* )
                echo "${YELLOW}Updating Changes to the app before exiting${END}"
                dokku ps:restart $APP
                echo "${YELLOW}    I hope you finished adding all your ENV varibales${END}"
                echo "${RED}    Exiting... Manual ENV Varibale Setup${END}"
                $cf $iam $carry
                break;;
            * )
                echo "${RED}Please answer Y or N.${END}";;
        esac
    done
    exit
}

# Automatic
## User will choose his desired platform, for staters we will add only one app Forem.
## Around 5 Apps
## Forem #App 01
function funForem()
{
    # Pre-requisites Message
    cf=$1
    carry=$2
    iam="funForem"
    # This is not required now.

    whiptail --title "Pre-Requisites" --msgbox "In order for you to have a successful Forem Installaton.\n
    1. Point you DNS to the IP address of this server. (A Record)
    2. You need to Fetch few ENV Variables, next screen and
    3. Other ENV variables will be configured by the t2d script." 15 70
    wait
    whiptail --title "Mush Have ENV Variables" --msgbox "Please, do not continue without these ENV varibales:\n
        APP_DOMAIN
        APP_PROTOCOL
        COMMUNITY_NAME
        FOREM_OWNER_SECRET
        HONEYBADGER_API_KEY
        HONEYBADGER_JS_API_KEY" 20 60
    wait
    
    # Create App
    echo "${YELLOW}Creating an app named nforem${END}"
    echo "stopping all previously and automatically created Forems"
    echo "${GREEN}No need to worry if you find something like Error!${END}"
    dokku ps:stop nforem
    wait
    echo "Destroying all previously created Forems except 1"
    echo "${GREEN}No need to worry if you find something like Error!${END}"
    dokku apps:destroy oforem
    wait
    echo "Creating a new nforemENV.txt"
    echo "List of Automatically created ENV variables" >> nforemENV.txt
    echo "Saving one old forem with name oforem"
    echo "${GREEN}No need to worry if you find something like Error!${END}"
    dokku apps:rename nforem oforem
    wait
    echo "Creating our new Forem with name nforem"
    dokku apps:create nforem
    wait

    # Download Plugins
    sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git
    wait
    echo "${YELLOW}Installing Redis Plugin${END}"
    sudo dokku plugin:install https://github.com/dokku/dokku-redis.git
    wait
    echo "${YELLOW}Installing LetsEncrypt Plugin${END}"
    sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
    wait

    # Create and Link Databases
    echo "${YELLOW}Creating Postgresdb${END}"
    dokku postgres:create foremdb
    wait
    echo "${YELLOW}Creating Redisdb${END}"
    dokku redis:create redisdb
    wait
    echo "${YELLOW}Linking Postgresdb${END}"
    dokku postgres:link foremdb nforem
    wait
    echo "${YELLOW}Linking Redisdb${END}"
    dokku redis:link redisdb nforem
    wait
    
    # Download Buildpacks
    echo "${YELLOW}Adding NodeJS BuildPack${END}"
    dokku buildpacks:add nforem https://github.com/heroku/heroku-buildpack-nodejs.git
    wait
    echo "${YELLOW}Adding JEMalloc Buildpack${END}"
    dokku buildpacks:add nforem https://github.com/gaffneyc/heroku-buildpack-jemalloc.git
    wait
    echo "${YELLOW}Adding PGBouncer Buildpack${END}"
    dokku buildpacks:add nforem https://github.com/heroku/heroku-buildpack-pgbouncer.git
    wait
    echo "${YELLOW}Adding Ruby Buildpack${END}"
    dokku buildpacks:add nforem https://github.com/heroku/heroku-buildpack-ruby.git
    wait
    
    # Optimising Forem
    echo "${YELLOW}Scaling${END}"
    dokku ps:scale nforem web=1 sidekiq_worker=1
    wait
    echo "${YELLOW}Limiting Webworker Memory to 512M${END}"
    dokku resource:limit --memory 512m --process-type web nforem
    wait
    echo "${YELLOW}Limiting Sidekiq Memory to 512M${END}"
    dokku resource:limit --memory 512m --process-type sidekiq_worker nforem
    wait
    echo "${YELLOW}Setting up Optimisation ENV Variables${END}"
    dokku config:set nforem --no-restart MALLOC_ARENA_MAX=2 JEMALLOC_ENABLED=true WEB_CONCURRENCY=2 RUBY_GC_HEAP_GROWTH_FACTOR=1.03 PGBOUNCER_PREPARED_STATEMENTS=false DATABASE_POOL_SIZE=5 RAILS_MAX_THREADS=5 
    wait
    echo "${YELLOW}Making Forem Production Ready...${END}"
    dokku config:set nforem --no-restart NODE_ENV=production RACK_ENV=production RACK_ENV=production SECRET_KEY_BASE=63e667bd35d7f7045e00de11cf9e115e67a560fac03a6be056c3e4e07bd6b7c974bee249c29abd794ab18c9bf661bce861945dafa31275f409ca0a82a3cae0ab
    wait
    echo "${YELLOW}Initializing git${END}"
    dokku git:initialize nforem
    wait

    # Add ENV Variables
    echo "${YELLOW}Make sure every thing is correct${END}"
    #for ENV in APP_DOMAIN APP_PROTOCOL COMMUNITY_NAME FOREM_OWNER_SECRET HONEYBADGER_API_KEY HONEYBADGER_JS_API_KEY AWS_ID AWS_SECRET AWS_BUCKET_NAME AWS_UPLOAD_REGION
    for ENV in APP_DOMAIN APP_PROTOCOL COMMUNITY_NAME FOREM_OWNER_SECRET
    do
        ENV_VALUE=$(whiptail --title "Adding ENV Variables" --inputbox "$ENV:" 10 60   3>&1 1>&2 2>&3)
        exitstatus=$?
        if [ $exitstatus = 0 ]; then
            dokku config:set nforem --no-restart $ENV="$ENV_VALUE"
            wait
        else
            echo "${RED}You chose Cancel${END}"
            exit
        fi       
    done


    # Adding SSL
    DOMAIN=$(whiptail --title "SSL Configuration" --inputbox "Domain Name:" 10 60 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        dokku domains:set nforem $DOMAIN
        wait
    else
        echo "${RED}You chose Cancel${END}"
        exit
    fi 
    EMAIL=$(whiptail --title "SSL Configuration" --inputbox "Email-ID:" 10 60 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        dokku config:set nforem DOKKU_LETSENCRYPT_EMAIL=$EMAIL
        wait
    else
        echo "${RED}You chose Cancel${END}"
        exit
    fi 
    echo "${YELLOW}Assigning a Free SSL Certificate${END}"
    dokku letsencrypt:enable nforem 
    wait

    # Clone repository and Build Forem
    dokku git:allow-host github.com
    wait
    dokku git:set nforem deploy-branch main
    wait
    dokku git:sync --build nforem https://github.com/akhil-naidu/forem.git
    wait 
    echo "${GREEN}There you go :), Leave a like if you successfully configured your Forem${END}" 
}

## Ghost #App 02
function funGhost()
{
    cf=$1
    carry=$2
    iam=funGhost
    echo "This is Ghost"
    # Pre-requisites Message

    # Create App

    # Download Plugins

    # Create and Link Databases

    # Download Buildpacks

    # Optimising Forem

    # Add ENV Variables

    # Adding SSL

    # Clone repository and Build Forem
}


# Download the respective script and Jump to installing that, may be whip-forem.sh
## Installing Forem as my starting App.
## Able to finish such a complex app, will give all the necessary blocks to complete any other project
## Step up Step Process, From here, things will be more focused on Automation
function funCheck()
{
    # Checking if whiptail is available or not
    if which whiptail >/dev/null; then
        echo "${GREEN}whiptail exists${END}"
        # Continue the script
    else
        echo "${RED}whiptail does not exist${END}"
        echo "Install whiptail and re-run the script, your OS is ${OS}"
        exit
        # As I already know the OS, I can also automate this process, but will save it for later.
        # This is just a matter of finiding all the possible OS people might use and writing a if statement.
    fi

    #Check root and if not root take permissions
    ## It is always better to do this.
    ## We will not face any further issues, during any sort of compulsory sudo commands; like the case for installing plugins in Dokku or Giving permissions to our scripts
    if [ "$(whoami)" == "root" ] ; then
        echo "${YELLOW}Nice you are running the script as root!${END}"
    else
        echo "${RED}Please! Run the script with root access${END}, without root access I cannot create plugins in Dokku"
        exit
    fi

    # Updating and Upgrading system
    ## Staying up to date is always good
    if (whiptail --title "Update and Upgrade System " --yes-button "Yes" --no-button "Skip"  --yesno "Do you wish to Update packges and Upgrade your system?" 10 60) then
        echo "You chose to update your system"
        # Update and skip to next step
        echo "${YELLOW}Updating System${END}"
        sudo dpkg --configure -a
        sudo apt -y --purge autoremove
        sudo apt install -f
        sudo apt -y update
        wait
        echo "${YELLOW}Upgrading System${END}"
        sudo apt -y upgrade
        sudo apt -y autoclean
        sudo apt -y --purge autoremove &
        process_id=$!
        wait $process_id
        echo "Exit status: $?"
    else
        echo "${YELLOW}You chose to skip.${END}"
        # Should skip to next step
    fi

    # Confirming the existance of Dokku
    ## If exists, promt for update
    ## If not exits Let him download.
    if which dokku >/dev/null; then
        echo "${GREEN}Dokku Exists${END}"
        DOKKU_VERSION="$(dokku -v | awk '{print $3}')"
        if [[ "$DOKKU_VERSION" == "0.24.10" ]];
        then
            echo "${YELLOW}Dokku Version: ${GREEN}0.24.10${END} => Skipping Dokku Update promt"
        else
            # Promt for update
            if (whiptail --title "Updating Dokku to Latest Version" --yes-button "Update" --no-button "Skip"  --yesno "Latest Dokku Version: 0.24.10\nInstalled Dokku Version: $DOKKU_VERSION" 10 60) then
                echo "${YELLOW}You chose Update.${END}"
                # Update Dokku
                echo "${YELLOW}Upgrading Dokku${END}"
                sudo apt-get -y update -qq
                wait
                sudo apt-get -qq -y --no-install-recommends install dokku herokuish sshcommand plugn gliderlabs-sigil dokku-update dokku-event-listener
                wait
                sudo apt -y upgrade &
                process_id=$!
                wait $process_id
                echo "Exit status: $?"
                echo "${YELLOW}Now you have the latest Version of Dokku${END}"
                # Dokku Updated
            else
                echo "${Yellow}You chose to skip dokku updates.${END}"
                # Dokku Update skipped
            fi
        fi
    else
        echo "${RED}Dokku does not exist${END}"
        # Show messagebox and make it mandatory to download and install dokku
        whiptail --title "Unable to Detect Dokku" --msgbox "If you want to insatll your app using t2d, it is madatory to install Dokku. So, I would like to install Dokku on behalf of you." 10 60
        wait
        echo "${YELLOW}Downloading Dokku from its Official Repository${END}"
        wget https://raw.githubusercontent.com/dokku/dokku/v0.24.10/bootstrap.sh
        wait
        sudo DOKKU_TAG=v0.24.10 bash bootstrap.sh &
        process_id=$!
        wait $process_id
        echo "Exit status: $?"
        whiptail --title "Confirm Dokku Installation" --msgbox "Before continuing forward, verify Dokku installation by visiting your IP address in your browser.\n\nOne among these IP adresses is your Public IP Address:\n${IP}" 20 60
    fi

    # Run the main dokku, i.e., whip-dokku
    ## Might look into other alternatives
    ## Jump to whip-dokku
    ## Download wget-dokku and run it
    funIntro
}
funCheck