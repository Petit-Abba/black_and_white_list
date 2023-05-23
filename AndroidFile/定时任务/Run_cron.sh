#全局变量
module="/data/adb/modules/crond_clear_the_blacklist"
moduleksu="/data/adb/ksu/modules/crond_clear_the_blacklist"
if [[ -d "$module" ]]; then
  mod_path=$module
else
  mod_path=$moduleksu
fi

set_path=${0%/*}
set_file=$set_path/定时设置.ini
cron_d_path=$mod_path/script/set_cron.d
#不存在则创建目录
[[ ! -d $cron_d_path ]] && mkdir -p $cron_d_path
#拉起子sh进程
. $mod_path/script/clear_the_blacklist_functions.sh

#读取配置
if [[ -f $set_file ]]; then
  if . "$set_file"; then
    echo "- [i]: 文件读取成功"
  else
    echo "- [!]: 文件读取异常，请审查(设置定时.ini)文件内容！" && exit 1
  fi
else
  echo "- [!]: 缺少$set_file文件" && exit 2
fi

#跳过大文件
case $bigfile_auto_skip in
y | n) echo "- 填写正确 | bigfile_auto_skip=\"$bigfile_auto_skip\"" ;;
*) echo "- [!]: 填写错误 | bigfile_auto_skip=\"$bigfile_auto_skip\" | 请填写y或n" && exit 20 ;;
esac

#跳过的文件大小限制
if [[ $bigfile_auto_skip == y ]]; then
  if [[ $bigfile_mb -gt 0 ]]; then
    echo "- 填写正确 | bigfile_mb=\"$bigfile_mb\""
  else
    echo "- [!]: 填写错误，请大于0！" && exit 21
  fi
fi

#读取执行时间间隔
case $minute in
[1-9]*)
  if [[ $minute -le 60 ]]; then
    echo "- 填写正确 | minute=\"$minute\""
  else
    echo "- [!]: 填写错误 | minute=\"$minute\" | 请重新填写(1 — 60)。" && exit 3
  fi
  ;;
*)
  echo "- [!]: 填写错误 | minute=\"$minute\" | 请重新填写(1 — 60)。" && exit 4
  ;;
esac

#读取配置
case $what_time_run in
y | n) echo "- 填写正确 | what_time_run=\"$what_time_run\"" ;;
*) echo "- [!]: 填写错误 | what_time_run=\"$what_time_run\" | 请填写y或n" && exit 5 ;;
esac

#读取定时时间配置
if [[ $what_time_run == y ]]; then
  what_time_1=$(echo "$what_time" | awk -F "-" '{print $1}')
  what_time_2=$(echo "$what_time" | awk -F "-" '{print $2}')
  if [[ -z $what_time_1 ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 格式: 几点-几点"
    exit 6
  elif [[ -z $what_time_2 ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 格式: 几点-几点"
    exit 7
    #echo 命令将 $what_time_1 变量的值输出，
    #再将其传递给 grep 命令进行匹配。如果匹配成功，
    #则 grep 命令的退出状态为零（true），否则为非零值（false）。
    #使用 ! 将其取反后，可以得到和原来 [ -z ... ] 测试语句相同的效果。
  elif ! echo "$what_time_1" | grep -q "[0-9]"; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 填写数字(几点-几点)，不是乱七八糟的东西！"
    exit 8
  elif ! echo "$what_time_2" | grep -q "[0-9]"; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 填写数字(几点-几点)，不是乱七八糟的东西！"
    exit 9
  elif [[ ${#what_time_1} -ge 3 ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 填写数字(整数-整数)，不要超过3个字符！"
    exit 10
  elif [[ ${#what_time_2} -ge 3 ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 填写数字(整数-整数)，不要超过3个字符！"
    exit 11
  elif [[ $what_time_1 == "$what_time_2" ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 几点-几点 时间不能相同！"
    exit 12
  elif [[ $what_time_1 -ge 24 ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 时间不能大于或等于24点 这里的24点是0点"
    exit 13
  elif [[ $what_time_2 -ge 24 ]]; then
    echo "- [!]: 填写错误 | what_time=\"$what_time\" | 时间不能大于或等于24点 这里的24点是0点"
    exit 14
  else
    echo "- 填写正确 | what_time=\"$what_time\""
  fi

  case $long_time_run in
  y | n) echo "- 填写正确 | long_time_run=\"$long_time_run\"" ;;
  *) echo "- [!]: 填写错误 | long_time_run=\"$long_time_run\" | 请填写y或n" && exit 15 ;;
  esac
  if [[ $long_time_run == y ]]; then
    if [[ -z $what_day ]]; then
      echo "- [!]: 填写错误 | what_day=\"$what_day\" | 格式: 数字1-31"
      exit 16
    elif ! echo "$what_day" | grep -q "[0-9]"; then
      echo "- [!]: 填写错误 | what_day=\"$what_day\" | 请填写数字！"
      exit 17
    elif [[ $what_day -gt 31 ]] || [[ $what_day -lt 1 ]]; then
      echo "- [!]: 填写错误 | what_day=\"$what_day\" | 范围限制：1-31"
      exit 18
    else
      echo "- 填写正确 | what_day=\"$what_day\""
    fi

    #输出必要信息
    logd_ini="minute=$minute | what_time_run=$what_time_run | what_time=$what_time | what_day=$what_day"
    crond_rule="*/$minute $what_time */$what_day * *"
    print_set="每隔${what_day}天的${what_time_1}:00到${what_time_2}:59，每隔${minute}分钟运行一次。"
  else
    #判断是否是第二天
    [[ $what_time_1 -gt $what_time_2 ]] && cn_text="第二天" || cn_text=""
    [[ $what_time_2 == 0 ]] && cn_text=""

    #输出必要信息
    logd_ini="minute=$minute | what_time_run=$what_time_run | what_time=$what_time"
    crond_rule="*/$minute $what_time * * *"
    print_set="每天${what_time_1}:00到${cn_text}${what_time_2}:59，每隔${minute}分钟运行一次。"
  fi
else
  logd_ini="minute=$minute | what_time_run=$what_time_run"
  crond_rule="*/$minute * * * *"
  print_set="24H 每隔${minute}分钟运行一次"
fi

echo "- 定时设置 | $crond_rule"
echo "- 内容解读 | $print_set"
echo "$print_set" >$mod_path/print_set

#寻找上一个定时程序的进程pid
clear_the_blacklist_crond_pid_1="$(pgrep -f 'crond_clear_the_blacklist')"
if [[ -n $clear_the_blacklist_crond_pid_1 ]]; then
  echo "- 杀死上次定时 | pid: $clear_the_blacklist_crond_pid_1"
  kill -9 "$clear_the_blacklist_crond_pid_1"
fi

#定义变量
if [[ -f "/data/adb/ksud" ]]; then
  alias crond="/data/adb/busybox/crond"
else
  alias crond="\$( magisk --path )/.magisk/busybox/crond"
fi

#开启定时
echo "$crond_rule $mod_path/script/Run_clear.sh" >$cron_d_path/root
crond -c "$cron_d_path"
clear_the_blacklist_crond_pid_2="$(pgrep -f 'crond_clear_the_blacklist')"
if [[ $clear_the_blacklist_crond_pid_2 == "" ]]; then
  echo "- 定时启动失败，运行失败！"
  exit 19
else
  echo "- 定时启动成功 | pid: $clear_the_blacklist_crond_pid_2"
  log_md_set_cron_clear
  #运行主程序
  if [[ -f $mod_path/script/Run_clear.sh ]]; then
    sh $mod_path/script/Run_clear.sh >/dev/null
  else
    echo "- 模块脚本缺失！"
  fi
fi
