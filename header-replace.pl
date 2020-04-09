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
    'balzac-komedia-ludzka-kobieta-porzucona.txt' => '^W roku 1822, z początkiem wiosny,',
    'fortepian-chopina.txt' => 'Byłem u Ciebie w te dni przedostatnie',
    'boy-swietoszek.txt' => 'Wstęp',
    'wspomnienia-niebieskiego-mundurka.txt' => 'Ze starego kufra',
    'powiesci-fantastyczne-wybor-narzeczonej.txt' => 'Rozdział pierwszy',
    'gloria-victis-gloria-victis.txt' => '(r. 1863)',
    'przygody-tomka-sawyera.txt' => 'Wstęp',
    'ballada-z-tamtej-strony-imieniny.txt' => 'imieniny',
    'przedwiosnie.txt' => 'Panu Konradowi Czarnockiemu',
    'piesn-o-rolandzie.txt' => '^I$',
    'spowiedz-dzieciecia-wieku.txt' => 'Część pierwsza',
    'balzac-komedia-ludzka-jaszczur.txt' => 'Panu Savary Członkowi Akademii Nauk',
    'balzac-komedia-ludzka-kobieta-trzydziestoletnia.txt' => 'I. Pierwsze błędy',
    'bajki-i-przypowiesci-dwa-zolwie.txt' => 'Dwa żółwie',
    'don-kichot-z-la-manchy.txt' => 'Księga pierwsza',
    'ksiega-dzungli.txt' => 'Bracia małego Mauli',
    'ojciec-goriot.txt' => 'Pani Vauquer',
);
my %head_replace = (
    'bajki-i-przypowiesci-dwa-zolwie.txt' => "Ignacy Krasicki\nBajki i przypowieści\nCzęść pierwsza",
    'balzac-komedia-ludzka-bank-nucingena.txt' => "Bank Nucingena\nHonoré Balzac\ntłumaczenie Tadeusz Boy-Żeleński",
    'balzac-komedia-ludzka-kobieta-porzucona.txt' => "Kobieta porzucona\nHonoré Balzac\ntłumaczenie Tadeusz Boy-Żeleński",
    'balzac-komedia-ludzka-jaszczur.txt' => '',
    'balzac-komedia-ludzka-kobieta-trzydziestoletnia.txt' => "Kobieta trzydziestoletnia\nHonorè de Balzac\ntłumaczenie Tadeusz Boy-Żeleński",
    'fortepian-chopina.txt' => "Cyprian Kamil Norwid\nFortepian Chopina",
    'boy-swietoszek.txt' => '',
    'wspomnienia-niebieskiego-mundurka.txt' => "Wiktor Gomulicki\nWspomnienia niebieskiego mundurka\nPamięci Bronisława Dembowskiego, towarzysza lat chłopięcych, urodzonego w Pułtusku, zmarłego w Zakopanem, te wspomnienia dni razem przeżytych poświęcam\nWiktor Gomulicki",
    'powiesci-fantastyczne-wybor-narzeczonej.txt' => "Ernst Teodor Amadeusz Hoffmann\nPowieści fantastyczne\ntłumaczenie Antoni Lange\nWybór narzeczonej\nhistoria, w której zachodzą rozmaite\nnieprawdopodobne przygody",
    'gloria-victis-gloria-victis.txt' => "Eliza Orzeszkowa\nGloria victis",
    'przygody-tomka-sawyera.txt' => "Mark Twain\nPrzygody Tomka Sawyera",
    'ballada-z-tamtej-strony-imieniny.txt' => "Józef Czechowicz",
    'przedwiosnie.txt' => "Stefan Żeromski\nPrzedwiośnie\nDedykacja",
    'piesn-o-rolandzie.txt' => "Pieśń o Rolandzie\nAutor nieznany\ntłumaczenie Tadeusz Boy-Żeleński",
    'spowiedz-dzieciecia-wieku.txt' => "Alfred de Musset\nSpowiedź dziecięcia wieku\ntłumaczenie Tadeusz Boy-Żeleński",
    'don-kichot-z-la-manchy.txt' => "Miguel de Cervantes Saavedra\nDon Kichot z La Manchy\ntłumaczenie Walenty Zakrzewski",
    'ksiega-dzungli.txt' => "Rudyard Kipling\nKsięga dżungli",
    'ojciec-goriot.txt' => "Honoriusz Balzac\nOjciec Goriot",
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

