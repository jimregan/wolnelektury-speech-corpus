#!/usr/bin/perl
# Broad first pass to strip metadata footers, and do some broad expansions.

use warnings;
use strict;
use utf8;

binmode(STDOUT, ":utf8");
binmode(STDIN, ":utf8");

my $reading = 1;

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

my $units = "IX|IV|III|II|I|VIII|VII|VI|V";
my $tens = "XXX|XX|XL?";

while(<STDIN>) {
    chomp;
    s/\r//;
    #next if(/^tłum\./);
    next if(/^tłum\. A\. W\./);
    s/^tłum\./tłumaczenie/;
    s/^E\. T\. A\. Hoffmann$/Ernst Teodor Amadeusz Hoffmann/;
    next if(/^ISBN/);
    if(/^(Rozdzia[lł]|ROZDZIAŁ) ($tens)($units) *$/) {
        my $what = $1;
        my $tn = $2;
        my $un = $3;
	if($what eq 'Rozdzial') {
            $what = 'Rozdział';
        }
        if($tn eq 'X') {
            print "$what " . $chapter_ord_masc{$tn . $un} . "\n";
            next;
        } else {
            print "$what " . $chapter_ord_masc{$tn} . " " . $chapter_ord_masc{$un} . "\n";
            next;
        }
    } elsif(/^(Rozdzia[łl]|ROZDZIAŁ) ($tens) *$/) {
        my $what = $1;
        my $tn = $2;
	if($what eq 'Rozdzial') {
            $what = 'Rozdział';
        }
        print "$what " . $chapter_ord_masc{$tn} . "\n";
        next;
    } elsif(/^(Rozdzia[lł]|ROZDZIAŁ) ($units) *$/) {
        my $what = $1;
        my $un = $2;
	if($what eq 'Rozdzial') {
            $what = 'Rozdział';
        }
        print "$what " . $chapter_ord_masc{$un} . "\n";
        next;
    }
    if(/^(Pieśń) ($tens)($units) *$/) {
        my $what = $1;
        my $tn = $2;
        my $un = $3;
        if($tn eq 'X') {
            print "$what " . $chapter_ord_fem{$tn . $un} . "\n";
            next;
        } else {
            print "$what " . $chapter_ord_fem{$tn} . " " . $chapter_ord_fem{$un} . "\n";
            next;
        }
    } elsif(/^(Pieśń) ($tens) *$/) {
        my $what = $1;
        my $tn = $2;
        print "$what " . $chapter_ord_fem{$tn} . "\n";
        next;
    } elsif(/^(Pieśń) ($units) *$/) {
        my $what = $1;
        my $un = $2;
        print "$what " . $chapter_ord_fem{$un} . "\n";
        next;
    }
    next if(/^------------------------------------------------$/);
    next if(/^__________________________________________________________________$/);
    if(/^-----$/) {
        $reading = 0;
    }
    if($reading) {
        print "$_\n";
    }
}
