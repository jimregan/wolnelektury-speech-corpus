#!/usr/bin/perl

use warnings;
use strict;
use utf8;
use Data::Dumper;

my %patterns = (
    'wyspa-skarbow.txt' => '^Część ',
    'sztuka-kochania.txt' => '^Księga ',
    'robinson-crusoe.txt' => 'Rozdział ',
    'wspomnienia-niebieskiego-mundurka.txt' => 'rozdział ',
    'powiesci-fantastyczne-wybor-narzeczonej.txt' => 'Rozdział ',
    'kim.txt' => 'Rozdział ',
    'przygody-tomka-sawyera.txt' => 'Rozdział ',
);

my %firstpatterns = (
    'wyspa-skarbow.txt' => '^Część pierwsza',
    'sztuka-kochania.txt' => '^Księga pierwsza',
    'robinson-crusoe.txt' => 'Rozdział pierwszy',
    'wspomnienia-niebieskiego-mundurka.txt' => 'DUMMY_TO_SKIP',
    'powiesci-fantastyczne-wybor-narzeczonej.txt' => 'Rozdział pierwszy',
    'kim.txt' => 'DUMMY_TO_SKIP',
    'przygody-tomka-sawyera.txt' => 'Rozdział pierwszy',
);

my %skipfirst = (
    'sztuka-kochania.txt' => 1,
);

my %split_by_starts = (
    'balzac-komedia-ludzka-corka-ewy.txt' => [
        'Od tłumacza',
        'Córka Ewy',
        'Pani de Vandenesse, która widocznie',
        'Były to niebezpieczne krewniaczki',
        'Tak więc, podczas gdy biedna Ewa,',
        'Paryż jest jedynym miejscem na świecie,',
        'Fantazja Raula zespoliła niby',
        'Pani Feliksowa de Vandenesse była trzy razy w lasku',
        'W październiku zapadł termin weksli;'
    ],
    'boy-swietoszek.txt' => [
        'Wstęp',
        'II. Wystawienie Świętoszka',
        'III. Podłoże „Świętoszka”.',
        'IV. Stosunek Moliera',
        'V. Zdobycze komedii Moliera.',
        'VI. Doniosłość',
        'VII. Źródła „Świętoszka”.',
        'VIII. Artyzm Świętoszka.',
        'Przedmowa',
        'Pierwsze podanie',
        'Drugie podanie',
        'Trzecie podanie',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
    ],
    'przedwiosnie.txt' => [
        'Stefan Żeromski',
        'Część pierwsza',
        'Część druga',
        'Część trzecia',
        'Pewnego dnia rano Lulek',
    ],
    'golem.txt' => [
        'Sen',
        'Dzień',
        'J\\.',
        'Praga',
        'Poncz',
        'Noc',
        'Jawa',
        'Śnieg',
        'Strach',
        'Światło',
        'Nędza',
        'Trwoga',
        'Pęd',
        'Kobieta',
        'Podstęp',
        'Męka',
        'Maj',
        'Księżyc',
        'Wolny',
        'Kres'
    ],
    'piesn-o-rolandzie' => [
        "I",
        "II",
        "III",
        "IV",
        "V",
        "VI",
        "VII",
        "VIII",
        "IX",
        "X",
        "XI",
        "XII",
        "XIII",
        "XIV",
        "XV",
        "XVI",
        "XVII",
        "XVIII",
        "XIX",
        "XX",
        "XXI",
        "XXII",
        "XXIII",
        "XXIV",
        "XXV",
        "XXVI",
        "XXVII",
        "XXVIII",
        "XXIX",
        "XXX",
        "XXXI",
        "XXXII",
        "XXXIII",
        "XXXIV",
        "XXXV",
        "XXXVI",
        "XXXVII",
        "XXXVIII",
        "XXXIX",
        "XL",
        "XLI",
        "XLII",
        "XLIII",
        "XLIV",
        "XLV",
        "XLVI",
        "XLVII",
        "XLVIII",
        "XLIX",
        "L",
        "LI",
        "LII",
        "LIII",
        "LIV",
        "LV",
        "LVI",
        "LVII",
        "LVIII",
        "LIX",
        "LX",
        "LXI",
        "LXII",
        "LXIII",
        "LXIV",
        "LXV",
        "LXVI",
        "LXVII",
        "LXVIII",
        "LXIX",
        "LXX",
        "LXXI",
        "LXXII",
        "LXXIII",
        "LXXIV",
        "LXXV",
        "LXXVI",
        "LXXVII",
        "LXXVIII",
        "LXXIX",
        "LXXX",
        "LXXXI",
        "LXXXII",
        "LXXXIII",
        "LXXXIV",
        "LXXXV",
        "LXXXVI",
        "LXXXVII",
        "LXXXVIII",
        "LXXXIX",
        "XC",
        "XCI",
        "XCII",
        "XCIII",
        "XCIV",
        "XCV",
        "XCVI",
        "XCVII",
        "XCVIII",
        "XCIX",
        "C",
        "CI",
        "CII",
        "CIII",
        "CIV",
        "CV",
        "CVI",
        "CVII",
        "CVIII",
        "CIX",
        "CX",
        "CXI",
        "CXII",
        "CXIII",
        "CXIV",
        "CXV",
        "CXVI",
        "CXVII",
        "CXVIII",
        "CXIX",
        "CXX",
        "CXXI",
        "CXXII",
        "CXXIII",
        "CXXIV",
        "CXXV",
        "CXXVI",
        "CXXVII",
        "CXXVIII",
        "CXXIX",
        "CXXX",
        "CXXXI",
        "CXXXII",
        "CXXXIII",
        "CXXXIV",
        "CXXXV",
        "CXXXVI",
        "CXXXVII",
        "CXXXVIII",
        "CXXXIX",
        "CXL",
        "CXLI",
        "CXLII",
        "CXLIII",
        "CXLIV",
        "CXLV",
        "CXLVI",
        "CXLVII",
        "CXLVIII",
        "CXLIX",
        "CL",
        "CLI",
        "CLII",
        "CLIII",
        "CLIV",
        "CLV",
        "CLVI",
        "CLVII",
        "CLVIII",
        "CLIX",
        "CLX",
        "CLXI",
        "CLXII",
        "CLXIII",
        "CLXIV",
        "CLXV",
        "CLXVI",
        "CLXVII",
        "CLXVIII",
        "CLXIX",
        "CLXX",
        "CLXXI",
        "CLXXII",
        "CLXXIII",
        "CLXXIV",
        "CLXXV",
        "CLXXVI",
        "CLXXVII",
        "CLXXVIII",
        "CLXXIX",
        "CLXXX",
        "CLXXXI",
        "CLXXXII",
        "CLXXXIII",
        "CLXXXIV",
        "CLXXXV",
        "CLXXXVI",
        "CLXXXVII",
        "CLXXXVIII",
        "CLXXXIX",
        "CXC",
        "CXCI",
        "CXCII",
        "CXCIII",
        "CXCIV",
        "CXCV",
        "CXCVI",
        "CXCVII",
        "CXCVIII",
        "CXCIX",
        "CC",
        "CCI",
        "CCII",
        "CCIII",
        "CCIV",
        "CCV",
        "CCVI",
        "CCVII",
        "CCVIII",
        "CCIX",
        "CCX",
        "CCXI",
        "CCXII",
        "CCXIII",
        "CCXIV",
        "CCXV",
        "CCXVI",
        "CCXVII",
        "CCXVIII",
        "CCXIX",
        "CCXX",
        "CCXXI",
        "CCXXII",
        "CCXXIII",
        "CCXXIV",
        "CCXXV",
        "CCXXVI",
        "CCXXVII",
        "CCXXVIII",
        "CCXXIX",
        "CCXXX",
        "CCXXXI",
        "CCXXXII",
        "CCXXXIII",
        "CCXXXIV",
        "CCXXXV",
        "CCXXXVI",
        "CCXXXVII",
        "CCXXXVIII",
        "CCXXXIX",
        "CCXL",
        "CCXLI",
        "CCXLII",
        "CCXLIII",
        "CCXLIV",
        "CCLXV",
        "CCXLVI",
        "CCXLVII",
        "CCXLVIII",
        "CCXLIX",
        "CCL",
        "CCLI",
        "CCLII",
        "CCLIII",
        "CCLIV",
        "CCLV",
        "CCLVI",
        "CCLVII",
        "CCLVIII",
        "CCLIX",
        "CCLX",
        "CCLXI",
        "CCLXII",
        "CCLXIII",
        "CCLXIV",
        "CCLXV",
        "CCLXVI",
        "CCLXVII",
        "CCLXVIII",
        "CCLXIX",
        "CCLXX",
        "CCLXXI",
        "CCLXXII",
        "CCLXXIII",
        "CCLXXIV",
        "CCLXXV",
        "CCLXXVI",
        "CCLXXVII",
        "CCLXXVIII",
        "CCLXXIX",
        "CCLXXX",
        "CCLXXXI",
        "CCLXXXII",
        "CCLXXXIV",
        "CCLXXXV",
        "CCLXXXVI",
        "CCLXXXVII",
        "CCLXXXVIII",
        "CCLXXXIX",
        "CCXC",
        "CCXCI",
    ],
);

my %split_inner = (
    'balzac-komedia-ludzka-corka-ewy.txt' => [
        'Paryż jest jedynym miejscem na świecie,',
        'Fantazja Raula zespoliła niby',
    ],
);

my %inner_split = ();

my $filename = $ARGV[0];
open(INPUT, '<', $filename) or die "$!";
binmode(INPUT, ":utf8");

my $fn = '';
if($filename =~ /.*\/([^\/]*)$/) {
    $fn = $1;
} else {
    $fn = $filename;
}

my $pattern = '';
my @patterns = ();
my $firstpattern = '';
if(exists $firstpatterns{$fn}) {
    $firstpattern = $firstpatterns{$fn};
}

if(exists $patterns{$fn}) {
    $pattern = $patterns{$fn};
} elsif(exists $split_by_starts{$fn}) {
    @patterns = @{ $split_by_starts{$fn} };
    my $pat = shift @patterns;
    $pattern = '^'. $pat;
    $firstpattern = $pattern;
} else {
    die "No pattern for filename $fn";
}

if(exists $split_inner{$fn}) {
    for my $si (@{ $split_inner{$fn} }) {
        $inner_split{$si} = 1;
    }
}
my $is_inner = 0;

my $count = 1;
my $printing = (exists $skipfirst{$fn}) ? 0 : 1;
if($filename eq 'wspomnienia-niebieskiego-mundurka.txt' || $filename eq 'kim.txt' || $filename eq 'przedwiosnie.txt') {
    $count = 0;
    $printing = 1;
}

my $outfile = $filename . "-" . sprintf("%02d.txt", $count);
open(OUTPUT, '>', $outfile);
binmode(OUTPUT, ":utf8");

while(<INPUT>) {
    chomp;
    if(/$pattern/) {
        my $point = $-[0];
        $printing = 1;
        if($is_inner) {
            print OUTPUT substr $_, 0, $point - 1 . "\n";
            $count++;
            $outfile = $filename . "-" . sprintf("%02d.txt", $count);
            close OUTPUT;
            open(OUTPUT, '>', $outfile);
            binmode(OUTPUT, ":utf8");
            print OUTPUT substr $_, $point . "\n";
        } elsif($_ !~ /$firstpattern/) {
            $count++;
            $outfile = $filename . "-" . sprintf("%02d.txt", $count);
            close OUTPUT;
            open(OUTPUT, '>', $outfile);
            binmode(OUTPUT, ":utf8");
            print OUTPUT "$_\n";
        } else {
            print OUTPUT "$_\n";
        }
        if(exists $split_by_starts{$fn} && @patterns) {
            my $pat = shift @patterns;
            if(exists $inner_split{$pat}) {
                $is_inner = 1;
                $pattern = $pat;
            } else {
                $is_inner = 0;
                $pattern = '^'. $pat;
            }
        }
    } else {
        if($printing) {
            print OUTPUT "$_\n";
        }
    }
}
