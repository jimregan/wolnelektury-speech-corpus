#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use Data::Dumper;
use Algorithm::Diff qw(diff);
use NumberNorm qw/num2text inflect_ordinal expand_year/;

open(SILENCES, '<', $ARGV[0]);
binmode(SILENCES, ":utf8");
open(SENTENCES, '<', $ARGV[1]);
binmode(SENTENCES, ":utf8");
open(GOOGASR, '<', $ARGV[2]);
binmode(GOOGASR, ":utf8");
binmode(STDERR, ":utf8");
binmode(STDOUT, ":utf8");

my @silences = ();
my %cur = ();
while(<SILENCES>) {
  chomp;
  if(/silence_start: (.*)$/) {
    my $start = $1;
    if ($start < 0) {
      print STDERR "LTZ: $start\n";
    }
    $cur{'start'} = ($start =~ /^[-]/) ? 0 : $start;
  } elsif(/silence_end: ([^ ]*) \| silence_duration: (.*)$/) {
    $cur{'end'} = $1;
    $cur{'dur'} = $2;
    push @silences, { %cur };
    %cur = ();
  } else {
    next;
  }
}
push @silences, { %cur };

my @sentences = ();
while(<SENTENCES>) {
  chomp;
  push @sentences, $_;
}
my $whole = join(' ', @sentences);

my @googasr = ();
while(<GOOGASR>) {
  chomp;
  if(/Word: ([^,]*), start_time: ([^,]*), end_time: (.*)$/) {
    my $wd = $1;
    my $st = $2;
    my $et = $3;
    push @googasr, { 'word' => $wd, 'start' => $st, 'end' => $et };
  }
}

my @wordsa = split/ /, $whole;
my @wordsb = map { $_->{'word'} } @googasr;

my @diff = diff(\@wordsa, \@wordsb);
print Dumper @diff;
