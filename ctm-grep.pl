#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use Getopt::Long;

my $silence = 0.2;
my $print_lines = 0;

GetOptions('silence=f' => \$silence, 'print-lines' => \$print_lines);

if($print_lines == 0 && $#ARGV != 1) {
	die "Usage: ctm-grep.pl [--silence] PATTERN CTMFILE\n";
}

binmode(STDOUT, ":utf8");
my $pat = ($print_lines == 0) ? $ARGV[0] : '';
my $filename = ($print_lines == 0) ? $ARGV[1] : $ARGV[0];

sub read_ctm {
	my $file = shift;
	my $sil = shift;
	open(FILE, "<", $file);
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
	return @lines;
}

my @text = read_ctm($filename, $silence);

for my $l (@text) {
	if($print_lines == 1) {
		print "$l\n";
	} else {
		if($l =~ /$pat/) {
			print "$l\n";
		}
	}
}
