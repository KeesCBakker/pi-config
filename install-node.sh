#!/bin/bash
# By Kees C. Bakker / KeesTalksTech

# Downloads NodeJS from the Node repository. Should work for any Pi. Will detect ARM version.
# Tested with RPi1/armv6l and RPi3/armv7l.
# Will remove a previous version installed by the script (up and downgrade compatible).

# Syntax:
# install-node.sh latest - will install latest node version
# install-node.sh stable - will install the latest Long Term Stable (LTS) node version
# install-node.sh {version} - will install that version.

# Source: https://github.com/KeesCBakker/pi-config/blob/master/install-node.sh
# Based on script by Kees C. Bakker @ https://github.com/KeesCBakker/node-pi-zero/blob/master/install-node-v.last.sh
# Based on script by Steven de Salas @ https://github.com/sdesalas/node-pi-zero/blob/master/install-node-v7.7.1.sh
# Based on script by Richard Stanley @ https://github.com/audstanley/Node-MongoDb-Pi/

# colors
W='\033[1;37m'
G='\033[1;92m'
R='\033[0m' # No Color

echo ""

#get pi ARM version
PI_ARM_VERSION=$(
	uname -a | 
	egrep 'armv[0-9]+l' -o
);

NODE_VERSION=$1

if [ -z "$NODE_VERSION" ] || [ "$NODE_VERSION" = "stable" ]; then

	echo -e "This script will${W} install the latest stable NodeJS (LTS)${R} for you."

	#get latest nodejs stable version from node website
	#read the first version that matches the arm platform and has a "lts":" part
	NODE_VERSION=$(
		curl -s https://nodejs.org/dist/index.json | 
		egrep "{\"version\":\"v([0-9]+\.?){3}\"[^{}]*\"linux-"$PI_ARM_VERSION"[^}]*lts\":\"[^}]*}" -o |
  		head -n 1
	);

elif [ "$NODE_VERSION" = "latest" ]; then

	echo -e "This script will ${W}install the latest NodeJS ${R}for you (non LTS included)."

	#get latest nodejs stable version from node website
	#read the first version that matches the arm platform
	NODE_VERSION=$(
  		curl -s https://nodejs.org/dist/index.json | 
  		egrep "{\"version\":\"v([0-9]+\.?){3}\"[^{}]*\"linux-"$PI_ARM_VERSION"[^}]*}" -o |
  		head -n 1
);
else 

	echo -e "This script will try to ${W}install NodeJS v$NODE_VERSION ${R}for you."

	#get specific nodejs version from node website
	#make sure the version matches the arm platform
	NODE_VERSION=$(
  		curl -s https://nodejs.org/dist/index.json | 
  		egrep "{\"version\":\"v$NODE_VERSION\"[^{}]*\"linux-"$PI_ARM_VERSION"[^}]*}" -o |
  		head -n 1
	);
fi

#get the version
VERSION=$(
  echo $NODE_VERSION | 
  egrep 'v([0-9]+\.?){3}' -o
);

#get lts version
LTS_VERSION=$(echo $NODE_VERSION | 
  egrep '"[^"]+"}$' -o | 
  egrep '[a-zA-Z]+' -o | 
  tr '[:upper:]' '[:lower:]'
);

#echo not found
if [ -z "$VERSION" ]; then 	
	echo -e "Version ${W}v$1${R} could not be found for architecture ${W}linux-$PI_ARM_VERSION${R}."
	echo ""
	exit 1
fi

#echo details before installing
if [ -z "$LTS_VERSION" ] ; then
	echo -e "NodeJS ${W}$VERSION${R} will be installed for architecture ${W}linux-$PI_ARM_VERSION${R}."
	echo "This version is not LTS."
else
	echo -e "NodeJS ${W}$VERSION${R} ($LTS_VERSION) will be installed for architecture ${W}linux-$PI_ARM_VERSION${R}."
fi

# download to tmp directory
cd /tmp/

echo ""
echo -e "${W}Downloading${R}..."

if [ -z "$LTS_VERSION" ]; then
	wget -O https://nodejs.org/dist/$VERSION/node-$VERSION-linux-$PI_ARM_VERSION.tar.gz;
else 
	wget -O https://nodejs.org/dist/latest-$LTS_VERSION/node-$VERSION-linux-$PI_ARM_VERSION.tar.gz;
fi

echo -e "${W}Installing${R}..."

#tar the file
tar -xzf node-$VERSION-linux-$PI_ARM_VERSION.tar.gz;

# Remove the tar after extracing it.
sudo rm node-$VERSION-linux-$PI_ARM_VERSION.tar.gz;

# This line will clear existing nodejs
sudo rm -rf /opt/nodejs;

# This next line will copy Node over to the appropriate folder.
sudo mv node-$VERSION-linux-$PI_ARM_VERSION /opt/nodejs/;

# Remove existing symlinks
sudo unlink /usr/bin/node;
sudo unlink /usr/sbin/node;
sudo unlink /sbin/node;
sudo unlink /usr/local/bin/node;
sudo unlink /usr/bin/npm;
sudo unlink /usr/sbin/npm;
sudo unlink /sbin/npm;
sudo unlink /usr/local/bin/npm;

# Create symlinks to node && npm
sudo ln -s /opt/nodejs/bin/node /usr/bin/node;
sudo ln -s /opt/nodejs/bin/node /usr/sbin/node;
sudo ln -s /opt/nodejs/bin/node /sbin/node;
sudo ln -s /opt/nodejs/bin/node /usr/local/bin/node;
sudo ln -s /opt/nodejs/bin/npm /usr/bin/npm;
sudo ln -s /opt/nodejs/bin/npm /usr/sbin/npm;
sudo ln -s /opt/nodejs/bin/npm /sbin/npm;
sudo ln -s /opt/nodejs/bin/npm /usr/local/bin/npm;

echo ""
echo -e "${G}Done${R}. Details:"

NV=$(node -v)
echo -e "- Node version: ${W}$NV${R}"

NPMV=$(npm -v)
echo -e "- NPM version: ${W}$NPMV${R}"

echo ""
