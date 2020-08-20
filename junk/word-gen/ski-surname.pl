#!/usr/bin/perl

use warnings;
use strict;
use utf8;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

my @ends = qw/ich iego iemu im imi a ą ie iej/;

while(<STDIN>) {
	chomp;
	if(/^[A-ZĄĆĘŁŃÓŚŻŹ][a-ząćęłńóśżź]+$/) {
		my $name = $_;
		if($name !~ /ki$/) {
			print STDERR "Skipping: $name\n";
		}
		my $base1 = $name;
		$base1 =~ s/i$//;
		print "$name\n";
		for my $end (@ends) {
			print $base1 . $end . "\n";
		}
		my $base2 = $name;
		$base2 =~ s/ki$/cy/;
		print "$base2\n";
	} else {
		print STDERR "Skipping $_\n";
	}
}
