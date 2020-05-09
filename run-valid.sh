#!/bin/bash
cat git/pairs.tsv |while read i; do
    m=$(echo "$i"|awk -F'\t' '{print $1}')
    t=$(echo "$i"|awk -F'\t' '{print $2}')
    text=git/text/"$t".sent
    ctm="$m".ctm
    wl="$t".wl
    if [ ! -e "$text" ]; then
        echo "Text missing: $text"
        continue
    fi
    if [ ! -e "$ctm" ]; then
        echo "CTM missing: $ctm"
        continue
    fi
    if [ ! -e "$wl" ]; then
        echo "wordlist missing: $wl"
        continue
    fi
    perl git/validate-wordlists.pl "$ctm" "$text" "$wl"
done