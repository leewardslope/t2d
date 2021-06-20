#! /bin/bash

# Using tput will eliminate the usage of "-e" in echo, and can be used anywhere
RED="$(tput setaf 1)" # ${RED}
GREEN="$(tput setaf 2)" # ${GREEN}
YELLOW="$(tput setaf 3)" # ${YELLOW}
BLUE="$(tput setaf 123)" # ${BLUE}
END="$(tput setaf 7)" # ${END}

function funForem()
{
    cf=$1
    carry=$2
    iam=funForem
    echo "${YELLOW}This is Forem Automatic Setup${END}"
    echo ""
    while true; do
        read -r -p "${BLUE}Do you wish to Update the System?${END} (Y/N): " answer
        case $answer in
            [Yy]* )
                echo "${YELLOW}Updating System${END}"
                sudo apt -y update
                wait
                echo "${YELLOW}Upgrading System${END}"
                sudo apt -y upgrade &
                process_id=$!
                wait $process_id
                echo "Exit status: $?"; 
                break;;
            [Nn]* ) 
                break;;
            * ) 
                echo "${RED}Please answer Y or N.${END}";;
        esac
    done
    
    while true; do
        read -r -p "${BLUE}Do you wish to Update the Dokku?${END} (Y/N): " answer
        case $answer in
            [Yy]* )
                echo "${YELLOW}Upgrading Dokku${END}"
                sudo apt-get -y update -qq
                wait
                sudo apt-get -qq -y --no-install-recommends install dokku herokuish sshcommand plugn gliderlabs-sigil dokku-update dokku-event-listener
                wait
                sudo apt -y upgrade &
                process_id=$!
                wait $process_id
                echo "Exit status: $?"; 
                break;;
            [Nn]* )
                break;;
            * )
                echo "${RED}Please answer Y or N.${END}";;
        esac
    done
    
    while true; do
        read -r -p "${BLUE}Do you wish create a New App?${END} (Y/N): " answer
        case $answer in
            [Yy]* )
                echo "${YELLOW}Creating an app named nforem${END}"
                echo "stopping all previously automatically created Forems"
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
                echo ""; 
                break;;
            [Nn]* )
                break;;
            * )
                echo "${RED}Please answer Y or N.${END}";;
        esac
    done
    
    while true; do
        read -r -p "${BLUE}Do you wish to Add Necessary Plugins?${END} (Y/N): " answer
        case $answer in
            [Yy]* )
                echo "${YELLOW}Installing Postgress Plugin${END}"
                sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git
                wait
                echo "${YELLOW}Installing Redis Plugin${END}"
                sudo dokku plugin:install https://github.com/dokku/dokku-redis.git
                wait
                echo "${YELLOW}Installing LetsEncrypt Plugin${END}"
                sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git &
                process_id=$!
                wait $process_id
                echo "Exit status: $?"; 
                break;;
            [Nn]* )
                break;;
            * )
                echo "${RED}Please answer Y or N.${END}";;
        esac
    done
    
    while true; do
        read -r -p "${BLUE}Do you wish to create New Databases?${END} (Y/N): " answer
        case $answer in
            [Yy]* )
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
                dokku redis:link redisdb nforem &
                process_id=$!
                wait $process_id
                echo "Exit status: $?"; 
                break;;
            [Nn]* )
                break;;
            * )
                echo "${RED}Please answer Y or N.${END}";;
        esac
    done
    
    while true; do
        read -r -p "${BLUE}Do you wish to Add necessary Buildpacks?${END} (Y/N): " answer
        case $answer in
            [Yy]* )
                echo "${YELLOW}Adding NodeJS BuildPack${END}"
                dokku buildpacks:add nforem https://github.com/heroku/heroku-buildpack-nodejs.git
                wait
                echo "${YELLOW}Adding JEMalloc Buildpack${END}"
                dokku buildpacks:add nforem https://github.com/gaffneyc/heroku-buildpack-jemalloc
                wait
                echo "${YELLOW}Adding PGBouncer Buildpack${END}"
                dokku buildpacks:add nforem https://github.com/heroku/heroku-buildpack-pgbouncer.git
                wait
                echo "${YELLOW}Adding Ruby Buildpack${END}"
                dokku buildpacks:add nforem https://github.com/heroku/heroku-buildpack-ruby.git
                process_id=$!n
                wait $process_id
                echo "Exit status: $?"; 
                break;;
            [Nn]* )
                break;;
            * )
                echo "${RED}Please answer Y or N.${END}";;
        esac
    done
    
    while true; do
        read -r -p "${BLUE}Do you wish to Optimise your Forem?${END} (Y/N): " answer
        case $answer in
            [Yy]* )
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
                process_id=$!
                wait $process_id
                echo "Exit status: $?"; 
                break;;
            [Nn]* )
                break;;
            * )
                echo "${RED}Please answer Y or N.${END}";;
        esac
    done
    
    while true; do
        echo "Y => Yes, N => NO, M => Manual"
        read -r -p "${BLUE}Do you wish Add/Update ENV Variables?${END} (Y/N/M): " answer
        case $answer in
            [Yy]* )
                echo "${YELLOW}Make sure every thing is correct${END}"
                for ENV in APP_DOMAIN APP_PROTOCOL COMMUNITY_NAME FOREM_OWNER_SECRET HONEYBADGER_API_KEY HONEYBADGER_JS_API_KEY AWS_ID AWS_SECRET AWS_BUCKET_NAME AWS_UPLOAD_REGION
                do
                    read -r -p "$ENV = " ENV_VALUE
                    dokku config:set nforem --no-restart $ENV=$ENV_VALUE
                    wait
                    echo "$ENV=$ENV_VALUE" >> nforemENV.txt
                done
                echo "";
                break;;
            [Nn]* )
                break;;
            [Mm]* )
                echo "Will Be Updated";
                # I'm not breaking the loop; because if someone want to check this option and as it is not updated he might need to start the entire installation process
            * )
                echo "${RED}Please answer Y or N or M.${END}";;
        esac
    done
    
    while true; do
        read -r -p "${BLUE}Do you wish to add SSL?${END} (Y/N): " answer
        case $answer in
            [Yy]* )
                echo "${YELLOW}Let's Encrypt Need to access your ${RED}Domain${END} and ${RED}Email${END}, so provide them for free SSL"
                sleep 4
                read -r -p "${BLUE}Domain Name:${END} " DOMAIN
                read -r -p "${BLUE}Email-ID: ${END}" EMAIL
                echo ""
                echo "${YELLOW}Assigning a Free SSL Certificate${END}"
                dokku domains:set nforem $DOMAIN
                wait
                dokku config:set nforem DOKKU_LETSENCRYPT_EMAIL=$EMAIL
                wait
                dokku letsencrypt:enable nforem &
                process_id=$!
                wait $process_id
                echo "Exit status: $?"; 
                break;;
            [Nn]* )
                break;;
            * )
                echo "${RED}Please answer Y or N.${END}";;
        esac
    done

    while true; do
        read -r -p "${BLUE}Clone Repository and Build Forem:${END}(Y/N) " answer
        case $answer in
            [Yy]* )
                dokku git:allow-host github.com
                wait
                dokku git:set nforem deploy-branch main
                wait
                dokku git:sync --build nforem https://github.com/akhil-naidu/forem.git &
                process_id=$!
                wait $process_id
                echo "Exit status: $?";
                echo "${GREEN}There you go :), Leave a like if you successfully configured your Forem${END}" 
                exit;;
            [Nn]* )
                exit;;
            * )
                echo "${RED}Please answer Y or N.${END}";;
        esac
    done
}

funForem