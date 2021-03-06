#!/bin/bash

HELP_MESSAGE() {
	local EXIT_CODE="${1:-0}"
	cat <<EOF
Usage: $(basename -- "$0") [OPTIONS] [--] FILE...
Display an image of a font file.

  -h		Show this help message.
  -t TEXT	Show TEXT instead of default.
  --		Terminate options list.

Copyright (C) 2015-2017 Dan Church.
License GPLv3+: GNU GPL version 3 or later (http://gnu.org/licenses/gpl.html).
This is free software: you are free to change and redistribute it. There is NO
WARRANTY, to the extent permitted by law.
EOF
	exit "$EXIT_CODE"
}

TEXT=''

while getopts 't:h' flag; do
	case "$flag" in
		'h')
			HELP_MESSAGE 0
			;;
		't')
			TEXT="$OPTARG"
			;;
		*)
			HELP_MESSAGE 1
			;;
	esac
done

shift "$((OPTIND-1))"

if [[ $# -eq 0 ]]; then
	HELP_MESSAGE 2
fi

TEMP_FILES=()

cleanup() {
	rm -rf -- "${TEMP_FILES[@]}"
}

trap 'cleanup'	EXIT

fontimage_args=()

if [[ -n "$TEXT" ]]; then
	fontimage_args+=(--text "$TEXT")
fi

temp_dir="$(mktemp -d -t "$(basename -- "$0").XXXXXX")"
TEMP_FILES+=("$temp_dir")

for fn; do
	# XXX : fontimage requires .png extension
	temp="$temp_dir/fontimage-$(basename -- "$fn").png"
	fontimage "${fontimage_args[@]}" -o "$temp" "$fn" || exit
done

xv "$temp_dir"/*.png
