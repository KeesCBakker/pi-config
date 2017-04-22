#!/bin/bash
# By Kees C. Bakker / KeesTalksTech

# Gets you IP details for your adapter.

# Syntax:
# get-my-ip.sh        - will get the details for adapter eht0
# get-my-ip.sh {name} - will get the details for adapter with the specified name

# Source: https://github.com/KeesCBakker/pi-config/blob/master/get-my-ip.sh

# colors
W='\033[1;37m'
G='\033[1;92m'
R='\033[0m' # No Color

#get the adapter
ADAPTER=$1

#default to eth0 adapter
if [ -z "$ADAPTER" ]; then
	ADAPTER=eth0
fi

#get the data for the adapter
ADDRESS=$(
	ifconfig | 
	grep -Pzo "$ADAPTER.*\n.*inet addr:.*" | 
	head -n 2
)

#check not found
if [ -z "$ADDRESS" ]; then
	echo ""
	echo -e "Adapter ${W}$ADAPTER${R} not found or not connected."
	echo ""
	exit 1
fi

#ip is the first line
IP=$(
	echo $ADDRESS | 
	egrep -o '([0-9]+\.?){4}' | 
	head -n 1
);

#bcast is the second line
BCAST=$(
	echo $ADDRESS | 
	egrep -o '([0-9]+\.?){4}' | 
	head -n 2 | 
	tail -n 1
);

#subnet is the third and last line
SUBNET=$(
	echo $ADDRESS | 
	egrep -o '([0-9]+\.?){4}' | 
	tail -n 1
);

#gateway
GATEWAY=$(
	route -n | 
	head -n 3 | 
	tail -n 1 | 
	egrep -o '[1-9][0-9]*\.([0-9]+\.?){3}'
)

#destination
DESTINATION=$(
	route -n | 
	head -n 4 | 
	tail -n 1 | 
	egrep -o '[1-9][0-9]*\.([0-9]+\.?){3}' | 
	head -n 1)

echo ""
echo -e "Details for ${W}$ADAPTER${R}:"
echo ""
echo -e "address ${W}$IP${R}"
echo -e "netmask ${W}$SUBNET${R}"
echo -e "network ${W}$DESTINATION${R}"
echo -e "broadcast ${W}$BCAST${R}"
echo -e "gateway ${W}$GATEWAY${R}"
echo ""
