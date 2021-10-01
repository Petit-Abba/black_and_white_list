
logd() {
  echo "[$(date '+%g/%m/%d %H:%M')] | $@" >> ${log}
}

logd_clear() {
  echo "[$(date '+%g/%m/%d %H:%M')] | $@" > ${log}
}

log_md_clear() {
  logd_clear "清除旧日志: [log.md]"
  basic_Information
  logd "------------------------------------------------------------"
}

log_md_set_cron_clear() {
  logd_clear "重设定时 [定时设置.ini]"
  basic_Information
  logd "开始运行: [${cron_d_path}/root]"
  logd "------------------------------------------------------------"
  logd " "
  logd "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  logd "┃${logd_ini}"
  logd "┃定时设置 | ${crond_rule}"
  logd "┃内容解读 | ${print_set}"
  logd "┃杀死上次定时 | pid: ${clear_the_blacklist_crond_pid_1}"
  logd "┃定时启动成功 | pid: ${clear_the_blacklist_crond_pid_2}"
  logd "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  logd " "
}

basic_Information() {
  logd "品牌: $(getprop ro.product.brand)"
  logd "型号: $(getprop ro.product.model)"
  logd "代号: $(getprop ro.product.device)"
  logd "安卓: $(getprop ro.build.version.release)"
}

black_and_white_list_path="/sdcard/Android/clear_the_blacklist"
[[ ! -d ${black_and_white_list_path} ]] && echo "- 模块Android目录不存在！" && exit 88
Black_List="${black_and_white_list_path}/黑名单.prop"
White_List="${black_and_white_list_path}/白名单.prop"
log="${black_and_white_list_path}/log.md"
Screen_status="$(dumpsys window policy | grep 'mInputRestricted' | cut -d= -f2)"
[[ "${Screen_status}" != "true" ]] && Screen="亮屏" || Screen="息屏"
