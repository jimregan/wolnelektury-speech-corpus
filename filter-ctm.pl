#!/usr/bin/perl

use warnings;
use strict;
use utf8;

binmode(DICT, ":utf8");
binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my %dict = ();

for my $df (@ARGV) {
	open(DICT, '<', $df);
	while(<DICT>) {
		chomp;
		next if(/^$/);
		my @a = split/\t/;
		$dict{lc($a[0])} = 1;
	}
	close(DICT);
}

while(<STDIN>) {
	chomp;
	my @line = split/ /;
	my $word = $line[4];
	if(!exists $dict{lc($word)}) {
		print "$_\n";
	}
}
