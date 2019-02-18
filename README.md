<h1 align="center">Glitchify</h1>
<p align="center">Magisk module for making batteries great again on Google Pixel devices<strong></strong>
</p>

<p align="center">
<img src="https://img.shields.io/badge/Version-1.1-lightgrey.svg?style=flat-square"/><img src="https://img.shields.io/badge/Updated-Feb%2016%2C%202019-brightgreen.svg?style=flat-square"/>
</p>

## What is Glitchify ?
Glitchify is a tiny, yet powerful all-in-one tweakset that significantly increases battery life while keeping the wonderful performance of the Google Pixel Android phones.  I (Glitch) only own a Google Pixel (sailfish) phone, and I do not know or support using this on phones outside of the Pixel series.

## Features
- Sets *schedutil* CPU governer by default (if it exists in the kernel)
- frequency tweaks for good battery without extreme sacrifice of performance
- fsync at boot
- Up to date Unity template (as of the date of this posting)
- msm_thermal/core_control enabled by default
- Customized CPUSet profile
- cfq default scheduler
- disable a lot of unnecessary kernel logging/debugging
- network tweaks for battery life
- virtual memory tweaks (swap, lmk, etc)
- i/o scheduling tweaks
- reduce max brightness and colors
- high performance audio on by default
- disables wake gestures to save battery
- force battery fast charge on
- logs whether complete or not
- prop tweaks (Doze, single user, power saving, secureif, memory, etc)
- and more!

## Optional Installation of cleaner (includes SQLite3 binary)
- zipaligns apks every 60 hours
- sql vacuum and reindex every 60 hours
- junk cleaner - removes cache, txt, logs from places they don't need to be every 60 hours. (fb messenger images may become blank)

## Requirements
- [Magisk v17+](https://github.com/topjohnwu/Magisk/releases) or init.d support if you prefer to not use magisk
- [Busybox](https://forum.xda-developers.com/attachment.php?attachmentid=4654214&d=1543441627)
- One of the compatible devices from the compatibility list.

## Device Compatibility
```
Google Pixel (sailfish)
Google Pixel XL (marlin)
Google Pixel 2 (walleye)
Google Pixel 2 XL (taimen)
Google Pixel 3 (blueline)
Google Pixel 3 XL (crosshatch)
```
## Changelog
### v1.1 (2019/02/17)
- Add initial support for Pixel 2 and 3
- Remove SQL tweaks if cleaner is skipped
- remove the single user mod which breaks a few things
- cleanup

### v1.0 (2019/02/17)
- Initial release

## Disclaimer
Glitchify modifies things from the `kernel` level. **This is only tested on Google Pixel devices.** Don't ask me for support if you try to tamper with it to make it compatible with your own device. If you don't know how it works then use it at your own risk. I won't be responsible for any damage or loss. Always have backups.

## Credits
### Author
**Glitch** - [iGlitch](https://github.com/iGlitch)

Thanks goes to those wonderful people
- [Unity template](https://github.com/Zackptg5/Unity) @ahrion & @Zackptg5 
- [Magisk](https://github.com/topjohnwu/Magisk) @topjohnwu
- xFireFly93, gloeyisk, simonsmh, korom42
- Authors of kernels with schedutil additions.

<p align="center">
<img src="http://hits.dwyl.io/iGlitch/glitchify.svg"/>
</p>
