#!/usr/bin/perl
# Replace headers that have been read out of order, or otherwise contain unread material

use warnings;
use strict;
use utf8;

open(INPUT, '<', $ARGV[0]) or die "$!";
binmode(STDOUT, ":utf8");
binmode(INPUT, ":utf8");

my %skip_until = (
    'balzac-komedia-ludzka-bank-nucingena.txt' => '^Wiadomo, jak cienkie',
    'fortepian-chopina.txt' => 'Byłem u Ciebie w te dni przedostatnie',
    'boy-swietoszek.txt' => 'Wstęp',
    'wspomnienia-niebieskiego-mundurka.txt' => 'Ze starego kufra',
    'powiesci-fantastyczne-wybor-narzeczonej.txt' => 'Rozdział pierwszy',
    'gloria-victis-gloria-victis.txt' => '(r. 1863)',
    'przygody-tomka-sawyera.txt' => 'Wstęp',
);
my %head_replace = (
    'balzac-komedia-ludzka-bank-nucingena.txt' => "Bank Nucingena\nHonoré Balzac\ntłumaczenie Tadeusz Boy-Żeleński",
    'fortepian-chopina.txt' => "Cyprian Kamil Norwid\nFortepian Chopina",
    'boy-swietoszek.txt' => '',
    'wspomnienia-niebieskiego-mundurka.txt' => "Wiktor Gomulicki\nWspomnienia niebieskiego mundurka\nPamięci Bronisława Dembowskiego, towarzysza lat chłopięcych, urodzonego w Pułtusku, zmarłego w Zakopanem, te wspomnienia dni razem przeżytych poświęcam\nWiktor Gomulicki",
    'powiesci-fantastyczne-wybor-narzeczonej.txt' => "Ernst Teodor Amadeusz Hoffmann\nPowieści fantastyczne\ntłumaczenie Antoni Lange\nWybór narzeczonej\nhistoria, w której zachodzą rozmaite\nnieprawdopodobne przygody",
    'gloria-victis-gloria-victis.txt' => "Eliza Orzeszkowa\nGloria victis",
    'przygody-tomka-sawyera.txt' => "Mark Twain\nPrzygody Tomka Sawyera",
);

if (!exists $skip_until{$ARGV[0]}) {
    die "No skip pattern for $ARGV[0]\n";
}
my $skipstop = $skip_until{$ARGV[0]};

my $reading = 0;

while(<INPUT>) {
    chomp;
    if(/$skipstop/) {
        $reading = 1;
        print "$head_replace{$ARGV[0]}\n";
        print "$_\n";
    } else {
        if($reading) {
            print "$_\n";
       }
    }
}

