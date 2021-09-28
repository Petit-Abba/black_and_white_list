
logd() {
  if [[ "$(echo ${0%*/} | grep 'service.sh')" != "" ]]; then
    echo "[$(date '+%g/%m/%d %H:%M')] | $@" > ${log}
  else
    echo "[$(date '+%g/%m/%d %H:%M')] | $@" >> ${log}
  fi
}

black_and_white_list_path="/sdcard/Android/clear_the_blacklist"
Black_List="${black_and_white_list_path}/黑名单.prop"
White_List="${black_and_white_list_path}/白名单.prop"
log="${black_and_white_list_path}/log.md"
[[ ! -d ${black_and_white_list_path} ]] && mkdir -p ${black_and_white_list_path}
[[ ! -f ${Black_List} ]] && touch ${Black_List}
[[ ! -f ${White_List} ]] && touch ${White_List}
Screen_status="$(dumpsys window policy | grep "mInputRestricted" | cut -d= -f2)"
[[ "${Screen_status}" != "true" ]] && Screen="亮屏" || Screen="息屏"
