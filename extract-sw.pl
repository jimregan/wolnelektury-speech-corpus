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
        if($t =~ /św\. (\p{Lu}\p{L}+)/) {
            print "$fn\tśw. $1\tświętego $1\n";
        }
    }
}