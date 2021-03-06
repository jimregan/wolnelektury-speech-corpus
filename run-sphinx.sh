LMPLZ=/home/git/kenlm/bin/lmplz.exe
#TMPPATH=/tmp/conv

a=$1
t=$2

#$LMPLZ -o 3 --prune 0 0 0 --text "$t" --arpa /tmp/conv/$t.arpa
$LMPLZ -o 3 --prune 0 0 0  --discount_fallback --text "$t" --arpa /tmp/conv/$t.arpa
sphinx_lm_convert -i /tmp/conv/$t.arpa -o /tmp/conv/$t.bin
base=$(basename "$a" ".wav")
sox "$a" -r 16000 -c 1 "$base.wav"
cat $t |tr ' ' '\n'|perl filter-dict.pl ~/cmusphinx-clarinpl/pl.dic|sort|uniq > $t.wl
~/g2p/g2p.py -m ~/g2p/pl-train/model-6 -e utf-8 -a $t.wl > /tmp/conv/$t.g2p
cat /tmp/conv/$t.g2p | tr '\t' ' ' > /tmp/conv/$t.g2ps
cat ~/cmusphinx-clarinpl/pl.dic /tmp/conv/$t.g2ps > /tmp/conv/$t.dic
printf "$base\t$base.wav\n" > /tmp/conv/fileids
pocketsphinx_batch.exe -adcin yes -remove_silence no -cepdir . -cepext .wav -ctl /tmp/conv/fileids -dict /tmp/conv/$t.dic -hmm ~/cmusphinx-clarinpl/ -lm /tmp/conv/$t.bin -ctm $a.3.ctm

rm "$base.wav"
