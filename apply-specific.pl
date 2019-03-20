#!/usr/bin/perl
# Apply text-specific normalisations
# These are specific to chapters, because in at least one case the 
# same elements are read differently

use warnings;
use strict;
use utf8;
use Encode;
use FindBin qw($RealBin);

binmode(STDOUT, ":utf8");
binmode(STDIN, ":utf8");

open(NORMS, '<', "$RealBin/specific-norms.tsv");
binmode(NORMS, ":utf8");

my $DUAL = 0;
if(@ARGV && $ARGV[1] && $ARGV[1] eq 'tts') {
    $DUAL = 1;
}

my %norms = ();
my %corrs = ();

my $lineno = 0;
while(<NORMS>) {
    chomp;
    $lineno++;
    next if(/^#/);
    my @line = split/\t/;
    if ($#line < 2 || $#line > 3) {
        print "Incorrect number of fields at line $lineno: $_\n";
    }
    if($DUAL && $#line == 3 && $line[3] eq 'C') {
        $corrs{$line[0]}{$line[1]} = $line[2];
        $norms{$line[0]}{$line[1]} = $line[2];
    } else {
        $norms{$line[0]}{$line[1]} = $line[2];
    }
}

sub do_file {
    my $file = shift;
    my $normorcorr = shift;

    rename($file, "$file.bak");
    open(IN, '<', "$file.bak");
    open(OUT, '>', "$file");
    binmode(IN, ":utf8");
    binmode(OUT, ":utf8");
    my %curnorms = ();
    if($DUAL && $normorcorr && $normorcorr eq 'corr') {
        %curnorms = %{$corrs{$file}};
    } else {
        %curnorms = %{$norms{$file}};
    }
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

for my $file(keys %norms) {
    if(!$DUAL) {
        do_file($file, "both");
    } else {
        do_file("$file.original", "corr");
        do_file("$file.clean", "norm");
    }
}