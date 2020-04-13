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
        if($t =~ /Św\. (\p{Lu}\p{L}+)/) {
            print "$fn\tŚw. $1\tŚwiętego $1\n";
        }
    }
}