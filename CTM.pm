package CTM;

use warnings;
use strict;
use utf8;

use Exporter;

our @ISA = qw/Exporter/;
our @EXPORT = qw/read_ctm/;

my $silence = 0.2;

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
	if($line ne '') {
		push @lines, $line;
	}
	return @lines;
}
1;
