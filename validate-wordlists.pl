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
open(WL, "<", $ARGV[2]);
binmode(WL, ":utf8");
open(VALID, ">", "$ARGV[2].valid");
binmode(VALID, ":utf8");
open(INVALID, ">", "$ARGV[2].invalid");
binmode(INVALID, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

my @speech = ();
while(<CTM>) {
    chomp;
    my @parts = split/ /;
    push @speech, { 'start' => $parts[2], 'end' => $parts[3], 'text' => $parts[4] };
}

my %wl = ();
while(<WL>) {
    chomp;
    $wl{$_} = 1;
}
close WL;

my @wordsref = ();
while(<REF>) {
    chomp;
    my @words = split/ /;
    my @wordsmap = map { local $_ = { 'text' => $_ } } @words; 
    $wordsmap[0]->{'sent_start'} = 1;
    $wordsmap[$#wordsmap]->{'sent_end'} = 1;
    push @wordsref, @wordsmap;
}
close REF;

my $matcher = Algorithm::NeedlemanWunsch->new(sub {@_==0 ? -1 : $_[0]->{'text'} eq $_[1]->{'text'} ? 1 : -2});

my @output = ();
my %seen = ();
my $result = $matcher->align(\@speech, \@wordsref,
  {
    align => sub {
      my $a = shift;
      my $b = shift;
      my $word = $wordsref[$b]->{'text'};
      if(exists $wl{$word} && !exists $seen{$word}) {
          $wl{$word} = 2; 
          print VALID "$word\n";
          $seen{$word} = 1;
      }
    },
    shift_a => sub {},
    shift_b => sub {
        my $b = shift;
        my $word = $wordsref[$b]->{'text'};
        if(exists $wl{$word} && $wl{$word} == 1) {
            print INVALID "$word\n";
        }
    }
  });

close VALID;
close INVALID;

