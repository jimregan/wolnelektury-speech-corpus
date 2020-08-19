#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use Text::LevenshteinXS qw/distance/;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my $vowels = '[aąeęiouy]+';
my $cons = '[bcćdfghjklłmnńpqrsśtvwxzżź]+';

while(<>) {
	chomp;
	my @parts = split/\t/;
	my $text_a = $parts[1];
	my $phon_a = $parts[2];
	my $text_b = $parts[3];
	my $phon_b = $parts[4];
	$phon_a =~ s/[\.ˈ]//g;
	$phon_b =~ s/[\.ˈ]//g;
	if($text_a eq $text_b) {
		# shouldn't happen
		print "TEXT_EQUAL\t$text_a\t$text_b\n";
	} elsif($phon_a eq $phon_b) {
		print "HOMOPHONE\t$text_a\t$text_b\n";
	} elsif(length($text_a) < length($text_b)) {
		if($text_b =~ /^$text_a/) {
			my $sfx = $text_b;
			$sfx =~ s/^$text_a//;
			print "MISSING_SFX\t+$sfx\t$text_a\t$text_b\n";
		} elsif($text_b =~ /$text_a$/) {
			my $pfx = $text_b;
			$pfx =~ s/$text_a$//;
			print "MISSING_PFX\t$pfx+\t$text_a\t$text_b\n";
		}
	} elsif(length($text_b) < length($text_a)) {
		if($text_a =~ /^$text_b/) {
			my $sfx = $text_a;
			$sfx =~ s/^$text_b//;
			print "ADDED_SFX\t+$sfx\t$text_a\t$text_b\n";
		} elsif($text_a =~ /$text_b$/) {
			my $pfx = $text_a;
			$pfx =~ s/$text_b$//;
			print "ADDED_PFX\t$pfx+\t$text_a\t$text_b\n";
		}
	} else {
		my $dist = distance($text_a, $text_b);
		my $pdist = distance($phon_a, $phon_b);
		print "$text_a\t$text_b\t$dist\t$pdist\n";
	}
	if($text_a =~ /$vowels$/ && $text_b =~ /$vowels$/) {
		my $stem_a = $text_a;
		my $stem_b = $text_b;
		my $end_a = '';
		my $end_b = '';
		if($text_a =~ /(.*$cons)($vowels)$/) {
			$stem_a = $1;
			$end_a = $2;
		}
		if($text_b =~ /(.*$cons)($vowels)$/) {
			$stem_b = $1;
			$end_b = $2;
		}
		if($stem_a eq $stem_b) {
			print "VOWEL_SWAP_SUFFIX\t$end_a\t$end_b\t$text_a\t$text_b\n";
		}
	}
}
