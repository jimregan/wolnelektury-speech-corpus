#!/usr/bin/perl

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
    'VIII' => 'siódmy',
    'IX' => 'siódmy',
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

my $units = "IX|IV|III|II|I|VIII|VII|VII";
my $tens = "XXX|XX|X";

while(<STDIN>) {
    chomp;
    s/\r//;
    next if(/^tłum\./);
    next if(/^ISBN/);
    if(/^Rozdział ($tens)($units) *$/) {
        my $tn = $1;
        my $un = $2;
        if($tn eq 'X') {
            print "Rozdział " . $chapter_ord_masc{$tn . $un} . "\n";
            next;
        } else {
            print "Rozdział " . $chapter_ord_masc{$tn} . " " . $chapter_ord_masc{$un} . "\n";
            next;
        }
    } elsif(/^Rozdział ($tens) *$/) {
        my $tn = $1;
        print "Rozdział " . $chapter_ord_masc{$tn} . "\n";
        next;
    } elsif(/^Rozdział ($units) *$/) {
        my $un = $1;
        print "Rozdział " . $chapter_ord_masc{$un} . "\n";
        next;
    }
    if(/^-----$/) {
        $reading = 0;
    }
    if($reading) {
        print "$_\n";
    }
}