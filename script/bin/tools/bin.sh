
[[ ${tools_path} = "" ]] && exit 2
[[ ${filepath} = "" ]] && exit 3
exclude="bin.sh"
rm_busyPATH() {
	[[ ! -d $filepath ]] && mkdir -p "$filepath"
	[[ ! -e $tools_path/busybox_path ]] && touch "$tools_path/busybox_path"
	if [[ $filepath != $(cat "$tools_path/busybox_path") ]]; then
		[[ -d $(cat "$tools_path/busybox_path") ]] && rm -rf "$(cat "$tools_path/busybox_path")"
		echo "$filepath" > "$tools_path/busybox_path"
	fi
}
rm_busyPATH
if [[ -d $tools_path ]]; then
	[[ ! -e $tools_path/busybox ]] && exit 4
	busybox="$filepath/busybox"
	if [[ -e $busybox ]]; then
		filemd5="$(md5sum "$busybox" | cut -d" " -f1)"
		filemd5_1="$(md5sum "$tools_path/busybox" | cut -d" " -f1)"
		if [[ $filemd5 != $filemd5_1 ]]; then
			rm -rf "$filepath" && rm_busyPATH
		fi
	fi
	ls -a "$tools_path" | sed -r '/^\.{1,2}$/d' | egrep -v "$(echo $exclude | sed 's/ /\|/g')" | while read i; do
		[[ ! -d $tools_path/$i ]] && {
		if [[ ! -e $filepath/$i ]]; then
			cp -r "$tools_path/$i" "$filepath"
			chmod 0777 "$filepath/$i"
			echo "$i > $filepath/$i"
			if [[ $i = busybox ]]; then
				rm_busyPATH
				"$busybox" --list | while read a; do
					[[ $a != date && ! -e $filepath/$a ]] && ln -s "$busybox" "$filepath/$a"
				done
			fi
		else
			"$busybox" --list | while read a; do
				[[ $a != date && ! -e $filepath/$a ]] && ln -s "$busybox" "$filepath/$a"
			done
			filemd5="$(md5sum "$filepath/$i" | cut -d" " -f1)"
			filemd5_1="$(md5sum "$tools_path/$i" | cut -d" " -f1)"
			if [[ $filemd5 != $filemd5_1 ]]; then
				rm -rf "$filepath/$i"
				cp -r "$tools_path/$i" "$filepath"
				chmod 0777 "$filepath/$i"
				echo "$i > $filepath/$i"
			fi
		fi
		}
	done
else
	exit 5
fi
[[ ! -e $busybox ]] && exit 6
export PATH="$filepath:/system_ext/bin:/system/bin:/system/xbin:/vendor/bin:/vendor/xbin"
unset LD_LIBRARY_PATH LD_PRELOAD
