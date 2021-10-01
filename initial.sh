#!/system/bin/sh
MODDIR=${0%/*}
tools_path="$MODDIR/script/bin/tools"
filepath="$MODDIR/script/bin/busybox"
. "${tools_path}/bin.sh"
. "${MODDIR}/script/clear_the_blacklist_functions.sh"
alias crond="${MODDIR}/script/bin/busybox/crond"
alias bash="${MODDIR}/script/bin/busybox/bash"
chmod -R 0777 "${MODDIR}"
logd "初始化完成: [initial.sh]"

if [[ -f ${MODDIR}/script/set_cron.d/root ]]; then
  [[ -f ${MODDIR}/script/cron.d/root ]] && rm -rf ${MODDIR}/script/cron.d/root
  crond -c "${MODDIR}/script/set_cron.d"
  crond_root_file="${MODDIR}/script/set_cron.d/root"
else
  echo "默认: 24H 每隔1分钟运行一次" > ${MODDIR}/print.txt
  echo "*/1 * * * * ${MODDIR}/script/bin/busybox/bash \"${MODDIR}/script/Run_clear.sh\"" > ${MODDIR}/script/cron.d/root
  crond -c "${MODDIR}/script/cron.d"
  crond_root_file="${MODDIR}/script/cron.d/root"
fi

if [[ $(pgrep -f "crond_clear_the_blacklist/script/cron.d" | grep -v grep | wc -l) -ge 1 ]]; then
  basic_Information
  logd "$(cat ${MODDIR}/print_set)"
  logd "开始运行: [${crond_root_file}]"
  logd "------------------------------------------------------------"
elif [[ $(pgrep -f "crond_clear_the_blacklist/script/set_cron.d" | grep -v grep | wc -l) -ge 1 ]]; then
  basic_Information
  logd "$(cat ${MODDIR}/print_set)"
  logd "开始运行: [${crond_root_file}]"
  logd "------------------------------------------------------------"
else
  basic_Information
  logd "运行失败！"
  exit 1
fi

bash ${MODDIR}/script/Run_clear.sh
