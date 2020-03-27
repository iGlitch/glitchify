REPLACE="
"

set_permissions() {
  set_perm_recursive $MODPATH/service.sh 0 0 0755 0777 
}

SKIPUNZIP=1
unzip -qjo "$ZIPFILE" 'common/functions.sh' -d $TMPDIR >&2
. $TMPDIR/functions.sh