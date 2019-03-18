#!/bin/bash

broad_norm() {
    for i in *.txt
    do
        perl ../norm-text.pl $i > tmp
        mv tmp $i
    done
}

header_replace() {
    for i in balzac-komedia-ludzka-bank-nucingena.txt fortepian-chopina.txt \
        boy-swietoszek.txt wspomnienia-niebieskiego-mundurka.txt \
        powiesci-fantastyczne-wybor-narzeczonej.txt \
        gloria-victis-gloria-victis.txt przygody-tomka-sawyera.txt \
        ballada-z-tamtej-strony-imieniny.txt przedwiosnie.txt \
        piesn-o-rolandzie.txt
    do
        perl ../header-replace.pl $i > tmp
        mv tmp $i
    done
}

split_chapters() {
    for i in balzac-komedia-ludzka-corka-ewy.txt \
        boy-swietoszek.txt \
        golem.txt \
        kim.txt \
        piesn-o-rolandzie.txt \
        powiesci-fantastyczne-wybor-narzeczonej.txt \
        przedwiosnie.txt \
        przygody-tomka-sawyera.txt \
        robinson-crusoe.txt \
        sztuka-kochania.txt \
        wspomnienia-niebieskiego-mundurka.txt \
        wyspa-skarbow.txt
    do
        perl ../splitter.pl $i > tmp
        mv tmp $i
    done
}

norm_chapters() {
    for i in wyspa-skarbow.txt wspomnienia-niebieskiego-mundurka.txt
    do
        perl ../norm-roman-by-text.pl $i > tmp
        mv tmp $i
    done
}

additions() {
    echo 'Tobie, leniu' >> but-w-butonierce-deszcz.txt
    echo 'Czytał Wiktor Korzeniewski' >> zajac-i-jez.txt
    echo 'Czytał Jacek Rozenek' >> przedwiosnie.txt
}

run_all() {
    if [ x$1 != x"" ]
    then
        pushd $1
    fi

    broad_norm
    header_replace
    additions
    norm_chapters
    split_chapters

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