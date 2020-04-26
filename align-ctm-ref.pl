#!/usr/bin/perl

use warnings;
use strict;
use utf8;
use Data::Dumper;

use Algorithm::NeedlemanWunsch;

open(CTM, "<", $ARGV[0]);
binmode(CTM, ":utf8");
open(REF, "<", $ARGV[0]);
binmode(REF, ":utf8");
binmode(STDOUT, ":utf8");

my @speech = ();
while(<CTM>) {
    chomp;
    my @parts = split/ /;
    push @speech, { 'start' => $parts[2], 'end' => $parts[3], 'text' => $parts[4] };
}


my @wordsref = ();
while(<REF>) {
    chomp;
    my @words = split/ /;
    push @wordsref, @words;
    # this is dumb, but I only care about the size matching
    my @pts = map { local $_ = 0 } @words;
    $pts[0] = 1; # first word in sentence
    $pts[$#pts] = 2; # last word in sentence
    push @points, @pts;
}

