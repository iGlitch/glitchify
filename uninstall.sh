$SYSOVER && { mount -o rw,remount /system; [ -L /system/vendor ] && mount -o rw,remount /vendor; }

FILE=$INFO
[ -f $MODPATH/glitchify-files ] && FILE=$MODPATH/glitchify-files
if [ -f $FILE ]
  while read LINE; do
    if [ "$(echo -n $LINE | tail -c 1)" == "~" ] || [ "$(echo -n $LINE | tail -c 9)" == "NORESTORE" ]; then
      continue
    elif [ -f "$LINE~" ]; then
      mv -f $LINE~ $LINE
    else
      rm -f $LINE
      while true; do
        LINE=$(dirname $LINE)
        [ "$(ls -A $LINE 2>/dev/null)" ] && break 1 || rm -rf $LINE
      done
    fi
  done < $FILE
fi

$SYSOVER && { rm -f $INFO; mount -o ro,remount /system; [ -L /system/vendor ] && mount -o ro,remount /vendor; }
