#!/bin/zsh

# - Summary
#   Convert FLAC(.flac) to ALAC(.m4a)
# - Discussion
#   Convert all flac files in and in the subFolder of current path.
# - Author
#   Yang-Xijie
#   https://github.com/Yang-Xijie

turn=1 # counter

for song in **/*.flac; do
  echo "=====" "[""$turn""]""START" "$song" "====="

  ffmpeg -i "$song" -vcodec copy -acodec alac "${song%.*}.m4a"

  echo "=====" "[""$turn""]""DONE!" "$song" "=====\n\n"
  let turn=$turn+1
done

echo "ALL DONE!\n"