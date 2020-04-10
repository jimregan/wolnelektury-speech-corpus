#!/usr/bin/perl

use warnings;
use strict;
use utf8;

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
    print lc($_) . "\n";
    # print $_ . "\n";
}
