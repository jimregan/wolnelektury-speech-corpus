#!/usr/bin/perl

use warnings;
use strict;
use utf8;
use Getopt::Std;

our($opt_c);
getopts('c');

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

while(<>) {
    chomp;
    s/\*\-\*/ /g;
    s/[,;:!?—…„”\.«»\*\(\)\[\]‘\/\\]/ /g;
    s/’ //;
    s/^ //;
    s/ $//;
    s/  */ /g;
    s/–/ /g;
    s/^ *//;
    s/ *$//;
    s/  +/ /g;
    next if(/^$/);
    if($opt_c) {
        print $_ . "\n";
    } else {
        print lc($_) . "\n";
    }
}
