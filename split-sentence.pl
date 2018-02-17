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
	s/„//g;
	next if(/^$/);
	my $firstpass = $splitter->split($_);
	$firstpass =~ s/— ([A-ZĄĆĘÓŁŚŻŹ])/\n— $1/g;
	$firstpass =~ s/… ([A-ZĄĆĘÓŁŚŻŹ])/…\n$1/g;
	print "$firstpass\n";
}
