#!/usr/bin/perl

use warnings;
use strict;
use utf8;
use Data::Dumper;

my %alfa = (
    "a" => "a",
    "b" => "be",
    "c" => "ce",
    "ć" => "cie",
    "d" => "de",
    "e" => "e",
    "f" => "ef",
    "g" => "gie",
    "h" => "ha",
    "i" => "i",
    "j" => "jot",
    "k" => "ka",
    "l" => "el",
    "ł" => "eł",
    "ł" => "ły",
    "m" => "em",
    "n" => "en",
    "ń" => "eń",
    "o" => "o",
    "ó" => "u",
    "p" => "pe",
    "q" => "ku",
    "r" => "er",
    "s" => "es",
    "ś" => "eś",
    "t" => "te",
    "u" => "u",
    "v" => "fau",
    "w" => "wu",
    "x" => "iks",
    "y" => "igrek",
    "z" => "zet",
    "ż" => "żet",
    "ź" => "ziet"
);

my @just_append = qw/a ej ie em owie u o/;
my %append = map { $_ => 1 } @just_append;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

while(<STDIN>) {
	chomp;
	my $word = $_;
	my $init = '';
	my $ending = '';
	if($word =~ /^([A-ZĄĆĘŁŃÓŚŻŹ]+)-?([a-ząćęłńóśżź]+)?/) {
		$init = $1;
		$ending = $2;
	}
	my @letters = split//, $init;
	my @spelled = map { $alfa{lc($_)} } @letters;
	my $base = join('-', @spelled);
	my $outword = $base;
	if($ending && $ending ne '') {
		my $last_letter = $spelled[$#spelled];
		my $first_of_ending = substr($ending, 0, 1);
		if(exists $append{$ending}) {
			$outword .= $ending;
		} elsif($last_letter =~ /$first_of_ending/) {
			my $pos = rindex($base, substr($ending, 0, 1));
			$outword = substr($base, 0, $pos) . $ending;
		} else {
			$outword .= $ending;
		}
	}
	print "$word\t$outword\n";
}
