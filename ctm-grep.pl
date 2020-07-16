#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use Getopt::Long;

my $silence = 0.2;
my $print_lines = 0;

GetOptions('silence=f' => \$silence, 'print-lines' => \$print_lines);

if($#ARGV != 1) {
	die "Usage: ctm-grep.pl [--silence] PATTERN CTMFILE\n";
}

my $pat = $ARGV[0];
my $file = $ARGV[1];

open(FILE, "<", $file);
binmode(STDOUT, ":utf8");
binmode(FILE, ":utf8");

# build lines
# this depends on the mixed word/phoneme output of one of the clarin-pl scripts
my @lines = ();
my $line = "";
while(<FILE>) {
	s/\r//;
	my @parts = split/ /;
	if($parts[0] =~ /^@/ && $parts[4] eq 'sil' && $parts[3] >= $silence) {
		if($line ne '') {
			push @lines, $line;
			$line = '';
		}
		next;
	} elsif($parts[0] =~ /^@/) {
		next;
	} else {
		if($line eq '') {
			$line = $parts[4];
		} else {
			$line .= " $parts[4]";
		}
	}
}

for my $l (@lines) {
	if($print_lines == 1) {
		print "$l\n";
	} else {
		if($l =~ /$pat/) {
			print "$l\n";
		}
	}
}
