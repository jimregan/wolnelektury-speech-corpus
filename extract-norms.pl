#!/usr/bin/perl

use warnings;
use strict;
use utf8;
use FindBin;
use lib "$FindBin::RealBin/";
use NumberNorm qw(num2text expand_year);

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

my %pairs = ();

open(NORMS, '<', "$FindBin::RealBin/pairs.tsv");
while(<NORMS>) {
        chomp;
        next if(/^$/);
        my @a = split/\t/;
        $a[0] =~ s/\.mp3//;
        $pairs{$a[0]} = $a[1];
}
close(NORMS);

while(<STDIN>) {
   if(/^(.*)\.txt\.wdiff:(.*)$/) {
        my $file = $1;
        my $rest = $2;
        while($rest =~ /\[\-([^-]*)\-\] \{\+([^+]*)\+\}/g) {
            my $rec = $1;
            my $orig = $2;
            if($orig =~ /([0-9]+)/) {
                my $num = $1;
                for my $case (qw/nom gen dat loc/) {
                    my $exy = expand_year($num, $case);
                    my $repl = $pairs{$file};
                    if($rec =~ /$exy/) {
                        print "# $file :: $rec\n";
                        print "$repl\t$num\t$exy\n";
                    }
                }
            }
        }
    }
}