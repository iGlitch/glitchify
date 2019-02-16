#!/system/bin/sh
ui_print "Uninstalling..."
rm -f /data/adb/service.d/glitchify.sh
rm -f /data/adb/service.d/bm.sh
rm -f /data/adb/service.d/cleaner.sh
rm -rf /.sbin/magisk/img/Glitchify
ui_print "Sorry to see you go... goodbye"
ui_print " "

