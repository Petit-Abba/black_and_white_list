#全局变量
MODDIR=${0%/*}
#主程序
main_for() {
  # 重新定义字段分隔符 忽略空格和制表符
  local IFS=$'\n'
  # 因为重新定义字段分隔符 所以只需要for 不再需要while read
  for i in $(echo "$Black_List_Expand" | grep -v -F '*'); do
    # 文件夹
    if [[ -d "$i" ]]; then
      #跳过指定目录，防止危险
      case $i in
      *'/.') continue ;;
      *'/./') continue ;;
      *'/..') continue ;;
      *'/../') continue ;;
      esac
      if echo "$White_List_Expand" | grep -qw "$i"; then
        print_pd_white_list "$i" "白名单DIR: $i"
        continue
      fi
      com_xiaomi_market "$i"
      [[ $? == 2 ]] && continue
      rm -rf "$i" && {
        ((DIR++))
        logd "[rm] --黑名单DIR: $i"
        echo "$DIR" >"$tmp_date"/dir
      }
    fi
    # 文件
    if [[ -f "$i" ]]; then
      if echo "$White_List_Expand" | grep -qw "$i"; then
        print_pd_white_list "$i" "白名单FILE: $i"
        continue
      fi
      rm -rf "$i" && {
        ((FILE++))
        logd "[rm] --黑名单FILE: $i"
        echo "$FILE" >"$tmp_date"/file
      }
    fi
  done
}

#拉起子sh进程
. "$MODDIR/clear_the_blacklist_functions.sh"

#读取配置文件
conf="$black_and_white_list_path"/定时任务/定时设置.ini
if [[ -f $conf ]]; then
  if ! . "$conf"; then
    logd "- [!]: 文件读取异常，请审查(设置定时.ini)文件内容！" && exit 1
  fi
else
  logd "- [!]: 缺少$conf文件" && exit 2
fi

#获取配置
if [[ $bigfile_auto_skip == y ]]; then
  skip_mb="$bigfile_mb"
else
  skip_mb=-1
fi

#拉起模组进程
. "$MODDIR/Run_clear_mod.sh"

if [[ "$Screen" == "亮屏" ]]; then
  echo "- 亮屏状态"
  if [[ ! -f $MODDIR/tmp/Screen_on ]]; then
    echo "true" >"$MODDIR"/tmp/Screen_on
    logd "[状态]: [$Screen] 执行"
  fi
  #创建白名单拦截次数记录文件
  [[ ! -d $MODDIR/White_List_File ]] && mkdir -p "$MODDIR"/White_List_File
  #创捷记录文件
  [[ ! -d $MODDIR/tmp/DATE ]] && mkdir -p "$MODDIR"/tmp/DATE
  tmp_date="$MODDIR/tmp/DATE/$(date '+%Y%m%d')"
  #判断是否是新的一天
  if [[ ! -d "$tmp_date" ]]; then
    rm -rf "$MODDIR"/tmp/DATE/ &>/dev/null
    mkdir -p "$tmp_date"
    echo "0" >"$tmp_date"/file
    echo "0" >"$tmp_date"/dir
    log_md_clear
  fi
  FILE="$(cat "$tmp_date"/file)"
  DIR="$(cat "$tmp_date"/dir)"

  White_List_Expand="$(whitelist_wildcard_list)"
  Black_List_Expand="$(blacklist_wildcard_list)"
  # 执行方法
  main_for

  FILE="$(cat "$tmp_date"/file)"
  DIR="$(cat "$tmp_date"/dir)"
  sed -i "/^description=/c description=CROND: [ 今日已清除: $FILE个黑名单文件 | $DIR个黑名单文件夹 ]" "${MODDIR%/script}/module.prop"
else
  echo "- 息屏状态"
  if [[ -f $MODDIR/tmp/Screen_on ]]; then
    rm -rf "$MODDIR"/tmp/Screen_on
    logd "[状态]: [$Screen] 不执行"
  fi
fi
