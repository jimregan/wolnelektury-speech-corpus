#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use Text::LevenshteinXS qw/distance/;
#use Text::Aspell;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

#my $speller = Text::Aspell->new;
#die unless $speller;
#$speller->set_option('lang', 'pl');

my $vowels = '[aąeęiouy]+';
my $cons = '[bcćdfghjklłmnńpqrsśtvwxzżź]+';

sub final_vowel {
	my $text_a = shift;
	my $text_b = shift;
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
			return 1;
		}
	}
	return 0;
}

sub check_lexicon {
	my $text_a = shift;
	my $text_b = shift;
	if($speller->check($text_a) || $speller->check(ucfirst($text_a))) {
		return 0;
	}
	my @sugg = $speller->suggest($text_a);
	for my $sug (@sugg) {
		if(lc($sug) eq $text_b) {
			print "LEXICON_ERROR\t$text_a\t$text_b\n";
			return 1;
		}
	}
	return 0;
}

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
	} elsif(final_vowel($text_a, $text_b)) {
		next;
#	} elsif(check_lexicon($text_a, $text_b)) {
#		next;
	} else {
		my $dist = distance($text_a, $text_b);
		my $pdist = distance($phon_a, $phon_b);
		print "$text_a\t$text_b\t$dist\t$pdist\n";
	}
}
