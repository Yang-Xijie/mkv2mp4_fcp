# /bin/zsh

# Read more at my [GitHub](https://github.com/Yang-Xijie/mkv2mp4_fcp)
# Functions: Convert anime(with mkv format, track 0 hevc, track 1 flac) to mp4 to make it importable to FCP without recoding .
# On macOS Big Sur 11.0.1. FCP version 10.5.
# You can use `brew install mkvtoolnix ffmpeg mp4box` to install all tools needed.
# You can use `mkvinfo "$anime"` to get details of mkv files.

turn=1 # counter, make name of intermidiate files short.

# mkv files in the current directory
for anime in *.mkv; do
    echo "START $turn $anime"

    mkvextract tracks "$anime" 0:"$turn"".h265" 1:"$turn"".flac"
    # Firstly, extract tracks from mkv file.
    ffmpeg -i "$turn"".flac" -acodec alac "$turn"".m4a"
    # Secondly, for the audio, change FLAC(Free Lossless Audio Code) to ALAC(Apple Lossless Audio Code), which are both lossless. FLAC is not well compatible with FCP.
    mp4box -add "$turn"".h265" -add "$turn"".m4a" "${anime%.mkv}"".mp4"
    # Then use mp4box to put hevc and alac together in a mp4 format.
    rm "$turn"".h265" "$turn"".flac" "$turn"".m4a"
    # Finally, don't forget to delete intermidiate files.
    # If you want to move files to trash, `brew install trash` and then change "rm" to "trash".

    echo "DONE! ""$turn"
    echo "========================"
    let turn=$turn+1
done

# mkv files in folders in current directory
for anime in **/*.mkv; do
    echo "START $turn $anime"

    mkvextract tracks "$anime" 0:"$turn"".h265" 1:"$turn"".flac"
    ffmpeg -i "$turn"".flac" -acodec alac "$turn"".m4a"
    mp4box -add "$turn"".h265" -add "$turn"".m4a" "${anime%.mkv}"".mp4"
    rm "$turn"".h265" "$turn"".flac" "$turn"".m4a"

    echo "DONE! ""$turn"
    echo "========================"
    let turn=$turn+1
done