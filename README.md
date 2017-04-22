# pi-config
Scripts to configure my Raspberry Pi. Tested on RPi 1 and RPi 3.

## get your ip settings
If you need your IP settings (address, subnet, gateway and destination details), run: <br/>
```
$ curl https://raw.githubusercontent.com/KeesCBakker/pi-config/master/get-my-ip | bash -s eth0
```

It takes the adapter name as input.

## install node js
Install node on your Pi using the `install-node` script. It will install Node from the NodeJS website. It's fast! The script will auto-detect your ARM version.

Latest stable version for your platform: <br/>
```
$ curl https://raw.githubusercontent.com/KeesCBakker/pi-config/master/install-node.sh | bash
```

Latest version for your platform: <br/>
```
$ curl https://raw.githubusercontent.com/KeesCBakker/pi-config/master/install-node.sh | bash -s latest
```

Specific version (like 7.9.0) for your platform: <br/>
```
$ curl https://raw.githubusercontent.com/KeesCBakker/pi-config/master/install-node.sh | bash -s {version}
```

