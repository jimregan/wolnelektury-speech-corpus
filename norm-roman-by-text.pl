#!/usr/bin/perl
# Normalise chapter numbers when only number is present

use warnings;
use strict;
use utf8;

binmode(STDOUT, ":utf8");
binmode(STDIN, ":utf8");

my %spec = (
    'wyspa-skarbow.txt' => 'Rozdział',
    'wspomnienia-niebieskiego-mundurka.txt' => 'Rozdział',
    'chlopi-czesc-pierwsza-jesien.txt' => 'Rozdział',
    'lange-miranda.txt' => 'Rozdział',
    'sztuka-kochania.txt' => 'Pieśń',
    'slowka-zbior-o-bardzo-niegrzecznej-literaturze-polskiej-i-jej-strapionej-ciotce.txt' => 'card',
);

my %del = (
    'z-wichrow-i-hal-z-tatr-krzak-dzikiej-rozy-w-ciemnych-smreczy.txt' => 1,
    'fortepian-chopina.txt' => 1,
    'bartek-zwyciezca.txt' => 1,
    'bema-pamieci-zalobny-rapsod.txt' => 1,
    'cos-ty-atenom-zrobil-sokratesie.txt' => 1,
);

my %single = (
    'chlopi-czesc-pierwsza-jesien.txt' => 1,
    'lange-miranda.txt' => 1,
    'sztuka-kochania.txt' => 1,
    'slowka-zbior-o-bardzo-niegrzecznej-literaturze-polskiej-i-jej-strapionej-ciotce.txt' => 1,
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
    'XL' => 'czterdziesty',
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
    'XL' => 'czterdziesta',
);

my %chapter_card = (
    'I' => 'jeden',
    'II' => 'dwa',
    'III' => 'trzy',
    'IV' => 'cztery',
    'V' => 'pięć',
    'VI' => 'sześć',
    'VII' => 'siedem',
    'VIII' => 'osiem',
    'IX' => 'dziewięć',
    'X' => 'dziesięć',
    'XI' => 'jedenaście',
    'XII' => 'dwanaście',
    'XIII' => 'trzynaście',
    'XIV' => 'czternaście',
    'XV' => 'piętnaście',
    'XVI' => 'szesnaście',
    'XVII' => 'siedemnaście',
    'XVIII' => 'osiemnaście',
    'XIX' => 'dziewiętnaście',
    'XX' => 'dwadzieścia',
    'XXX' => 'trzydzieści',
    'XL' => 'czterdzieści',
);

my $units = "IX|IV|III|II|I|VIII|VII|VI|V";
my $tens = "XXX|XX|XL?";

sub gendered_ordinal {
    my $gen = shift;
    my $ord = shift;
    if($gen eq 'card') {
        return $chapter_card{$ord};
    } elsif($gen eq 'f') {
        return $chapter_ord_fem{$ord};
    } else {
        return $chapter_ord_masc{$ord};
    }
}

sub get_norm {
    my $what = shift;
    my $tn = shift;
    my $un = shift;
    my $gen = 'm';
    my $spc = ' ';
    if($what eq 'card') {
        $gen = 'card';
        $what = '';
        $spc = '';
    } elsif($what eq 'Pieśń') {
        $gen = 'f';
    }
    my $num = '';
    if($un eq '') {
        return "$what" . $spc . gendered_ordinal($gen, $tn) . "\n";
    } elsif($tn eq '') {
        return "$what" . $spc . gendered_ordinal($gen, $un) . "\n";
    } elsif($tn eq 'X') {
        return "$what" . $spc . gendered_ordinal($gen, $tn . $un) . "\n";
    } else {
        return "$what" . $spc . gendered_ordinal($gen, $tn) . ' ' . gendered_ordinal($gen, $un) . "\n";
    }
}

die "Don't know how to handle text: $ARGV[0]" if(!exists $spec{$ARGV[0]} && !exists $del{$ARGV[0]});
my $del_mode = 0;
my $single_mode = 0;
if(exists $del{$ARGV[0]}) {
    $del_mode = 1;
}
if(exists $single{$ARGV[0]}) {
    $single_mode = 1;
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
    if($single_mode) {
        if(/^($tens)($units)$/) {
            my $tn = $1;
            my $un = $2;
            print get_norm($what, $tn, $un);
            next;
        } elsif(/^($tens)$/) {
            my $tn = $1;
            print get_norm($what, $tn, '');
            next;
        } elsif(/^($units)$/) {
            my $un = $1;
            print get_norm($what, '', $un);
            next;
        } else {
            print "$_\n";
            next;
        }
    }
    if(/^($tens)($units)\. ?(.*)$/) {
        my $tn = $1;
        my $un = $2;
        my $rest = $3;
        print get_norm($what, $tn, $un);
        print "$rest";
        next;
    } elsif(/^($tens)\. ?(.*)$/) {
        my $tn = $1;
        my $rest = $2;
        print get_norm($what, $tn, '');
        print "$rest";
        next;
    } elsif(/^($units)\. ?(.*)$/) {
        my $un = $1;
        my $rest = $2;
        print get_norm($what, '', $un);
        print "$rest";
        next;
    } else {
        print "$_\n";
    }
}
