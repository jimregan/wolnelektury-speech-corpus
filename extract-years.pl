#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use FindBin;
use lib "$FindBin::RealBin";
use NumberNorm qw(expand_year);

binmode(STDOUT, ":utf8");

my $filename = $ARGV[0];
open(INPUT, "<", $filename) or die "$!";
binmode(INPUT, ":utf8");

my @tmp = split/\//, $filename;
my $outfile = $tmp[$#tmp];

while(<INPUT>) {
	if(/(([Ww]) ([0-9]+) r(?:oku|.))/) {
		my $m = $1;
		my $prep = $2;
		my $year = $3;
		my $outyear = expand_year($year, 'loc');
		print "$outfile\t$m\t$prep $outyear roku";
	} elsif(/(([Ww]) r(?:oku|.) ([0-9]+))/) {
                my $m = $1;
                my $prep = $2;
                my $year = $3;
                my $outyear = expand_year($year, 'loc');
                print "$outfile\t$m\t$prep roku $outyear";
        }

}
