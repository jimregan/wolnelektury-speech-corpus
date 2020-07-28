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
    for i in brazownicy.txt widziadla_prus.txt
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
    #brazownicy_lines=$(wc -l brazownicy.txt-00.txt|awk '{print $1}')
    #head -n $(($brazownicy_lines - 2)) > tmp && mv tmp brazownicy.txt-00.txt
    echo 'Koniec wstępu' >> brazownicy.txt-00.txt
    echo 'Czytał Piotr Nater' >> brazownicy.txt-00.txt
    prepend_text brazownicy.txt-01.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział pierwszy\nBrązownicy\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    remove_line brazownicy.txt-02.txt "W odlewarni brązu" 
    remove_line brazownicy.txt-02.txt "(Dzieje jednego dokumentu)" 
    prepend_text brazownicy.txt-02.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział drugi\nW odlewarni brązu\nDzieje jednego dokumentu\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec rozdziału drugiego' >> brazownicy.txt-02.txt
    echo 'Czytał Piotr Nater' >> brazownicy.txt-02.txt
    prepend_text brazownicy.txt-03.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział trzeci"
    echo 'Koniec rozdziału trzeciego' >> brazownicy.txt-03.txt
    echo 'Czytał Piotr Nater' >> brazownicy.txt-03.txt
    remove_line brazownicy.txt-04.txt "Ksawera Deybel"
    prepend_text brazownicy.txt-04.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział czwarty\nKsawera Deybel\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec rozdziału czwartego' >> brazownicy.txt-04.txt
    echo 'Czytał Piotr Nater' >> brazownicy.txt-04.txt
    remove_line brazownicy.txt-05.txt "Literacki list gończy"
    prepend_text brazownicy.txt-05.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział piąty\nLiteracki list gończy\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec rozdziału piątego' >> brazownicy.txt-05.txt
    echo 'Czytał Piotr Nater' >> brazownicy.txt-05.txt
    remove_line brazownicy.txt-06.txt "Sfinks towianizmu"
    prepend_text brazownicy.txt-06.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział szósty\nSfinks towianizmu\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec rozdziału szóstego' >> brazownicy.txt-06.txt
    echo 'Czytał Piotr Nater' >> brazownicy.txt-06.txt
    remove_line brazownicy.txt-07.txt "Mrok się przeciera"
    prepend_text brazownicy.txt-07.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział siódmy\nMrok się przeciera\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec rozdziału siódmego' >> brazownicy.txt-07.txt
    echo 'Czytał Piotr Nater' >> brazownicy.txt-07.txt
    remove_line brazownicy.txt-08.txt "Sprawa Karoliny — Sprawa Boża"
    prepend_text brazownicy.txt-08.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział ósmy\nSprawa Karoliny — Sprawa Boża\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec rozdziału ósmego' >> brazownicy.txt-08.txt
    echo 'Czytał Piotr Nater' >> brazownicy.txt-08.txt
    remove_line brazownicy.txt-09.txt "Zaręczyny Adama Mickiewicza"
    prepend_text brazownicy.txt-09.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział dziewiąty\nZaręczyny Adama Mickiewicza\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec rozdziału dziewiątego' >> brazownicy.txt-09.txt
    echo 'Czytał Piotr Nater' >> brazownicy.txt-09.txt
    remove_line brazownicy.txt-10.txt "Drogi geniuszu"
    prepend_text brazownicy.txt-10.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział dziesiąty\nDrogi geniuszu\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec rozdziału dziesiątego' >> brazownicy.txt-10.txt
    echo 'Czytał Piotr Nater' >> brazownicy.txt-10.txt
    remove_line brazownicy.txt-11.txt "Advocatus diaboli"
    prepend_text brazownicy.txt-11.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział jedenasty\nAdvocatus diaboli\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec rozdziału jedenastego' >> brazownicy.txt-11.txt
    echo 'Czytał Piotr Nater' >> brazownicy.txt-11.txt
    remove_line brazownicy.txt-12.txt "Przypisy"
    prepend_text brazownicy.txt-12.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział dwunasty\nPrzypisy, część pierwsza\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec rozdziału dwunastego' >> brazownicy.txt-12.txt
    echo 'Czytał Piotr Nater' >> brazownicy.txt-12.txt
    prepend_text brazownicy.txt-13.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział trzynasty\nPrzypisy, część druga\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec rozdziału trzynastego' >> brazownicy.txt-13.txt
    echo 'Czytał Piotr Nater' >> brazownicy.txt-13.txt
    remove_line brazownicy.txt-14.txt "Pamiętnik Zofii Szymanowskiej"
    prepend_text brazownicy.txt-14.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział czternasty\nPamiętnik Zofii Szymanowskiej, część pierwsza\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec rozdziału czternastego' >> brazownicy.txt-14.txt
    echo 'Czytał Piotr Nater' >> brazownicy.txt-14.txt
    prepend_text brazownicy.txt-15.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział piętnasty\nPamiętnik Zofii Szymanowskiej, część druga\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec rozdziału piętnastego' >> brazownicy.txt-15.txt
    echo 'Czytał Piotr Nater' >> brazownicy.txt-15.txt
    prepend_text brazownicy.txt-16.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział szesnasty\nPamiętnik Zofii Szymanowskiej, część trzecia\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec rozdziału szesnastego' >> brazownicy.txt-16.txt
    echo 'Czytał Piotr Nater' >> brazownicy.txt-16.txt
    prepend_text brazownicy.txt-17.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział siedemnasty\nPamiętnik Zofii Szymanowskiej, część czwarta\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec rozdziału siedemnastego' >> brazownicy.txt-17.txt
    echo 'Czytał Piotr Nater' >> brazownicy.txt-17.txt
    prepend_text brazownicy.txt-18.txt "Tadeusz Boy-Żeleński\nBrązownicy\nRozdział osiemnasty\nPamiętnik Zofii Szymanowskiej, część piąta\nTo nagranie Legamus może być kopiowane i rozpowszechniane bez ograniczeń"
    echo 'Koniec brązowników, Tadeusza Boya-Żeleńskiego' >> brazownicy.txt-18.txt
    echo 'Więcej informacji o nagraniach lub wolontariacie na stronie legamus kropka e u' >> brazownicy.txt-18.txt
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
