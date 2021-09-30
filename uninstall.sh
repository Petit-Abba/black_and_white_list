#!/sbin/sh
clear_the_blacklist_dir="/data/media/0/Android/clear_the_blacklist"
if [ -d ${clear_the_blacklist_dir} ]; then
  rm -rf ${clear_the_blacklist_dir}
fi