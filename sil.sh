ffmpeg -i $1 -af silencedetect=noise=-30dB:d=0.5 -f null - 2> silences/$1.sil
