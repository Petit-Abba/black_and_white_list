#!/system/bin/sh
MODDIR=${0%/*}
tools_path="$MODDIR/script/bin/tools"
filepath="$MODDIR/script/bin/busybox"
. ${tools_path}/bin.sh
. ${MODDIR}/script/clear_the_blacklist_functions.sh
alias crond="${filepath}/crond"
logd "初始化完成: [initial.sh]"
logd "品牌: $(getprop ro.product.brand)"
logd "型号: $(getprop ro.product.model)"
logd "代号: $(getprop ro.product.device)"
logd "安卓: $(getprop ro.build.version.release)"
logd "开启运行: [${MODDIR}/script/cron.d/root]"
logd "------------------------------------------------------------"
echo "# crond run script" > ${MODDIR}/script/cron.d/root
echo "* * * * * ${filepath}/bash \"${MODDIR}/script/Run_clear.sh\"" >> ${MODDIR}/script/cron.d/root
crond -c "$MODDIR/script/cron.d"
