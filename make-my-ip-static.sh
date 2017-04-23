#!/bin/bash
# By Kees C. Bakker / KeesTalksTech

# Checks for the IP and makes it static by adding it to /etc/dcpcd.conf. 
# Tested with RPi1/armv6l and RPi3/armv7l.
# Will remove a previous static ip entry.

# Syntax:
# make-my-ip-static.sh - will make the IP of eth0 static.
# make-my-ip-static.sh {apapter} - will make the IP of the adapter (like wlan0 or eth0) static

# Source: https://github.com/KeesCBakker/pi-config/blob/master/make-my-ip-static.sh

# colors
W='\033[1;37m'
G='\033[1;92m'
R='\033[0m' # No Color

INTERFACE=$1;

#no interface, default to eht0
if [ -z "$INTERFACE" ]; then
	INTERFACE=eth0
fi

#get the address for the adapter
ADDRESS=$(
	ip addr show $INTERFACE | 
	egrep -o '([0-9]+\.?){4}/[0-9]+'
) > /dev/null

#check not found
if [ -z "$ADDRESS" ]; then
	echo ""
	echo -e "Adapter ${W}$INTERFACE${R} not found or not connected."
	echo ""
	exit 1
fi

#check if adapter is defined in config
IS_DEFINED=$(
	cat /etc/dhcpcd.conf | 
	egrep -o "interface $INTERFACE"
)

#clear adapter settings from config
if [ ! -z "$IS_DEFINED" ]; then
	
	#echo the config
	cat /etc/dhcpcd.conf | 
	
	#replace the adapter settings
	sed -r -n '1h;1!H;${;g;s/\n?interface '$INTERFACE'\n+(static[^\n]*(\n|$))+\n?//gp}' |

	#write the cleaned content to the config
	sudo tee /etc/dhcpcd.conf > /dev/null
fi

#get route for IP
ROUTE=$(ip route show $ADDRESS | egrep -o '^([0-9]|\.)+')

#show the details
echo ""
echo -e "Adding the following information to ${W}/etc/dhcpcd.conf${R}:"
echo ""
echo -e "interface ${W}$INTERFACE${R}"
echo ""
echo -e "static ip_address=${W}$ADDRESS${R}"
echo -e "static routers=${W}$ROUTE${R}"
echo -e "static domain_name_servers=${W}$ROUTE${R}"
echo ""

#write it
echo -e "\ninterface $INTERFACE\n\nstatic ip_address=$ADDRESS\nstatic routers=$ROUTE\nstatic domain_name_servers=$ROUTE" |
sudo tee -a /etc/dhcpcd.conf > /dev/null
