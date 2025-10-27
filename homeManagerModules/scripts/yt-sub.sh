#!/bin/bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <youtube-url>" >&2
	exit 1
fi

URL=$1

# Check if yt-dlp is installed
if ! command -v yt-dlp &>/dev/null; then
	echo "Error: yt-dlp is required but not installed" >&2
	exit 1
fi

initialize_temp() {
	tempdir=$(mktemp -d)
	trap 'rm -rf "$tempdir"' EXIT
	cd "$tempdir"
}

download_sub() {
	# downloads subtitles
	yt-dlp \
		--write-sub \
		--write-auto-sub \
		--sub-lang "en.*" \
		--skip-download \
		--convert-subs srt \
		"$URL" >/dev/null 2>&1

	SRT_FILE=$(find . -type f -iname "*.srt" | head -n 1)
	if [ ! -f "$SRT_FILE" ]; then
		echo "❌ No subtitles found for this video." >&2
		exit 2
	fi

	# Clean up the subtitles
	awk '
  {
    gsub(/\r/, "")
  }
  !/^[0-9]+$|-->|^$/ && !a[$0]++
  ' "$SRT_FILE"
}

initialize_temp
download_sub
