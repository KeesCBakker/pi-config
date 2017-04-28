
set -e

# colors
W='\033[1;37m'
G='\033[1;92m'
R='\033[0m' # No Color

#base url
#BASE=https://raw.githubusercontent.com/KeesCBakker/pi-config/master/health

#ensure app directory
APPDIRECTORY=~/app/health
if [ ! -d "$APPDIRECTORY" ]; then
	mkdir $APPDIRECTORY;
fi

#goto app directory
cd $APPDIRECTORY


npm install forever -g

wget "$BASE/app.js" -O app.js
wget "$BASE/app.json" -O app.json
wget "$BASE/package.json" -O package.json

npm update