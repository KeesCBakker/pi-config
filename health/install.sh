#!/bin/bash
# By Kees C. Bakker / KeesTalksTech

# Adds the health node application to your pi.

# 1st parameter is host name
# 2nd parameter is the ip for the MQTT broker

# Source: https://github.com/KeesCBakker/pi-config/blob/master/health/install.sh

#quit on error
set -e

#colors
W='\033[1;37m'
G='\033[1;92m'
R='\033[0m' # No Color

#get the input
NAME=$1
IP=$2

if [ -z "$NAME" ] || [ -z "$IP" ]; then
	echo ''
	echo 'Invalid syntax. Use: '
	echo ''
	echo '	install.sh {name} {ip}'
	echo ''
	exit 1
fi

#base url
BASE=https://raw.githubusercontent.com/KeesCBakker/pi-config/master/health

#ensure app directory
APPDIRECTORY=~/app/health
if [ ! -d "$APPDIRECTORY" ]; then
	mkdir -p $APPDIRECTORY;
fi

#goto app directory
cd $APPDIRECTORY

echo ''
echo 'Downloading health application:'

echo '  app.js'
wget "$BASE/app.js" -O app.js -q

echo '  app.json'
wget "$BASE/app.json" -O app.json -q

echo '  package.json'
wget "$BASE/package.json" -O package.json -q

sed -i -- "s/\[ip\]/$IP/g" app.json
sed -i -- "s/\[name\]/$NAME/g" app.json

isNpmPackageInstalled() {
  npm list --depth 1 -g $1 > /dev/null 2>&1
}

echo ''
echo 'Checking status of "forever"...'

if isNpmPackageInstalled forever; then
	echo '  installed!'
else 
	echo '  installing...'
	npm install forever -g
fi

echo ''
echo 'Updating packages...'
npm update

echo ''
echo 'Running "forever"'

FEVR=$(npm root -g)

node $FEVR/forever/bin/forever start $APPDIRECTORY/app.js

echo ''
echo 'Ready.'
echo ''