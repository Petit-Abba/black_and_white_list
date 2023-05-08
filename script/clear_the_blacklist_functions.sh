#这个是主log
logd() {
  echo "[$(date '+%g/%m/%d %H:%M')] | $*" >>"$log"
}

#这个用来清空log文件
logd_clear() {
  echo "[$(date '+%g/%m/%d %H:%M')] | $*" >"$log"
}

#判断是新的一天的时候执行
log_md_clear() {
  [[ -f "$MODDIR/set_cron.d/root" ]] && root_file_dir="$MODDIR/set_cron.d"
  logd_clear "新的一天~: [$(date +'%m/%d') 重置记录]"
  basic_Information
  logd "$(cat "${MODDIR%script}"/print_set)"
  logd "正常运行: [$root_file_dir/root]"
  logd "------------------------------------------------------------"
  logd " "
  logd "当前状态: ${Screen}"
}

#重新定时时调用
log_md_set_cron_clear() {
  logd_clear "重设定时 [定时设置.ini]"
  basic_Information
  logd "开始运行: [$cron_d_path/root]"
  logd "------------------------------------------------------------"
  logd " "
  logd "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  logd "┃$logd_ini"
  logd "┃定时设置 | $crond_rule"
  logd "┃内容解读 | $print_set"
  logd "┃杀死上次定时 | pid: $clear_the_blacklist_crond_pid_1"
  logd "┃定时启动成功 | pid: $clear_the_blacklist_crond_pid_2"
  logd "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  logd " "
}

#log信息
basic_Information() {
  logd "品牌: $(getprop ro.product.brand)"
  logd "型号: $(getprop ro.product.model)"
  logd "代号: $(getprop ro.product.device)"
  logd "安卓: $(getprop ro.build.version.release)"
}

#检测关键文件
#赋权才能正常运行
black_and_white_list_path="/data/media/0/Android/clear_the_blacklist"
chmod -R 0777 "$black_and_white_list_path"
if [[ ! -d "$black_and_white_list_path" ]]; then
  echo "- 模块Android目录不存在！"
  exit 88
fi

#读取文件
Black_List="$black_and_white_list_path/黑名单.prop"
White_List="$black_and_white_list_path/白名单.prop"

#配置log文件路径
log="$black_and_white_list_path/log.md"

#检测屏幕状态
Screen_status="$(dumpsys window policy | grep 'mInputRestricted' | cut -d= -f2)"
if [[ "$Screen_status" != "true" ]]; then
  Screen="亮屏"
else
  Screen="息屏"
fi
