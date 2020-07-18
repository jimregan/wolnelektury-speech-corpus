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

sub fix_filename {
    my $fn = shift;
    my @tmp = split/\//, $fn;
    return $tmp[$#tmp];
}

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
	my $input = shift;
    my $name = fix_filename($input);
	if($data_loaded != 1) {
		load_data();
	}
    if(!exists $text{$name}) {
        print STDERR "$name not in pairs.tsv\n";
        return '';
    }
	return $text{$name};
}
sub get_text_pair {
	my $input = shift;
    my $name = fix_filename($input);
	if($data_loaded != 1) {
		load_data();
	}
    if(!exists $audio{$name}) {
        print STDERR "$name not in pairs.tsv\n";
        return '';
    }
	return $audio{$name};
}
1;
