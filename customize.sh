SKIPUNZIP=0

MyPrint() {
   echo "$@"
   sleep 0.04
}

get_choose() {
   local choose
   local branch
   while :; do
      choose="$(getevent -qlc 1 | awk '{ print $3 }')"
      case "$choose" in
      KEY_VOLUMEUP)   branch="0" ;;
      KEY_VOLUMEDOWN)   branch="1" ;;
      *)   continue ;;
      esac
      echo "$branch"
      break
   done
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
MyPrint "║   - ps: 只要你手机开机，只要你使用任何软件，设备本身就已经开始进"
MyPrint "║行各种频繁读写，如果你认为该模块会损耗设备闪存，那么请按音量－。"
MyPrint "║ "
MyPrint "║   - https://github.com/Petit-Abba/black_and_white_list/"
MyPrint "║ "
MyPrint "╚════════════════════════════════════"
MyPrint " "
MyPrint "- 是否安装？(请选择)"
MyPrint "- 按音量键＋: 安装 √"
MyPrint "- 按音量键－: 退出 ×"
if [[ $(get_choose) != 0 ]]; then
   abort "- 已选择退出"
else
   black_and_white_list_path="/sdcard/Android/clear_the_blacklist"
   cron_set_dir="${black_and_white_list_path}/定时任务"

   Black_List="${black_and_white_list_path}/黑名单.prop"
   White_List="${black_and_white_list_path}/白名单.prop"
   cron_set_file="${cron_set_dir}/定时设置.ini"
   Run_cron_sh="${cron_set_dir}/Run_cron.sh"

   magisk_util_functions="/data/adb/magisk/util_functions.sh"
   grep -q 'lite_modules' "${magisk_util_functions}" && modules_path="lite_modules" || modules_path="modules"
   mod_path="/data/adb/${modules_path}/crond_clear_the_blacklist"
   script_dir="${mod_path}/script"

   # 判断是否安装过
   [[ -d ${script_dir}/tmp/DATE ]] && {
      [[ -d ${black_and_white_list_path} ]] && {
         MyPrint " "
         MyPrint "- [?] 是否保留全部配置文件和数量统计"
         MyPrint "- 是否保留？(请选择)"
         MyPrint "- 按音量键＋: 全部保留 √"
         MyPrint "- 按音量键－: 重头开始 ×"
         if [[ $(get_choose) != 0 ]]; then
            MyPrint " "
            MyPrint "- 重来"
            crond_pid="$(ps -ef | grep -v 'grep' | grep 'crond' | grep 'crond_clear_the_blacklist' | awk '{print $1}')"
            if [[ ! -z "${crond_pid}" ]]; then
               for kill_pid in ${crond_pid}; do
                  kill -9 ${kill_pid} && MyPrint "- 杀死crond进程: ${kill_pid}"
               done
            fi
            rm -rf ${black_and_white_list_path} && MyPrint "- 删除${black_and_white_list_path}文件夹"
            MyPrint " "
         else
            MyPrint " "
            MyPrint "- 保留"
            cp -r ${script_dir}/tmp/ ${MODPATH}/script/
            [[ -f ${script_dir}/set_cron.d/root ]] && cp -r ${script_dir}/set_cron.d/root ${MODPATH}/script/set_cron.d/
            [[ -d ${script_dir}/White_List_File ]] && cp -r ${script_dir}/White_List_File/ ${MODPATH}/script/
            [[ -f ${mod_path}/print_set ]] && cp -r ${mod_path}/print_set ${MODPATH}/
            MyPrint " "
         fi
      }
   }

   [[ -d ${cron_set_dir} ]] || mkdir -p ${cron_set_dir}
   [[ -f ${Black_List} ]] || cp -r ${MODPATH}/AndroidFile/黑名单.prop ${black_and_white_list_path}/
   [[ -f ${White_List} ]] || cp -r ${MODPATH}/AndroidFile/白名单.prop ${black_and_white_list_path}/
   [[ -f ${cron_set_file} ]] || cp -r ${MODPATH}/AndroidFile/定时任务/定时设置.ini ${cron_set_dir}/
   [[ -f ${Run_cron_sh} ]] && rm -rf ${Run_cron_sh}
   cp -r ${MODPATH}/AndroidFile/定时任务/Run_cron.sh ${cron_set_dir}/
   rm -rf ${MODPATH}/AndroidFile/
   echo "test" > ${cron_set_dir}/test.bak

   go_to_coolapk() {
   if [[ "$(pm list package | grep -w 'com.coolapk.market')" != "" ]];then
      MyPrint " "
      MyPrint "- 你安装了酷安 是否前往作者主页？(请选择)"
      MyPrint "- 按音量键＋: “我来啦”"
      MyPrint "- 按音量键－: “爷不去”"
      if [[ $(get_choose) = 0 ]]; then
         am start -d 'coolmarket://u/1132618' >/dev/null 2>&1
         MyPrint " "
         MyPrint " "
      else
         MyPrint "- 甘霖凉"
         MyPrint " "
      fi
   fi
   }
   #go_to_coolapk
fi
