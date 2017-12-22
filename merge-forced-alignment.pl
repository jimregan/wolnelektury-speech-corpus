#!/usr/bin/perl

use warnings;
use strict;
use utf8;

open(TEXT, '<', $ARGV[0]);
open(FA, '<', $ARGV[1]);
binmode(TEXT, ":utf8");
binmode(FA, ":utf8");
binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my $start = 0.0;
my $end = 0.0;
my @lines = ();
while(<TEXT>) {
    chomp;
    push @lines, $_;
}

my $lidx = 0;
my $line = lc($lines[$lidx]);
my $oline = '';
while(<FA>) {
    s/"//g;
    my @parts = split/,/;
    my $word = $parts[0];
    my $wstart = $parts[4] / 1000;
    my $wend = $parts[5] / 1000;
    if($line =~ /$word/) {
        $line = substr $line, $+[0];
        $oline .= "$word ";
        $end = $wend;
    } else {
        $lidx++;
        $line = lc($lines[$lidx]);
        $oline =~ s/ $//;
        print "$start\t$end\t$oline\n";
        $start = $wstart;
        $end = $wend;
        $oline = "$word ";
    }
}
print "$start\t$end\t$oline\n";
