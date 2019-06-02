#!/usr/bin/perl
# Normalise chapter numbers when only number is present

use warnings;
use strict;
use utf8;

binmode(STDOUT, ":utf8");
binmode(STDIN, ":utf8");

my %spec = (
    'wyspa-skarbow.txt' => 'rozdział',
    'wspomnienia-niebieskiego-mundurka.txt' => 'rozdział',
);

my %del = (
    'z-wichrow-i-hal-z-tatr-krzak-dzikiej-rozy-w-ciemnych-smreczy.txt' => 1,
    'fortepian-chopina.txt' => 1,
);

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
);

my %chapter_ord_fem = (
    'I' => 'pierwsza',
    'II' => 'druga',
    'III' => 'trzecia',
    'IV' => 'czwarta',
    'V' => 'piąta',
    'VI' => 'szósta',
    'VII' => 'siódma',
    'VIII' => 'ósma',
    'IX' => 'dziewiąta',
    'X' => 'dziesiąta',
    'XI' => 'jedenasta',
    'XII' => 'dwunasta',
    'XIII' => 'trzynasta',
    'XIV' => 'czternasta',
    'XV' => 'piętnasta',
    'XVI' => 'szesnasta',
    'XVII' => 'siedemnasta',
    'XVIII' => 'osiemnasta',
    'XIX' => 'dziewiętnasta',
    'XX' => 'dwudziesta',
    'XXX' => 'trzydziesta',
);

my $units = "IX|IV|III|II|I|VIII|VII|VI|V";
my $tens = "XXX|XX|X";

die "Don't know how to handle text: $ARGV[0]" if(!exists $spec{$ARGV[0]} && !exists $del{$ARGV[0]});
my $del_mode = 0;
if(exists $del{$ARGV[0]}) {
    $del_mode = 1;
}
my $what = $spec{$ARGV[0]};
open(INPUT, '<', $ARGV[0]);
binmode(INPUT, ":utf8");
while(<INPUT>) {
    chomp;
    s/\r//;
    if($del_mode) {
        next if(/^($tens)($units)$/);
        next if(/^($tens)$/);
        next if(/^($units)$/);
    }
    if(/^($tens)($units)\. ?(.*)$/) {
        my $tn = $1;
        my $un = $2;
        my $rest = $3;
        if($tn eq 'X') {
            print "$what " . $chapter_ord_masc{$tn . $un} . "\n";
            print "$rest\n";
            next;
        } else {
            print "$what " . $chapter_ord_masc{$tn} . " " . $chapter_ord_masc{$un} . "\n";
            print "$rest\n";
            next;
        }
    } elsif(/^($tens)\. ?(.*)$/) {
        my $tn = $1;
        my $rest = $2;
        print "$what " . $chapter_ord_masc{$tn} . "\n";
        print "$rest\n";
        next;
    } elsif(/^($units)\. ?(.*)$/) {
        my $un = $1;
        my $rest = $2;
        print "$what " . $chapter_ord_masc{$un} . "\n";
        print "$rest\n";
        next;
    } else {
        print "$_\n";
    }
}
