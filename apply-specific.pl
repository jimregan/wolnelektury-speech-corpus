#!/usr/bin/perl
# Apply text-specific normalisations
# These are specific to chapters, because in at least one case the 
# same elements are read differently

use warnings;
use strict;
use utf8;
use Encode;

binmode(STDOUT, ":utf8");
binmode(STDIN, ":utf8");

open(NORMS, '<', 'specific-norms.tsv');
binmode(NORMS, ":utf8");

my %norms = ();

my $lineno = 0;
while(<NORMS>) {
    chomp;
    $lineno++;
    my @line = split/\t/;
    if ($#line != 2) {
        print "Incorrect number of fields at line $lineno: $_\n";
    }
    $norms{$line[0]}{$line[1]} = $line[2];
}

for my $file(keys %norms) {
    rename($file, "$file.bak");
    open(IN, '<', "$file.bak");
    open(OUT, '>', "$file");
    binmode(IN, ":utf8");
    binmode(OUT, ":utf8");
    my %curnorms = %{$norms{$file}};
    my @keys = keys(%curnorms);
    my $regex = join("|", map{quotemeta} @keys);
    while(<IN>) {
        chomp;
        while(/($regex)/) {
            my $m = $1;
            my $in = quotemeta($m);
            my $out = $curnorms{$m};
            s/$m/$out/;
        }
        print OUT "$_\n";
    }
    close(IN);
    close(OUT);
}
