#!/usr/bin/env zsh

# - Summary
#   Convert BDMV anime (with m2ts format, track 0 H264/AVC, track 1 PCM)
#   to mov in order to make it importable to FCP without recoding.
# - Discussion
#   On macOS 11.1 Big Sur, with FCP 10.5
#   Use `brew install ffmpeg` to install `ffmpeg`.
#   Download `MediaInfo.app` to check file (.m2ts) info.
# - Note
#   To see `.m2ts` files in `BDMV`, use `right click`->`Show Package Contents` on `BDMV`.
# - Author
#   Yang-Xijie
#   https://github.com/Yang-Xijie

i=1 # counter

for anime in **/*.m2ts {
  echo "===== [$i] START $anime ====="

  ffmpeg -i "$anime" -map 0:0 -map 0:1 -vcodec copy -acodec alac "${anime%.*}.mov"
  # `-map 0:0` refers to the video track while `-map 0:1` refers to the audio track

  echo "===== [$i] DONE! =====\n\n"
  let i=$i+1
}

echo "ALL DONE!\n"
