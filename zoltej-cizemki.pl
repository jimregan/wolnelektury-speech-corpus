#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use Text::Aspell;
use Data::Dumper;

my $speller = Text::Aspell->new;

die unless $speller;

$speller->set_option('lang', 'pl');


open(OUT, '>', 'hzc.tsv');
binmode(OUT, ":utf8");
binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

my %repl = (
	'c' => ['c', 'cz'],
	's' => ['s', 'sz'],
	'z' => ['z', 'rz', 'ż'],
);

sub expand_inner {
	my $arr = $_[0];
	my $word = $_[1];
	if($word eq '') {
		return @$arr;
	}
	my $letter = substr($word, 0, 1);
	my @repls = ();
	if(exists $repl{$letter}) {
		@repls = @{$repl{$letter}};
	} else {
		push @repls, $letter;
	}
	my @stack = ();
	if($#{$arr} < 0) {
		for my $i (@repls) {
			push @stack, "$i";
		}
	} else {
		for my $i (@{$arr}) {
			for my $j (@repls) {
				push @stack, "$i$j";
			}
		}
	}
	return expand_inner(\@stack, substr($word, 1));
}
sub expand {
	my $word = shift;
	my @l = ();
	return expand_inner(\@l, $word);
}

while(<STDIN>) {
	chomp;
	my $word = $_;
	if($word !~ /.*[szc].*/i) {
		print STDOUT "Skipping $word\n";
	}
	if($speller->check($word)) {
		print STDOUT "OK: $word\n";
	}
	my @exp = expand(lc($word));
	my @tmp = ();
	for my $e (@exp) {
		if($speller->check($e)) {
			push @tmp, $e;
		}
	}
	if($#tmp >= 0) {
		if($#tmp == 0 && $tmp[0] eq $word) {
			print STDOUT "SKIP: $word\n";
		} else {
			print OUT "$word\t" . join(", ", @tmp) . "\n";
		}
	} else {
		print STDOUT "Missing: $word\n";
	}
}
