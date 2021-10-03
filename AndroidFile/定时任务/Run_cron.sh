#!/system/bin/sh

CN_AMPM() {
  case $1 in
    1|3|4|5)  alias $2="凌晨"  ;;
    6|7|8|9)  alias $2="早上"  ;;
    10|11)  alias $2="上午"  ;;
    12)  alias $2="中午"  ;;
    13|14|15|16|17)  alias $2="下午"  ;;
    18|19|20|21|22|23|0)  alias $2="晚上"  ;;
  esac
}

magisk_util_functions=/data/adb/magisk/util_functions.sh
[[ ! -f $magisk_util_functions ]] && exit 66
grep -q 'lite_modules' "$magisk_util_functions" && modules_path="lite_modules" || modules_path="modules"
mod_path="/data/adb/$modules_path/crond_clear_the_blacklist"

mod_bin_path=$mod_path/bin
[[ ! -d $mod_bin_path ]] && exit 88

set_path=${0%/*}
set_file=$set_path/定时设置.ini
cron_d_path=$mod_path/script/set_cron.d
[[ ! -d $cron_d_path ]] && mkdir -p $cron_d_path
. $mod_path/script/clear_the_blacklist_functions.sh

if [[ -f $set_file ]]; then
  . $set_file
  if [[ $? != 0 ]]; then
    echo "- [!]: 文件读取异常，请审查(设置定时.ini)文件内容！" && exit 1
  fi
else
  echo "- [!]: 缺少$set_file文件" && exit 2
fi

#mod_version=`cat $mod_path/module.prop | grep "version=" | sed 's/version=//g'`
#mod_description=`cat $mod_path/module.prop | grep "description=" | sed 's/description=//g' | awk -F '[' '{print $2}' | awk -F ']' '{print $1}'`
#echo "- 版本: $mod_version"
#echo "- 信息:$mod_description"

case $minute in
  [1-9]*)
    if [[ $minute -le 60 ]]; then
      echo "- 填写正确 | minute=\"$minute\""
    else
      echo "- [!]: 填写错误 | minute=\"$minute\" | 超出60，请重新填写。" && exit 3
    fi
    ;;
  *)
    echo "- [!]: 填写错误 | minute=\"$minute\" | 请重新填写(1..60)。" && exit 4
    ;;
esac

case $what_time_run in
  y|n)  echo "- 填写正确 | what_time_run=\"$what_time_run\""  ;;
  *)  echo "- [!]: 填写错误 | what_time_run=\"$what_time_run\" | 请填写y或n" && exit 5  ;;
esac

if [[ $what_time_run == y ]]; then
  what_time_1=`echo $what_time | awk -F "-" '{print $1}'`
  what_time_2=`echo $what_time | awk -F "-" '{print $2}'`
  if [[ -z $what_time_1 ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 格式: 几点-几点"
    exit 6
  elif [[ -z $what_time_2 ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 格式: 几点-几点"
    exit 7
  elif [[ -z $(echo $what_time_1 | grep "^[0-9]") ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 填写数字(几点-几点)，不是乱七八糟的东西！"
    exit 8
  elif [[ -z $(echo $what_time_1 | grep "[0-9]$") ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 填写数字(几点-几点)，不是乱七八糟的东西！"
    exit 9
  elif [[ -z "$(echo $what_time_2 | grep "^[0-9]")" ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 填写数字(几点-几点)，不是乱七八糟的东西！"
    exit 10
  elif [[ -z "$(echo $what_time_2 | grep "[0-9]$")" ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 填写数字(几点-几点)，不是乱七八糟的东西！"
    exit 11
  elif [[ $(echo $what_time_1 | grep -v "[0-9]") != "" ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 填写数字(整数-整数)，不要包含其他字符！"
    exit 12
  elif [[ $(echo $what_time_2 | grep -v "[0-9]") != "" ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 填写数字(整数-整数)，不要包含其他字符！"
    exit 13
  elif [[ ${#what_time_1} -ge 3 ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 填写数字(整数-整数)，不要超过3个字符！"
    exit 14
  elif [[ ${#what_time_2} -ge 3 ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 填写数字(整数-整数)，不要超过3个字符！"
    exit 15
  elif [[ $what_time_1 == $what_time_2 ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 几点-几点 时间不能相同！"
    exit 16
  elif [[ $what_time_1 -ge 24 ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 时间不能大于或等于24点 这里的24点是0点"
    exit 17
  elif [[ $what_time_2 -ge 24 ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 时间不能大于或等于24点 这里的24点是0点"
    exit 18
  else
    echo "- 填写正确 | what_time=\"$what_time\""
  fi
  [[ $what_time_1 -gt $what_time_2 ]] && cn_text="第二天" || cn_text=""
  [[ $what_time_2 == 0 ]] && cn_text=""
  CN_AMPM "$what_time_1" "time_period_1"
  CN_AMPM "$what_time_2" "time_period_2"

  logd_ini="minute=\"$minute\" | what_time_run=\"$what_time_run\" | what_time=\"$what_time\""
  crond_rule="*/$minute $what_time * * *"
  print_set="每天${time_period_1}${what_time_1}:00到${cn_text}${time_period_2}${what_time_2}:59，每隔${minute}分钟运行一次。"
else
  logd_ini="minute=\"$minute\" | what_time_run=\"$what_time_run\""
  crond_rule="*/$minute * * * *"
  print_set="24H 每隔${minute}分钟运行一次"
fi

echo "- 定时设置 | $crond_rule"
echo "- 内容解读 | $print_set"
echo "$print_set" > $mod_path/print_set

clear_the_blacklist_crond_pid_1="$(ps -ef | grep -v 'grep' | grep 'crond' | grep 'crond_clear_the_blacklist' | awk '{print $2}')"
if [[ ! -z $clear_the_blacklist_crond_pid_1 ]]; then
  echo "- 杀死上次定时 | pid: $clear_the_blacklist_crond_pid_1"
  kill -9 $clear_the_blacklist_crond_pid_1
fi

MAGISKTMP="$(magisk --path 2>/dev/null)"
[[ -z "$MAGISKTMP" ]] && MAGISKTMP="/sbin"
alias crond="$MAGISKTMP/.magisk/busybox/crond"
alias bash="$mod_bin_path/bash"
chmod -R 0777 $mod_path

echo "# set cron $(date '+%m/%d %T')" > $cron_d_path/root
echo "SHELL=$mod_bin_path/bash" >> $cron_d_path/root
echo "$crond_rule $mod_bin_path/bash \"$mod_path/script/Run_clear.sh\"" >> $cron_d_path/root
crond -c "$cron_d_path" && {
  clear_the_blacklist_crond_pid_2="$(ps -ef | grep -v 'grep' | grep 'crond' | grep 'crond_clear_the_blacklist' | awk '{print $2}')"
  echo "- 定时启动成功 | pid: $clear_the_blacklist_crond_pid_2"
  log_md_set_cron_clear
  [[ -f $mod_path/script/Run_clear.sh ]] && sh $mod_path/script/Run_clear.sh >/dev/null || echo "- 模块脚本缺失！"
}
