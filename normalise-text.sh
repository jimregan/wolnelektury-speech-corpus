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
    pushd text
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
    popd
}