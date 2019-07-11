# Unity Config Script
SKIPMOUNT=false
PROPFILE=true
#POSTFSDATA=false
LATESTARTSERVICE=true

if [ -z $UF ]; then
  UF=$TMPDIR/common/unityfiles
  unzip -oq "$ZIPFILE" 'common/unityfiles/util_functions.sh' -d $TMPDIR >&2
  [ -f "$UF/util_functions.sh" ] || { ui_print "! Unable to extract zip file !"; exit 1; }
  . $UF/util_functions.sh
fi

comp_check

REPLACE="
"

print_modname() {
  center_and_print
  unity_main
}

set_permissions() {
  : 
}

unity_custom() {
  :
}
