#!/usr/bin/perl

use warnings;
use strict;
use utf8;

die "Usage: expand-with-polimorf.pl dict.tsv polimorf.tab" if($#ARGV != 1);

open(DICT, '<', $ARGV[0]);
binmode(DICT, ":utf8");
binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my %dict = ();

while(<DICT>) {
	chomp;
	next if(/^$/);
	my @a = split/\t/;
	$dict{$a[0]} = 1;
}
close(DICT);

my %tograb = ();
open(POLIMORF, '<', $ARGV[1]);
binmode(POLIMORF, ":utf8");
while(<POLIMORF>) {
    chomp;
    my @a = split/\t/;
    if(exists $dict{$a[0]}) {
        my $lem = $a[1];
        my $tags = $a[2];
        my $tag = '';
        if($tags =~ /perf/) {
            $tag = 'verb';
        } elsif($tags =~ /:/) {
            my @tagparts = split/:/, $tags;
            $tag = $tagparts[0];
        } else {
            $tag = $tags;
        }
        $tograb{"$lem:$tag"} = 1;
    }
}
close(POLIMORF);
open(POLIMORF, '<', $ARGV[1]);
binmode(POLIMORF, ":utf8");
while(<POLIMORF>) {
    chomp;
    my @a = split/\t/;
    my $lem = $a[1];
    my $tags = $a[2];
    my $tag = '';
    if($tags =~ /perf/) {
        $tag = 'verb';
    } elsif($tags =~ /:/) {
        my @tagparts = split/:/, $tags;
        $tag = $tagparts[0];
    } else {
        $tag = $tags;
    }
    if(exists $tograb{"$lem:$tag"}) {
        print "$a[0]\n";
    }
}

