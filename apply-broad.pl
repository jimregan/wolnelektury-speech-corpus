#!/usr/bin/perl
# Apply broad normalisations

use warnings;
use strict;
use utf8;
use Encode;
use FindBin qw($RealBin);

binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");
binmode(STDIN, ":utf8");

open(NORMS, '<', "$RealBin/broad-normalisations.tsv");
binmode(NORMS, ":utf8");

my %norms = ();

my $lineno = 0;
while(<NORMS>) {
    chomp;
    $lineno++;
    next if(/^#/);
    my @line = split/\t/;
    if ($#line != 1) {
        die "Incorrect number of fields at line $lineno: $_\n";
    }
    if ($line[0] eq $line[1]) {
        die "Normalisation equals original on line $lineno: $_\n";
    }
    $norms{$line[0]} = $line[1];
}

sub do_word {
    my $word = shift;
    my $orig = $word;
    my $pre = '';
    my $post = '';
    my $out = '';
    if($word =~ /^(\PL+)(.*)/) {
        $pre = $1;
        $word = $2;
    }
    if($word =~ /(.*\pL)(\PL+)$/) {
        $word = $1;
        $post = $2;
    }
    if(exists $norms{$word}) {
        $out = $norms{$word};
    } elsif($word =~ /^\p{Uppercase_Letter}.*\p{Uppercase_Letter}$/) {
        if(exists $norms{lc($word)}) {
            $out = uc($norms{lc($word)});
        } elsif (exists $norms{ucfirst($word)}) {
            $out = uc($norms{ucfirst($word)});
        } else {
            return $orig;
        }
    } elsif($word =~ /^\p{Uppercase_Letter}.*\p{Lowercase_Letter}$/ && exists $norms{lc($word)}) {
        $out = ucfirst($norms{lc($word)});
    } else {
        return $orig;
    }
    if($out eq '') {
        return $orig;
    }
    return $pre . $out . $post;
}

while(<>) {
    chomp;
    s/\r//g;
    my @words = split/ /, $_;
    my @out = map { local $_ = $_; do_word $_ } @words;
    print join(' ', @out) . "\n";
}