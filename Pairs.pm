package Pairs;

use warnings;
use strict;
use utf8;

use Exporter;
use FindBin qw($RealBin);

our @ISA = qw/Exporter/;
our @EXPORT = qw/get_audio_pair get_text_pair/;

my %text = ();
my %audio = ();
my $data_loaded = 0;

sub load_data {
	open(PAIRS, '<', "$RealBin/pairs.tsv");
	while(<PAIRS>) {
		chomp;
		my ($a, $t) = split/\t/;
		$audio{$a} = $t;
		$text{$t} = $a;
	}
	$data_loaded = 1;
}

sub get_audio_pair {
	my $name = shift;
	if($data_loaded != 1) {
		load_data();
	}
	return $text{$name};
}
sub get_text_pair {
	my $name = shift;
	if($data_loaded != 1) {
		load_data();
	}
	return $audio{$name};
}
1;
