BREAKING CHANGE : comma separated domains instead of list. You’ll need to go in addon options after updating, and click “save”. Or remove your previous domains list, and read it in the format : “newdomain1.com 1, newdomain2.com”

# Home assistant add-on: Nextcloud with OCR
![Supports aarch64 Architecture][aarch64-shield] ![Supports amd64 Architecture][amd64-shield] ![Supports armhf Architecture][armhf-shield] ![Supports armv7 Architecture][armv7-shield]

## About

Various tweaks and configuration options addition. 
Inital fork from version : https://github.com/haberda/hassio_addons
This addon is based on the [docker image](https://github.com/linuxserver/docker-nextcloud) from linuxserver.io.

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Hass.io add-on.

1. [Add my Hass.io add-ons repository][repository] to your Hass.io instance.
1. Install this add-on.
1. Click the `Save` button to store your configuration.
1. Start the add-on.
1. Check the logs of the add-on to see if everything went well.
1. Carefully configure the add-on to your preferences, see the official documentation for for that.


## Configuration

```
PGID/PUID : 1000 #allows setting user.
trusted_domains : your-domain.com #allows to select the trusted domains. Domains not in this lis will be removed, except for the first one used in the initial configuration. 
OCR : false #set to true to install tesseract-ocr capability. 
OCRLANG : fra #Any language can be set from this page (always three letters) [here](https://tesseract-ocr.github.io/tessdoc/Data-Files#data-files-for-version-400-november-29-2016).
use_own_certs : true/false #if true, use the certfile and keyfile specified
certfile: fullchain.pem #ssl certificate, must be located in /ssl
keyfile: privkey.pem #sslkeyfile, must be located in /ssl
```

Webui can be found at `<your-ip>:port`.

[repository]: https://github.com/alexbelgium/hassio-addons
[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
