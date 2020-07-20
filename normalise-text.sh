#!/bin/bash

broad_norm() {
    echo "Stage 1: Broad normalisations"
    for i in *.txt
    do
        cat $i | perl ../norm-text.pl > $i.tmp
        mv $i.tmp $i
    done
}

slowka_headers() {
    for i in slowka-zbior-*txt
    do 
        if [ $i != "slowka-zbior-slowka.txt" ]
        then 
            lines=$(wc -l $i|awk '{print $1}')
	    tail -n $(($lines - 3)) $i > $i.tmp
            mv $i.tmp $i
        fi
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

check_truncation() {
    stage=$1
    zero=$(find . -name '*.txt' -size 0|wc -l|awk '{print $1}')
    if [ $zero -eq 0 ]; then
        echo "Truncation at stage $stage"
        exit
    fi
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
    slowka_headers
    for i in bajki-i-przypowiesci-dwa-zolwie.txt \
ballada-z-tamtej-strony-imieniny.txt \
balzac-komedia-ludzka-bank-nucingena.txt \
balzac-komedia-ludzka-jaszczur.txt \
balzac-komedia-ludzka-kobieta-porzucona.txt \
balzac-komedia-ludzka-kobieta-trzydziestoletnia.txt \
boy-swietoszek.txt \
brazownicy.txt \
but-w-butonierce-marsz.txt \
don-kichot-z-la-manchy.txt \
fortepian-chopina.txt \
gloria-victis-gloria-victis.txt \
ksiega-dzungli.txt \
ojciec-goriot.txt \
piesn-o-rolandzie.txt \
powiesci-fantastyczne-kawaler-gluck.txt \
powiesci-fantastyczne-wybor-narzeczonej.txt \
przedwiosnie.txt \
przygody-tomka-sawyera.txt \
spowiedz-dzieciecia-wieku.txt \
wspomnienia-niebieskiego-mundurka.txt
    do
        echo "Replacing header in $i"
        perl ../header-replace.pl $i > $i.tmp
        mv $i.tmp $i
    done
}

additions() {
    echo "Stage 3: Final additions"
    echo 'Tobie, leniu' >> but-w-butonierce-deszcz.txt
    echo 'Czytał Wiktor Korzeniewski' >> zajac-i-jez.txt
    echo 'Czytał Wiktor Korzeniewski' >> balzac-komedia-ludzka-eugenia-grandet.txt
    echo 'Czytał Wiktor Korzeniewski' >> balzac-komedia-ludzka-male-niedole-pozycia-malzenskiego.txt
    echo 'Czytał Wiktor Korzeniewski' >> don-kichot-z-la-manchy.txt
    echo 'Czytał Wiktor Korzeniewski' >> balzac-komedia-ludzka-jaszczur.txt-22.txt
    echo 'Czytał Jacek Rozenek' >> przedwiosnie.txt
    echo 'Czytał Jacek Rozenek' >> bartek-zwyciezca.txt
    echo 'Czytała Joanna Domańska' >> balzac-komedia-ludzka-kobieta-porzucona.txt
    echo 'Czytała Joanna Domańska' >> balzac-komedia-ludzka-kobieta-trzydziestoletnia.txt
    echo 'Czytała Joanna Domańska' >> chlopi-czesc-pierwsza-jesien.txt
    echo 'Czytała Joanna Domańska' >> balzac-komedia-ludzka-muza-z-zascianka.txt
    echo 'Czytała Joanna Domańska' >> balzac-komedia-ludzka-bank-nucingena.txt
    echo 'Czytała Joanna Domańska' >> balzac-komedia-ludzka-gobseck.txt
    echo 'Czytał Jan Peszek' >> cierpienia-mlodego-wertera.txt
    echo 'Czytał Jan Peszek' >> antek.txt
    echo 'Czytała Danuta Stenka' >> gloria-victis-dziwna-historia.txt
    #echo 'Czytał Adam Fidusiewicz' >> pasewicz-dolina-wilda-w-starym-stylu.txt
    #echo 'Wolne Lektury p l' >> pasewicz-dolina-wilda-w-starym-stylu.txt
    #echo 'Zostań naszym Przyjacielem' >> pasewicz-dolina-wilda-w-starym-stylu.txt
}

norm_chapters() {
    echo "Stage 4: Add missing chapter word"
    for i in wyspa-skarbow.txt wspomnienia-niebieskiego-mundurka.txt \
        z-wichrow-i-hal-z-tatr-krzak-dzikiej-rozy-w-ciemnych-smreczy.txt \
        fortepian-chopina.txt bartek-zwyciezca.txt \
        chlopi-czesc-pierwsza-jesien.txt \
	sztuka-kochania.txt \
        lange-miranda.txt
    do
        perl ../norm-roman-by-text.pl $i > $i.tmp
        mv $i.tmp $i
    done
}

split_chapters() {
    echo "Stage 5: Split texts to match audio"
    for i in balzac-komedia-ludzka-corka-ewy.txt \
        balzac-komedia-ludzka-eugenia-grandet.txt \
        balzac-komedia-ludzka-jaszczur.txt \
        balzac-komedia-ludzka-kobieta-trzydziestoletnia.txt \
        balzac-komedia-ludzka-male-niedole-pozycia-malzenskiego.txt \
        balzac-komedia-ludzka-muza-z-zascianka.txt \
        bartek-zwyciezca.txt \
        boy-swietoszek.txt \
        brazownicy.txt \
        chlopi-czesc-pierwsza-jesien.txt \
        cierpienia-mlodego-wertera.txt \
        don-kichot-z-la-manchy.txt \
        gloria-victis-dziwna-historia.txt \
        golem.txt \
        grabinski-namietnosc.txt \
        historia-zoltej-cizemki.txt \
        hoffmann-dziadek-do-orzechow.txt \
        kim.txt \
        ksiega-dzungli.txt \
        lange-miranda.txt \
        ojciec-goriot.txt \
        pan-tadeusz.txt \
        pierscien-i-roza.txt \
        piesn-o-rolandzie.txt \
        powiesci-fantastyczne-don-juan.txt \
        powiesci-fantastyczne-piaskun.txt \
        powiesci-fantastyczne-skrzypce-z-cremony.txt \
        powiesci-fantastyczne-wybor-narzeczonej.txt \
        przedwiosnie.txt \
        przygody-tomka-sawyera.txt \
        robinson-crusoe.txt \
        spowiedz-dzieciecia-wieku.txt \
        sztuka-kochania.txt \
        w-pustyni-i-w-puszczy.txt \
        wierna-rzeka.txt \
        wspomnienia-niebieskiego-mundurka.txt \
        wyspa-skarbow.txt
    do
        echo "Splitting $i"
        perl ../splitter.pl $i
    done
}

remove_unread_lines() {
    echo "Stage 6: add/remove lines to/from split texts"
    # Introductory sentences have no final punctuation, so sentence splitting is per line
    # This doesn't work with this header, so handle here and re-add in the specific norms
    remove_line balzac-komedia-ludzka-male-niedole-pozycia-malzenskiego.txt-40.txt '^operowych$'
    remove_line cierpienia-mlodego-wertera.txt-01.txt '^tłumaczenie Franciszek Mirandola$'
    prepend_text cierpienia-mlodego-wertera.txt-02.txt 'Johann Wolfgang von Goethe\nCierpienia młodego Wertera'
    prepend_text ksiega-dzungli.txt-02.txt 'Rudyard Kipling\nKsięga dżungli'
    prepend_text ksiega-dzungli.txt-03.txt 'Rudyard Kipling\nKsięga dżungli'
    prepend_text ksiega-dzungli.txt-04.txt 'Rudyard Kipling\nKsięga dżungli'
    prepend_text ksiega-dzungli.txt-05.txt 'Rudyard Kipling\nKsięga dżungli'
    remove_line wierna-rzeka.txt-03.txt '^IV$'
    prepend_text balzac-komedia-ludzka-muza-z-zascianka.txt-02.txt 'Honoré Balzac'
    remove_line zaglada-domu-usherow.txt '^\(III\|II\|I\|IV\|VI\|V\)$'
    remove_line ballada-z-tamtej-strony-erotyk.txt '^ballada z tamtej strony$'
    remove_line ballada-z-tamtej-strony-melancholia.txt '^ballada z tamtej strony$'
    remove_line ballada-z-tamtej-strony-zdrada.txt '^ballada z tamtej strony$'
    #remove_line pasewicz-dolina-wilda-w-starym-stylu.txt 'Dolna Wilda'
    #brazownicy_lines=$(wc -l brazownicy.txt-00.txt|awk '{print $1}')
    #head -n $(($brazownicy_lines - 2)) > tmp && mv tmp brazownicy.txt-00.txt
    echo 'Pochwała ta upoiła panią de La Baudraye; panu de Clagny, generalnemu poborcy i młodemu Boirouge wydało się, iż jest serdeczniejsza ze Stefanem niż w wilię.' >> balzac-komedia-ludzka-muza-z-zascianka.txt-08.txt
    echo 'Koniec wstępu. Czytał Piotr Nater.' >> brazownicy.txt-00.txt
    echo 'Koniec tomu trzeciego. Czytał Wiktor Korzeniewski.' >> ojciec-goriot.txt-11.txt
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
    check_truncation broad_norm
    header_replace
    check_truncation header_replace
    additions
    check_truncation additions
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
