#!/usr/bin/perl

use warnings;
use strict;
use utf8;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my $buf = '';
while(<>) {
	chomp;
	s/\*//g;
	s/ *$//;
	if(/\-$/) {
		s/\-$//;
		if($buf ne '') {
			$buf .= " $_";
		} else {
			$buf = $_;
		}
		next;
	} else {
		if($buf ne '') {
			s/^ *//;
		}
		print "$buf$_\n";
		$buf = '';
	}
}
