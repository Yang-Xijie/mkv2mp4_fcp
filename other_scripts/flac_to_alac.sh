#!/bin/zsh

# - Summary
#   Convert FLAC(.flac) to ALAC(.m4a)
# - Discussion
#   Use `brew install ffmpeg` to install `ffmpeg`.
#   Convert all flac files in and under the current path.
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