#!/usr/bin/perl
use warnings;
use strict;
use utf8;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

my %chapter_ord_masc = (
    'I' => 'pierwszy',
    'II' => 'drugi',
    'III' => 'trzeci',
    'IV' => 'czwarty',
    'V' => 'piąty',
    'VI' => 'szósty',
    'VII' => 'siódmy',
    'VIII' => 'ósmy',
    'IX' => 'dziewiąty',
    'X' => 'dziesiąty',
    'XI' => 'jedenasty',
    'XII' => 'dwunasty',
    'XIII' => 'trzynasty',
    'XIV' => 'czternasty',
    'XV' => 'piętnasty',
    'XVI' => 'szesnasty',
    'XVII' => 'siedemnasty',
    'XVIII' => 'osiemnasty',
    'XIX' => 'dziewiętnasty',
    'XX' => 'dwudziesty',
    'XXX' => 'trzydziesty',
    'XL' => 'czterdziesty',
    'L' => 'pięćdziesiąty',
    'LX' => 'sześćdziesiąty',
    'LXX' => 'siedemdziesiąty',
    'LXXX' => 'osiemdziesiąty',
    'XC' => 'dziewięćdziesiąty',
);

my %plurals = (
    'milion' => ['milion', 'miliony', 'milionów'],
    'tysiąc' => ['tysiąc', 'tysiące', 'tysięcy'],
    'miliard' => ['miliard', 'miliardy', 'miliardów'],
    
    'frank' => ['frank', 'franki', 'franków'],
    'centym' => ['centym', 'centymy', 'centymów'],
);

my %thousands = (
    1 => 'tysiąc',
);

my %hundreds = (
    1 => 'sto',
    2 => 'dwieście',
    3 => 'trzysta',
    4 => 'czterysta',
    5 => 'pięćset',
    6 => 'sześćset',
    7 => 'siedemset',
    8 => 'osiemset',
    9 => 'dziewięćset'
);

my %teens_ord = (
    10 => 'dziesiąty',
    11 => 'jedenasty',
    12 => 'dwunasty',
    13 => 'trzynasty',
    14 => 'czternasty',
    15 => 'piętnasty',
    16 => 'szesnasty',
    17 => 'siedemnasty',
    19 => 'osiemnasty',
    19 => 'dziewiętnasty',
);

my %teens = (
    10 => 'dziesięć',
    11 => 'jedenaście',
    12 => 'dwanaście',
    13 => 'trzynaście',
    14 => 'czternaście',
    15 => 'piętnaście',
    16 => 'szesnaście',
    17 => 'siedemnaście',
    19 => 'osiemnaście',
    19 => 'dziewiętnaście',
);

my %tens = (
    1 => 'dziesięć',
    2 => 'dwadzieścia',
    3 => 'trzydzieści',
    4 => 'czterdzieści',
    5 => 'pięćdziesiąt',
    6 => 'sześćdziesiąt',
    7 => 'siedemdziesiąt',
    8 => 'osiemdziesiąt',
    9 => 'dziewięćdziesiąt',
);

my %ones = (
    1 => 'jeden',
    2 => 'dwa',
    3 => 'trzy',
    4 => 'cztery',
    5 => 'pięć',
    6 => 'sześć',
    7 => 'siedem',
    8 => 'osiem',
    9 => 'dziewięć'
);

sub num2text_hundreds {
    my $num = $_[0];
    my $out = '';
    if(length($num) > 3) {
        return undef;
    }
    if(length($num) == 3) {
        my $lkup = substr($num, 0, 1);
        if($lkup == 0) {
            $out = '';
        } else {
            $out = $hundreds{$lkup};
        }
        $num = substr($num, 1);
    }
    if(length($num) == 2) {
        my $lkup = substr($num, 0, 1);
        my $space = ($out eq '') ? '' : ' ';
        if($lkup == 0) {
            $out .= '';
        } elsif($lkup == 1) {
            return $out . $space . $teens{$num};
        } else {
            $out .= $space . $tens{$lkup};
        }
        $num = substr($num, 1);
        if($num == 0) {
            return $out;
        }
    }
    if(length($num) == 1) {
        my $space = ($out eq '') ? '' : ' ';
        return $out . $space . $ones{$num};
    }
}

print num2text_hundreds("1") . "\n";
print num2text_hundreds("10") . "\n";
print num2text_hundreds("20") . "\n";
print num2text_hundreds("11") . "\n";
print num2text_hundreds("21") . "\n";
print num2text_hundreds("23") . "\n";
print num2text_hundreds("123") . "\n";
print num2text_hundreds("233") . "\n";