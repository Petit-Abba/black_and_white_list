# 跳过白名单次数判断
print_pd_white_list() {
  white_file="$MODDIR/White_List_File/$(echo "$1" | sed 's/\///g').ini"
  if [[ ! -e "$white_file" ]]; then
    echo "1" >"$white_file"
    logd "[continue] -[$(cat "$white_file")]- $2"
  else
    # 小于3次则打印
    white_files="$(cat "$white_file")"
    if [[ "$white_files" -lt "3" ]]; then
      echo "$((white_files + 1))" >"$white_file"
      logd "[continue] -[$(cat "$white_file")]- $2"
    fi
  fi
}

# 小米应用商店文件夹判断
com_xiaomi_market() {
  if echo "$1" | grep -qw "com.xiaomi.market"; then
    if [[ "$(find "$1" -name "*.apk")" != "" ]]; then
      logd "存在APK: $1"
      return 2
    fi
  fi
}

# 白名单列表通配符拓展
whitelist_wildcard_list() {
  local IFS=$'\n'
  for wh in $(grep -v '#' <"$White_List"); do
    if [[ -n "$wh" ]]; then
      echo "$wh"
    fi
  done
}

# 黑名单列表通配符拓展
blacklist_wildcard_list() {
  local IFS=$'\n'
  grep -v '#' <"$Black_List" | while read -r bl; do
    if [[ "${bl: -2}" == "/*" ]]; then
      logd "检测到/*，请替换成/&*"
      logd "[pass] -跳过：$bl"
      continue
    fi
    #把/&*替换成/*
    if [[ "${bl: -2}" == "&*" ]]; then
      bl=${bl//\/&\*/\/\*}
    fi
    if [[ -n "$bl" ]]; then
      if [[ $skip_mb != -1 ]]; then
        big=$(find $bl -size +"$skip_mb"M 2>/dev/null)
        if [[ $big != "" ]] && [[ -d $bl ]]; then
          if [[ "${bl: -1}" == "/" ]]; then
            bl="$bl*"
          elif [[ "${bl: -1}" != "*" ]]; then
            bl="$bl/*"
          fi
        fi
      fi
      for i in $bl; do
        if [[ $i == "$big" ]]; then
          logd "[big] -跳过：$i"
          continue
        else
          echo "$i"
        fi
      done
    fi
  done
}
