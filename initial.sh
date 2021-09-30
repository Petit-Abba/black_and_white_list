#!/system/bin/sh
MODDIR=${0%/*}
. ${MODDIR}/script/clear_the_blacklist_functions.sh
alias crond="$(magisk --path)/.magisk/busybox/crond"
logd "初始化完成: [initial.sh]"
logd "品牌: $(getprop ro.product.brand)"
logd "型号: $(getprop ro.product.model)"
logd "代号: $(getprop ro.product.device)"
logd "安卓: $(getprop ro.build.version.release)"
if [[ -f ${MODDIR}/script/set_cron.d/root ]]; then
  [[ -f ${MODDIR}/script/cron.d/root ]] && rm -rf ${MODDIR}/script/cron.d/root
  crond -c "${MODDIR}/script/set_cron.d"
  crond_root_file="${MODDIR}/script/tmp/set_cron.d/root"
else
  echo "* * * * * ${MODDIR}/script/bin/bash \"${MODDIR}/script/Run_clear.sh\"" > ${MODDIR}/script/cron.d/root
  crond -c "${MODDIR}/script/cron.d"
  crond_root_file="${MODDIR}/script/cron.d/root"
fi
logd "开始运行: [${crond_root_file}]"
logd "------------------------------------------------------------"
sh ${MODDIR}/script/Run_clear.sh &
exit 0
