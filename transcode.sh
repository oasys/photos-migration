#!/bin/bash

# transcode video file to HEVC/h.265

set -e

if [[ $# -ne 1 ]]; then
  echo "$0 <file-to-transcode>"
  exit 2
fi

FILE="$1"
OUTFILE="${FILE%.*}.mp4"

CRF=22 # video constant rate factor, lower is better quality
args=(
 -hide_banner
 -preset slow                          # take more cpu to compress
 -map_metadata 0:g                     # copy metadata
 -c:v libx265 -crf "$CRF" -tag:v hvc1  # video options
 -c:a aac -b:a 128k                    # audio options
)

if [ ! -r "$FILE" ] ; then
  echo "Unabled to read input file $FILE"
  exit 2
elif [ -e "$OUTFILE" ] ; then
  echo "Output file $OUTFILE already exists, skipping."
  exit 2
else
  ffmpeg -i "$FILE" "${args[@]}" "$OUTFILE"
fi
