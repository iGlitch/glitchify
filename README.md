<h1 align="center">Glitchify</h1>
<p align="center">Magisk module for making batteries great again on Google Pixel devices<strong></strong>
</p>

<p align="center">
<img src="https://img.shields.io/badge/Version-1.5-lightgrey.svg?style=flat-square"/><img src="https://img.shields.io/badge/Updated-Nov%2006%2C%202019-brightgreen.svg?style=flat-square"/>
</p>

## What is Glitchify ?
Glitchify is a tiny, yet powerful all-in-one tweakset that significantly increases battery life while keeping the wonderful performance of the Google Pixel Android phones.  I only own a Google Pixel (sailfish) phone so don't bother me for issues on other devices please.

## Features
- Sets *schedutil* CPU governer by default (if it exists in the kernel)
- frequency tweaks for good battery without extreme sacrifice of performance
- fstrim at boot
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
- [Magisk v18+](https://github.com/topjohnwu/Magisk/releases) or init.d support if you prefer to not use magisk
- [Busybox](https://github.com/Magisk-Modules-Repo/busybox-ndk)
- One of the compatible devices from the compatibility list.

## Install
- Flash the .zip in MM.

## Device Compatibility
```
Google Pixel (sailfish)
Google Pixel XL (marlin)
Google Pixel 2 (walleye)
Google Pixel 2 XL (taimen)
Google Pixel 3 (blueline)
Google Pixel 3 XL (crosshatch)
Google Pixel 3a (sargo)
Google Pixel 3a XL (bonito)
Google Pixel 4 (flame)
Google Pixel 4 XL (coral)

```
## Changelog
### v1.5 (2019/11/06)
- Add support for Pixel 4
- Updated Template

### v1.4 (2019/07/12)
- Add support for Pixel 3a
- Updated props from FDE

### v1.3 (2019/03/30)
- Updated to latest unity template
- Updated BM mount script
- Updated SQLite3 binary
- Cleanup for smaller size!

### v1.2 (2019/02/18)
- Moved some setprops into system.prop
- Updated BM for all Pixel devices. 
- Updated Doze, less kernel logging.
- More cleanup and bug fixes.

### v1.1 (2019/02/18)
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
- [Unity template](https://github.com/Zackptg5/Unity)
- [Magisk](https://github.com/topjohnwu/Magisk)
- xFireFly93, gloeyisk, simonsmh, korom42, feravolt
- Authors of kernels with schedutil additions.

<p align="center">
<img src="http://hits.dwyl.io/iGlitch/glitchify.svg"/>
</p>
