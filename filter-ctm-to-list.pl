#!/usr/bin/perl

use warnings;
use strict;
use utf8;

open(WL, '<', $ARGV[0]) or die $!;
open(CTM, '<', $ARGV[1]) or die $!;
binmode(WL, ":utf8");
binmode(CTM, ":utf8");
binmode(STDOUT, ":utf8");

my %needles = ();
while(<WL>) {
	chomp;
	$needles{lc($_)} = 1;
}
close(WL);

while(<CTM>) {
	chomp;
	my @line = split/ /;
	if(exists $needles{$line[4]}) {
		print "$_\n";
	}
}
