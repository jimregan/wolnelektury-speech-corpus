#!/usr/bin/perl
use warnings;
use strict;
use utf8;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

while(<STDIN>) {
    if(/^([^:]+):(.*)/) {
        my $fn = $1;
        my $t = $2;
        if($t =~ /\b(p\.) (\p{Lu}\p{L}+)/) {
            print "$fn\t$1 $2\tpan $2\n";
        }
    }
}