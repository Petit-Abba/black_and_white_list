#延迟打印
MyPrint() {
  echo "$@"
  sleep 0.05
}

MyPrint " "
MyPrint "╔════════════════════════════════════"
MyPrint "║   - [&]请先阅读 避免一些不必要的问题"
MyPrint "╠════════════════════════════════════"
MyPrint "║"
MyPrint "║   - 1.模块刷入重启后，只在用户解锁设备才开始生效。"
MyPrint "║   - 2.使用crond定时命令，不会浪费或占用系统资源。"
MyPrint "║   - 3.模块自定义路径: /sdcard/Android/clear_the_blacklist/"
MyPrint "║ "
MyPrint "║   - https://github.com/Petit-Abba/black_and_white_list/"
MyPrint "║ "
MyPrint "╚════════════════════════════════════"
MyPrint " "

#定义变量
#定义文件夹路径
black_and_white_list_path="/sdcard/Android/clear_the_blacklist"
black_and_white_list_path_old="/sdcard/Android/clear_the_blacklist_old"
cron_set_dir="${black_and_white_list_path}/定时任务"

# 判断是否安装过
if [[ -d ${black_and_white_list_path} ]]; then
  MyPrint "检测到已经安装过。"
  MyPrint "杀死crond进程···"
  # 获取crond的pid
  crond_pid="$(pgrep -f 'crond_clear_the_blacklist')"
  # "-n"当是非空时返回true，和! -z一样。
  if [[ -n "${crond_pid}" ]]; then
    for kill_pid in ${crond_pid}; do
      kill -9 "${kill_pid}" && MyPrint "杀死crond进程: ${kill_pid}"
    done
  fi
  MyPrint "备份历史文件···"
  rm -rf "$black_and_white_list_path_old"
  mkdir -p "$black_and_white_list_path_old"
  cp -rf $black_and_white_list_path/* "$black_and_white_list_path_old"
  rm -rf "$black_and_white_list_path"
  MyPrint "历史文件路径：$black_and_white_list_path_old"
fi

#如果是ksu则判断busybox是否存在
if [[ -f "/data/adb/ksud" ]]; then
  #获取ksu的busybox地址
  busybox="/data/adb/ksu/bin/busybox"
  #释放地址
  filepath="/data/adb/busybox"
  crond_check="/data/adb/busybox/crond"
  #检查Busybox并释放
  if [[ -f $busybox ]]; then
    if [[ ! -d $filepath ]] || [[ ! -f $crond_check ]]; then
      #先删一次保险
      rm -rf "$filepath" &>/dev/null
      #如果没有此文件夹则创建
      mkdir -p "$filepath"
      #存在Busybox开始释放
      "$busybox" --install -s "$filepath"
      MyPrint "已安装busybox。"
    fi
  fi
fi

#释放文件
mkdir -p ${cron_set_dir}
cp -r "${MODPATH}"/AndroidFile/黑名单.prop ${black_and_white_list_path}/
cp -r "${MODPATH}"/AndroidFile/白名单.prop ${black_and_white_list_path}/
cp -r "${MODPATH}"/AndroidFile/定时任务/定时设置.ini ${cron_set_dir}/
cp -r "${MODPATH}"/AndroidFile/定时任务/Run_cron.sh ${cron_set_dir}/
rm -rf "${MODPATH}"/AndroidFile/
MyPrint "安装完成！"
