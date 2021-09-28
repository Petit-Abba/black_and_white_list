SKIPUNZIP=0

MyPrint() {
  echo "$@"
  sleep 0.05
}

get_choose() {
  local choose
  local branch
  while :; do
    choose="$(getevent -qlc 1 | awk '{ print $3 }')"
    case "$choose" in
    KEY_VOLUMEUP)  branch="0" ;;
    KEY_VOLUMEDOWN)  branch="1" ;;
    *)  continue ;;
    esac
    echo "$branch"
    break
  done
}

case ${ARCH} in
  arm64*)
    [[ ${API} -lt 28 ]] && abort "- 设备Android $(getprop ro.build.version.release)版本过低 请升级至Android 9+"
    MyPrint "- 设备支持"
    MyPrint "- 架构: ${ARCH}"
    MyPrint "- 安卓: $(getprop ro.build.version.release)"
    ;;
  *)  abort "- 不支持的架构: ${ARCH}"
esac

MyPrint "------------------------------------------------------------"
MyPrint "- [&]请先阅读 避免一些不必要的问题"
MyPrint "------------------------------------------------------------"
MyPrint " "
MyPrint "- 1.模块刷入重启后，只在用户解锁设备才开始生效。"
MyPrint "- 2.使用crond定时命令，不会浪费或占用系统资源。"
MyPrint "- 3.模块自定义路径: /sdcard/Android/clear_the_blacklist/"
MyPrint " "
MyPrint "- ps: 只要你手机开机，只要你使用任何软件，设备本身就已经开始进"
MyPrint "行各种频繁读写，如果你认为该模块会损耗设备闪存，那么请按音量-。"
MyPrint " "
MyPrint "- https://github.com/Petit-Abba/crond_clear_the_blacklist"
MyPrint " "
MyPrint "------------------------------------------------------------"
MyPrint " "
MyPrint "- 是否安装？(请选择)"
MyPrint "- 按音量键＋: 安装 √"
MyPrint "- 按音量键－: 退出 ×"
if [[ $(get_choose) = 0 ]]; then
  black_and_white_list_path="/sdcard/Android/clear_the_blacklist"
  Black_List="${black_and_white_list_path}/黑名单.prop"
  White_List="${black_and_white_list_path}/白名单.prop"
  [[ ! -d ${black_and_white_list_path} ]] && mkdir -p ${black_and_white_list_path}
  [[ ! -f ${Black_List} ]] && cp -r ${MODPATH}/files/黑名单.prop ${black_and_white_list_path}/
  [[ ! -f ${White_List} ]] && cp -r ${MODPATH}/files/白名单.prop ${black_and_white_list_path}/
  rm -rf ${MODPATH}/files/
  if [[ "$(pm list package | grep -w 'com.coolapk.market')" != "" ]];then
    MyPrint " "
    MyPrint "- 你安装了酷安 是否前往作者主页？(请选择)"
    MyPrint "- 按音量键＋: “我来啦”"
    MyPrint "- 按音量键－: “爷不去”"
    if [[ $(get_choose) = 0 ]]; then
      am start -d 'coolmarket://u/1132618' >/dev/null 2>&1
      MyPrint "- “🌚看什么看？没见过阿巴，阿巴阿巴？”"
      MyPrint " "
    else
      MyPrint "- “😭你一定会回来的”"
      MyPrint " "
    fi
  fi
else
  abort "- 已选择退出"
fi
