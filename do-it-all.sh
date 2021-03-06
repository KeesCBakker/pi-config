#!/bin/bash
# By Kees C. Bakker / KeesTalksTech

# Configures your Pi will all the parts of the 'pi-config' project.
# Tested with RPi1/armv6l and RPi3/armv7l.

# 1st parameter is host name

# Source: https://github.com/KeesCBakker/pi-config/blob/master/do-it-all.sh

# colors
W='\033[1;33m'
G='\033[1;92m'
R='\033[0m' # No Color

echo ""

#set static IP for eth0
echo -e "${W}Setting static IP to eth0.${R}" 
curl -s https://raw.githubusercontent.com/KeesCBakker/pi-config/master/make-my-ip-static.sh | 
bash -s eth0

#set static IP for wlan0
echo -e "${W}Setting static IP to wlan0.${R}" 
curl -s https://raw.githubusercontent.com/KeesCBakker/pi-config/master/make-my-ip-static.sh | 
bash -s wlan0

#set host name - take param 1
HOSTNAME=$1
echo -e "${W}Setting host name.${R}" 
curl -s https://raw.githubusercontent.com/KeesCBakker/pi-config/master/set-host-name.sh | 
bash -s $HOSTNAME

#install node JS
echo -e "${W}Installing latest stable version of NodeJS.${R}" 
curl -s https://raw.githubusercontent.com/KeesCBakker/pi-config/master/install-node.sh | 
bash -s stable
