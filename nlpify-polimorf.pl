#!/usr/bin/perl

use warnings;
use strict;
use utf8;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

while(<STDIN>) {
    chomp;
    my @parts = split/\t/;
    if($parts[2] =~ /(praet:)(pl:m2\.m3\.f\.n1\.n2\.p2\.p3|sg:n1\.n2|sg:m1\.m2\.m3|sg:f|pl:m1\.p1)(:perf|:imperf|:imperf\.perf)/) {
        my $base = $1;
        my $persnum = $2;
        my $aspect = $3;
        
        if($persnum eq 'sg:n1.n2') {
            print "$parts[0]\t$parts[1]\t";
            print $base . $persnum . ":ter" . $aspect . "\t";
            print "$parts[2]\n";
            
            print "$parts[0]" . "by\t$parts[1]\t";
            print "pot:" . $persnum . ":ter" . $aspect . "\t";
            print "$parts[2]\n";
        } else {
            my @pers = (':pri', ':sec', ':ter');
            my @enc = ();
            if($persnum =~ /^sg:/) {
                @enc = ('m', 'ś', '');
            } else {
                @enc = ('śmy', 'ście', '');
            }
            my $epen = '';
            if($persnum eq 'sg:m1.m2.m3') {
                $epen = 'e';
            }
            for(my $i = 0; $i <= 2; $i++) {
                print "$parts[0]" . $epen . $enc[$i] . "\t$parts[1]\t";
                print $base . $persnum . $pers[$i] . $aspect . "\t";
                print "$parts[2]\n";
                
                print "$parts[0]" . "by" . $enc[$i] . "\t$parts[1]\t";
                print "pot:" . $persnum . $pers[$i] . $aspect . "\t";
                print "$parts[2]\n";
            }
        }
    } else {
        print "$_\n";
    }
}