#!/system/bin/sh

sdcard_rw() {
  local test_file="/sdcard/Android/.test_clear_the_blacklist"
  echo "true" > $test_file
  while [[ ! -f $test_file ]]; do
    echo "true" > $test_file
    sleep 1
  done
  rm "$test_file"
}

until [[ $(getprop sys.boot_completed) -eq 1 ]]; do
  sleep 2
done
sdcard_rw

MODDIR=${0%/*}
[[ -f $MODDIR/script/tmp/Screen_on ]] && rm -rf $MODDIR/script/tmp/Screen_on
. $MODDIR/script/clear_the_blacklist_functions.sh
logd_clear "开机启动完成: [service.sh]"
sh $MODDIR/initial.sh
