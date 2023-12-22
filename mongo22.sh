#!/bin/bash

spinner_pid=

function start_spinner {
    set +m
    echo -n -e "$1         "
    { while : ; do for X in '  •     ' '   •    ' '    •   ' '     •  ' '      • ' '     •  ' '    •   ' '   •    ' '  •     ' ' •      ' ; do echo -en "\b\b\b\b\b\b\b\b$X" ; sleep 0.1 ; done ; done & } 2>/dev/null
    # while :; do for s in / - \\ \|; do printf "\r$s"; sleep .1; done; done
    spinner_pid=$!
}

function stop_spinner {
    { kill -9 $spinner_pid && wait; } 2>/dev/null
    set -m
    echo -en "\033[2K\r"
}

#CLEAR="\e[0m"
#BOLD="\e[1m"

BOLD=$(tput bold)
CLEAR=$(tput sgr0)

trap stop_spinner EXIT

echo -e "This script will install ${BOLD}MongoDB Community${CLEAR} edition on ${BOLD} Ubuntu v22.04 & Up ${CLEAR}"
echo -e "This is a FREE SOFTWARE and comes under no warranty whatsoever"
echo -e "It is advised to run this script with ${BOLD} SUDO privileges ${CLEAR}"
read -n 1 -r -s -p $'PRESS ENTER TO CONTINUE...\n OR CTRL + c TO EXIT THIS SCRIPT...\n'

rm -rf mongoinstall.log || true
touch mongoinstall.log

start_spinner "Performing system update & cleanup"
sudo apt-get autoclean -y >> mongoinstall.log
sudo apt-get clean -y >> mongoinstall.log
sudo apt-get update -y >> mongoinstall.log
sudo apt-get clean -y >> mongoinstall.log
sudo apt-get upgrade -y >> mongoinstall.log
sudo apt-get autoremove -y >> mongoinstall.log
sudo apt-get autoclean -y >> mongoinstall.log
sudo apt-get update -y >> mongoinstall.log
echo -e "\n${BOLD}System updated & cleaned successfully${CLEAR}\n"
stop_spinner

start_spinner "Cleaning existing Mongo installations"
sudo service mongod stop || true
sudo apt-get purge -y mongodb-org* || true
echo -e "\n${BOLD}Removing databases & log files${CLEAR}\n"
sudo rm -rf /var/log/mongodb || true
sudo rm -rf /var/lib/mongod || true
sudo rm -rf /etc/apt/sources.list.d/mongodb* || true
echo -e "\n${BOLD}Removed existing installations${CLEAR}\n"
sudo apt-get update -y
stop_spinner

start_spinner "Installing MongoDB Community Edition"
sudo apt-get update -y >> mongoinstall.log
sudo apt-get install -y gnupg curl
echo -e "\n${BOLD}Importing key file${CLEAR}\n"
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor
echo -e "\n${BOLD}Creating list file${CLEAR}\n"
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
echo -e "\n${BOLD}Reloading package list${CLEAR}\n"
sudo apt-get update -y >> mongoinstall.log
echo -e "\n${BOLD}Installing MongoDB binary${CLEAR}\n"
sudo apt-get install -y mongodb-org
echo -e "\n${BOLD}Starting mongodb service...${CLEAR}\n"
sudo systemctl daemon-reload
sudo systemctl enable mongod
sudo systemctl start mongod
echo -e "\n${BOLD}Verifying status${CLEAR}\n"
sudo systemctl status mongod
echo -e "\n${BOLD}MongoDB installed successfully${CLEAR}\n"
echo -e "\nBegin usage by executing \n\n${BOLD}mongosh${CLEAR} \n\nin terminal\n"
echo -e "Additionally you can install ${BOLD}MongoDB Compass${CLEAR}, an graphical interface for interacting with MongoDB"
read -n 1 -r -s -p $'\nPRESS ENTER TO BEGIN INSTALLING MongoDB Compass OR PRESS Ctrl + c FOR SKIPPING ITS INSTALLATION...\n'
echo -e "\n${BOLD}Downloading binary${CLEAR}\n"
wget https://downloads.mongodb.com/compass/mongodb-compass_1.40.3_amd64.deb
echo -e "\n${BOLD}Beginning installation${CLEAR}\n"
sudo apt-get install -y ./mongodb-compass_1.40.3_amd64.deb
echo -e "\n\nCompass installed successfully, start by executing \n\n${BOLD}mongodb-compass${CLEAR} \n\n"
stop_spinner

