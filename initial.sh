#全局变量
MODDIR=${0%/*}

#拉起子sh进程
. "$MODDIR"/script/clear_the_blacklist_functions.sh

#定义变量
if [[ -f "/data/adb/ksud" ]]; then
  alias crond="/data/adb/busybox/crond"
else
  alias crond="\$( magisk --path )/.magisk/busybox/crond"
fi

logd "初始化完成: [initial.sh]"

if [[ -f "$MODDIR"/script/set_cron.d/root ]]; then
  crond -c "$MODDIR"/script/set_cron.d
  crond_root_file=$MODDIR/script/set_cron.d/root
else
  echo "每天7:00到23:00,每隔60分钟运行一次" >"$MODDIR"/print_set
  echo "*/60 7-23 * * * $MODDIR/script/Run_clear.sh" >"$MODDIR"/script/set_cron.d/root
  crond -c "$MODDIR"/script/set_cron.d
  crond_root_file=$MODDIR/script/set_cron.d/root
fi

#休息一下
sleep 5

#判断是否定时成功
if [[ $(pgrep -f 'crond_clear_the_blacklist/script/set_cron.d') != "" ]]; then
  basic_Information
  logd "$(cat "$MODDIR"/print_set)"
  logd "开始运行: [$crond_root_file]"
  logd "------------------------------------------------------------"
else
  basic_Information
  logd "运行失败！"
  exit 1
fi

#拉起主进程
sh "$MODDIR"/script/Run_clear.sh
