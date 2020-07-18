#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use Getopt::Long;

use FindBin;
use lib "$FindBin::RealBin";
use CTM qw(read_ctm);

my $silence = 0.2;
my $print_lines = 0;

GetOptions('silence=f' => \$silence, 'print-lines' => \$print_lines);

if($print_lines == 0 && $#ARGV != 1) {
	die "Usage: ctm-grep.pl [--silence] PATTERN CTMFILE\n";
}

binmode(STDOUT, ":utf8");
my $pat = ($print_lines == 0) ? $ARGV[0] : '';
my $filename = ($print_lines == 0) ? $ARGV[1] : $ARGV[0];

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
