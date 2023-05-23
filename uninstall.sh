clear_the_blacklist_dir="/data/media/0/Android/clear_the_blacklist"
black_and_white_list_path_old="/sdcard/Android/clear_the_blacklist_old"
if [ -d $clear_the_blacklist_dir ]; then
  rm -rf $clear_the_blacklist_dir
elif [ -d $black_and_white_list_path_old ]; then
  rm -rf $black_and_white_list_path_old
fi
