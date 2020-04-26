#!/bin/bash

broad_norm() {
    echo "Stage 1: Broad normalisations"
    for i in brazownicy.txt
    do
        cat $i | perl ../norm-text.pl > $i.tmp
        mv $i.tmp $i
    done
}

prepend_text() {
    fname="$1"
    text="$2"
    mv "$fname" "$fname.bak"
    printf "%b\n" "$text" > "$fname"
    cat "$fname.bak" >> "$fname"
    rm "$fname.bak"
}

remove_line() {
    file="$1"
    line="$2"
    mv "$file" "$file.bak"
    cat "$file.bak" | grep -v "$line" > "$file"
    rm "$file.bak"
}

header_replace() {
    echo "Stage 2: Replace headers"
    for i in brazownicy.txt
    do
        echo "Replacing header in $i"
        perl ../header-replace.pl $i > $i.tmp
        mv $i.tmp $i
    done
}

additions() {
    echo "Stage 3: Final additions"
}

norm_chapters() {
    echo "Stage 4: Add missing chapter word"
    #for i in 
    #do
    #    perl ../norm-roman-by-text.pl $i > $i.tmp
    #    mv $i.tmp $i
    #done
}

split_chapters() {
    echo "Stage 5: Split texts to match audio"
    for i in brazownicy.txt
    do
        echo "Splitting $i"
        perl ../splitter.pl $i
    done
}

remove_unread_lines() {
    echo "Stage 6: add/remove lines to/from split texts"
    # Introductory sentences have no final punctuation, so sentence splitting is per line
    # This doesn't work with this header, so handle here and re-add in the specific norms
    echo 'Koniec wstępu' >> brazownicy.txt-00.txt
    echo 'Czytał Piotr Nader' >> brazownicy.txt-00.txt
    prepend_text brazownicy.txt-01.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział pierwszy\nBrązownicy\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    remove_line brazownicy.txt-02.txt "W odlewarni brązu" 
    remove_line brazownicy.txt-02.txt "(Dzieje jednego dokumentu)" 
    prepend_text brazownicy.txt-02.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział drugi\nW odlewarni brązu\nDzieje jednego dokumentu\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    prepend_text brazownicy.txt-03.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział trzeci"
    remove_line brazownicy.txt-04.txt "Ksawera Deybel"
    prepend_text brazownicy.txt-04.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział czwarty\nKsawera Deybel\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec rozdziału czwartego' >> brazownicy.txt-04.txt
    echo 'Czytał Piotr Nader' >> brazownicy.txt-04.txt
    remove_line brazownicy.txt-05.txt "Literacki list gończy"
    prepend_text brazownicy.txt-05.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział piąty\nLiteracki list gończy\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec rozdziału piątego' >> brazownicy.txt-05.txt
    echo 'Czytał Piotr Nader' >> brazownicy.txt-05.txt
}

text_norm() {
    echo "Stage 7: broad & narrow normalisations"
    ../apply-specific.pl
    for i in *.txt
    do
        cat $i | perl ../apply-broad.pl > $i.bak
        mv $i.bak $i
    done
}

split_sentences() {
    echo "Stage 8: split sentences"
    for i in *.txt
    do
        cat $i | perl ../split-sentence.pl > $i.sent
    done
}

clean_punct() {
    echo "Stage 9: stripping punctuation"
    for i in *.sent
    do
        cat $i | perl ../clean-punctuation.pl > $i.bak
        mv $i.bak $i
    done
}

run_all() {
    if [ x$1 != x"" ]
    then
    echo "changing to $1"
        pushd $1
    fi

    broad_norm
    header_replace
    additions
    norm_chapters
    split_chapters
    remove_unread_lines
    text_norm
    split_sentences
    clean_punct

    if [ x$1 != x"" ]
    then
        popd
    fi
}

if [ x$1 != x"" ]
then
    run_all $1
else
    run_all
fi
