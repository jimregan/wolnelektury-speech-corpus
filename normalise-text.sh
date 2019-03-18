#!/bin/bash

broad_norm() {
    if [ x$1 != x"" ]
    then
        pushd $1
    fi

    for i in *.txt
    do
        perl ../norm-text.pl $i > tmp
        mv tmp $i
    done

    if [ x$1 != x"" ]
    then
        popd
    fi
}

header_replace() {
    if [ x$1 != x"" ]
    then
        pushd $1
    fi

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

    if [ x$1 != x"" ]
    then
        popd
    fi
}

split_chapters() {
    if [ x$1 != x"" ]
    then
        pushd $1
    fi

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

    if [ x$1 != x"" ]
    then
        popd
    fi
}

additions() {
    if [ x$1 != x"" ]
    then
        pushd $1
    fi

    echo 'Tobie, leniu' >> but-w-butonierce-deszcz.txt
    echo 'Czytał Wiktor Korzeniewski' >> zajac-i-jez.txt
    echo 'Czytał Jacek Rozenek' >> przedwiosnie.txt

    if [ x$1 != x"" ]
    then
        popd
    fi
}

broad_norm text
header_replace text
additions text
split_chapters text