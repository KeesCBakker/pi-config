# pi-config
Scripts to configure my Raspberry Pi. Tested on RPi 1 and RPi 3.

## 0.1 Make IP static
Retrieves your IP and make it static by saving it in your configuration (default `eth0`). <br/>
```
$ curl -s https://raw.githubusercontent.com/KeesCBakker/pi-config/master/make-my-ip-static.sh | bash
```
It takes the adapter name as input. Try `wlan0`.
```
$ curl -s https://raw.githubusercontent.com/KeesCBakker/pi-config/master/make-my-ip-static.sh | bash -s {adapter-name}
```

## 1.1 Install node js
Install node on your Pi using the `install-node` script. It will install Node from the NodeJS website. It's fast! The script will auto-detect your ARM version.

Latest stable version for your platform: <br/>
```
$ curl -s https://raw.githubusercontent.com/KeesCBakker/pi-config/master/install-node.sh | bash
```
Latest version for your platform: <br/>
```
$ curl -s https://raw.githubusercontent.com/KeesCBakker/pi-config/master/install-node.sh | bash -s latest
```
Specific version (like 7.9.0) for your platform: <br/>
```
$ curl -s https://raw.githubusercontent.com/KeesCBakker/pi-config/master/install-node.sh | bash -s {version}
```
