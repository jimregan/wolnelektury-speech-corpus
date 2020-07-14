#!/usr/bin/perl

use warnings;
use strict;
use utf8;
use Data::Dumper;

use Algorithm::NeedlemanWunsch;

open(CTM, "<", $ARGV[0]);
binmode(CTM, ":utf8");
open(REF, "<", $ARGV[1]);
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
    my @wordsmap = map { local $_ = { 'text' => $_ } } @words; 
    $wordsmap[0]->{'sent_start'} = 1;
    $wordsmap[$#wordsmap]->{'sent_end'} = 1;
    push @wordsref, @wordsmap;
}

my $matcher = Algorithm::NeedlemanWunsch->new(sub {@_==0 ? -1 : $_[0]->{'text'} eq $_[1]->{'text'} ? 1 : -2});

my @output = ();
my $result = $matcher->align(\@speech, \@wordsref,
  {
    align => sub {
      my $a = shift;
      my $b = shift;
      my $out = $speech[$a];
      if(exists $wordsref[$b]->{'start'}) {
        $out->{'sent_start'} = $wordsref[$b]->{'sent_start'};
      }
      if(exists $wordsref[$b]->{'end'}) {
        $out->{'sent_end'} = $wordsref[$b]->{'sent_end'};
      }
      $out->{'rec'} = 1;
      unshift @output, $out;
    },
    shift_a => sub { unshift @output, $speech[shift] },
    shift_b => sub { shift; unshift @output, $wordsref[shift] }
  });

print Dumper @output;
