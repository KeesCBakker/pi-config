#!/bin/bash
# By Kees C. Bakker / KeesTalksTech

# Changes the host name. Adds a line to the hosts file as well.

# Syntax:
# set-host-name.sh - will prompt for the hostname.
# set-host-name.sh {name} - will make the given name the hostname

# Source: https://github.com/KeesCBakker/pi-config/blob/master/set-host-name.sh

# colors
W='\033[1;37m';
G='\033[1;92m';
R='\033[0m' # No Color;

set -e;

HOSTNAME=$1;

if [ -z "$HOSTNAME" ]; then
	HOSTNAME=$(hostname)
	HOSTNAME=$(whiptail --inputbox "\nThe current hostname is $HOSTNAME.\n\nPlease enter the new host name." 13 30 $HOSTNAME --title "New hostname" 3>&1 1>&2 2>&3)
fi

#add to hostnname
#prevents error message
echo -e "127.0.1.1\t$HOSTNAME" | sudo tee --append /etc/hosts > /dev/null;

#set hostname
sudo hostnamectl set-hostname $HOSTNAME;

#remove all 127.0.1.1 addresses
cat /etc/hosts | 
sed -n ':a;N;$!ba;s/127\.0\.1\.1..*$//gp' |
sed -n '1h;1!H;${;g;s/$/127.0.1.1\t'$HOSTNAME'/gp}' |
sudo tee /etc/hosts > /dev/null

#capture new hostname
HOSTNAME=$(hostname)

#echo details
echo ""
echo -e "${R}Changed host name into ${W}$HOSTNAME${R}."
echo -e "${R}Changed ${W}127.0.1.1${R} to ${W}$HOSTNAME${R} in ${W}/etc/hosts${R}"
echo ""
