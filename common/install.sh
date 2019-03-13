#!/system/bin/sh

set_bindir(){
  local bindir=/system/bin
  local xbindir=/system/xbin

  # Check for existence of /system/xbin directory.
  if [ ! -d /sbin/.core/mirror$xbindir ]; then
    # Use /system/bin instead of /system/xbin.
    mkdir -p $MODPATH$bindir
    mv $MODPATH$xbindir/sqlite3 $MODPATH$bindir
    rmdir $MODPATH$xbindir
    xbindir=$bindir
 fi

 ui_print " • Installed to $xbindir"
}

keytest() {
  ui_print "** Vol Key Test **"
  ui_print "** Press Vol UP **"
  (/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events) || return 1
  return 0
}

chooseport() {
  while true; do
    /system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events
    if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUME >/dev/null`); then
      break
    fi
  done
  if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUMEUP >/dev/null`); then
    return 0
  else
    return 1
  fi
}

chooseportold() {
  # Calling it first time detects previous input. Calling it second time will do what we want
  $KEYCHECK
  SEL=$?
  if [ "$1" == "UP" ]; then
    UP=$SEL
  elif [ "$1" == "DOWN" ]; then
    DOWN=$SEL
  elif [ $SEL -eq $UP ]; then
    return 0
  elif [ $SEL -eq $DOWN ]; then
    return 1
  else
    ui_print "**  Volume key not detected **"
    abort "** Use name change method in TWRP **"
  fi
}

#Install script for Glitchify
#Remove old versions
if [ -e "/data/adb/service.d/glitchify.sh" ] || [ -e "/sbin/.magisk/img/Glitchify/service.sh" ]; then
ui_print "Removing old versions of Glitchify..."
rm -f /data/adb/service.d/glitchify.sh
rm -f /data/adb/service.d/cleaner.sh
rm -f /data/adb/service.d/01blackenedmod.sh
rm -f /sbin/.magisk/img/Glitchify/service.sh
fi

KEYCHECK=$INSTALLER/common/keycheck
chmod 755 $KEYCHECK

#set device variable
device="$(getprop ro.product.device)"
if [ $device == "sailfish" ] || [ $device == "marlin" ]; then
    kernelver=$(uname -a)
	case "$kernelver" in  *KingKernel* | *Kirisakura* | *exNoShadez*)
	  ui_print " "; ui_print "You are using a compatible kernel and on Pixel, alright! Installing..."
	  cat $INSTALLER/common/pixel/glitchify.sh >> $INSTALLER/common/service.sh
	  rm -rf $INSTALLER/common/pixel
	  rm -rf $INSTALLER/common/pixel2
          rm -rf $INSTALLER/common/pixel3
		  ;;
      *)
  	  ui_print " "; ui_print "You are using a Pixel, alright! Installing..."
	  cat $INSTALLER/common/pixel/bm.sh >> $INSTALLER/common/service.sh
	  rm -rf $INSTALLER/common/pixel
	  rm -rf $INSTALLER/common/pixel2
          rm -rf $INSTALLER/common/pixel3
		  ;;
	esac
elif [ $device == "walleye" ] || [ $device == "taimen" ] ; then
    ui_print "You are using a Pixel 2, alright! Installing..."
	 cat $INSTALLER/common/pixel2/bm.sh >> $INSTALLER/common/service.sh
	 rm -rf $INSTALLER/common/pixel
	 rm -rf $INSTALLER/common/pixel2
         rm -rf $INSTALLER/common/pixel3
elif [ $device == "crosshatch" ] || [ $device == "blueline" ] ; then
    ui_print "You are using a Pixel 3, alright! Installing..."
    cat $INSTALLER/common/pixel3/bm.sh >> $INSTALLER/common/service.sh
    	rm -rf $INSTALLER/common/pixel
    	rm -rf $INSTALLER/common/pixel2
    	rm -rf $INSTALLER/common/pixel3
else
	ui_print "You are not on a Google Pixel series device! Aborting, please do not try to cheat..."
	exit
fi;

ui_print " "
if keytest; then
    FUNCTION=chooseport
else
    FUNCTION=chooseportold
    ui_print "** Volume button programming **"
    ui_print " "
    ui_print "** Press Vol UP again **"
    $FUNCTION "UP"
    ui_print "**  Press Vol DOWN **"
    $FUNCTION "DOWN"
fi
ui_print "There is an extra cleaner for Glitchify"
ui_print "Zipalign and SQlite tweaks as well as a junk cleaner"
ui_print "These can enhance battery life and make the device run smoother"
ui_print "Some apps may stop functioning properly"
ui_print "Do you want to install the cleaner?"
ui_print " "
ui_print "   Vol(+) = Yes"
ui_print "   Vol(-) = No"
ui_print " "
if $FUNCTION; then
    ui_print " You got it! Installing extra tweaks... "
    ui_print " "
    set_bindir
    cat $INSTALLER/common/cleaner.sh >> $INSTALLER/common/service.sh
    rm -f $INSTALLER/common/cleaner.sh
    ui_print " "
else
    ui_print "NOT installing extra tweaks..."
    rm -rf $INSTALLER/system
    ui_print " "
fi;
