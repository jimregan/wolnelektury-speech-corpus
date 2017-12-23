#!/usr/bin/perl

use warnings;
use strict;
use utf8;

open(DICT, '<', $ARGV[0]);
binmode(DICT, ":utf8");
binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my %dict = ();

while(<DICT>) {
	chomp;
	next if(/^$/);
	my @a = split/\t/;
	$dict{lc($a[0])} = 1;
}
close(DICT);

if($#ARGV >= 1) {
  open(DICT, '<', $ARGV[1]);
  binmode(DICT, ":utf8");
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
	if(!exists $dict{$_}) {
		print "$_\n";
	}
}
