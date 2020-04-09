#!/usr/bin/perl

use warnings;
use strict;
use utf8;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

my %fixes = (
    'miękkopodniebienny' => 'mʲɛŋ.kkɔ.pɔ.dɲɛˈbʲɛn.nɨ',
);

while(<>) {
    chomp;
    my ($word, $pron) = split/\t/;

    $pron =~ s/^[\[\/]//;
    $pron =~ s/[\]\/]//;
    if(exists $fixes{$word}) {
        $pron = $fixes{$word};
    }
    $pron =~ s/ʃ/ʂ/g;

    print "$word\t$pron\n";
}