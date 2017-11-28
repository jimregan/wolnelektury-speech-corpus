#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use Lingua::Sentence;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my $splitter = Lingua::Sentence->new("pl");

while(<>) {
	chomp;
	s/\r//;
	next if(/^$/);
	print $splitter->split($_);
	print "\n";
}
