#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use FindBin;
use lib "$FindBin::RealBin";
use NumberNorm qw(expand_year inflect_ordinal_roman);

binmode(STDOUT, ":utf8");

my $filename = $ARGV[0];
open(INPUT, "<", $filename) or die "$!";
binmode(INPUT, ":utf8");

my @tmp = split/\//, $filename;
my $outfile = $tmp[$#tmp];

my $kings_nom = 'Ludwik|Henryk|Napoleon|Karol|Jerzy|Ferdynand';
my $kings_gen = 'Ludwika|Henryka|Napoleona|Karola|Jerzego|Ferdynanda';
my $kings_ins = 'Ludwikiem|Henrykiem|Napoleonem|Karolem|Jerzym|Ferdynandem';

while(<INPUT>) {
    if(/(([Ww]|[Pp]o) ([0-9]+) r(?:oku|\.))/) {
        my $m = $1;
        my $prep = $2;
        my $year = $3;
        my $outyear = expand_year($year, 'loc');
        print "$outfile\t$m\t$prep $outyear roku\n";
    } elsif(/(([Ww]|[Pp]o) r(?:oku|\.) ([0-9]+))/) {
        my $m = $1;
        my $prep = $2;
        my $year = $3;
        my $outyear = expand_year($year, 'loc');
        print "$outfile\t$m\t$prep roku $outyear\n";
    } elsif(/(([Ww]|[Pp]o) ([IXV]+) w(?:ieku|\.))/) {
        my $m = $1;
        my $prep = $2;
        my $ord = $3;
        my $outord = inflect_ordinal_roman($ord, 'm', 'loc');
        print "$outfile\t$m\t$prep $outord wieku\n";
    } elsif(/(([Ww]|[Pp]o) w(?:ieku|\.) ([IXV]+))/) {
        my $m = $1;
        my $prep = $2;
        my $ord = $3;
        my $outord = inflect_ordinal_roman($ord, 'm', 'loc');
        print "$outfile\t$m\t$prep wieku $outord\n";
    } elsif(/(($kings_nom) ([IXV]+))/) {
        my $m = $1;
        my $king = $2;
        my $ord = $3;
        my $outord = inflect_ordinal_roman($ord, 'm', 'nom');
        print "$outfile\t$m\t$king $outord\n";
    } elsif(/(($kings_gen) ([IXV]+))/) {
        my $m = $1;
        my $king = $2;
        my $ord = $3;
        my $outord = inflect_ordinal_roman($ord, 'm', 'gen');
        print "$outfile\t$m\t$king $outord\n";
    } elsif(/(($kings_ins) ([IXV]+))/) {
        my $m = $1;
        my $king = $2;
        my $ord = $3;
        my $outord = inflect_ordinal_roman($ord, 'm', 'ins');
        print "$outfile\t$m\t$king $outord\n";
    }
}
