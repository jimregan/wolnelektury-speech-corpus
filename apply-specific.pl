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
binmode(STDERR, ":utf8");
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
        die "Incorrect number of fields at line $lineno: $_\n";
    }
    if ($line[1] eq $line[2]) {
        die "Normalisation equals original on line $lineno: $_\n";
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

    print STDERR "Current file: $file\n";
    rename($file, "$file.bak") or die "$file: $!";
    open(IN, '<', "$file.bak") or die "$!";
    open(OUT, '>', "$file") or die "$!";
    binmode(IN, ":utf8") or die "$!";
    binmode(OUT, ":utf8") or die "$!";
    my %curnorms = ();
    if($DUAL && $normorcorr && $normorcorr eq 'corr') {
        %curnorms = %{$corrs{$file}};
    } else {
        %curnorms = %{$norms{$file}};
    }
    my @keys = keys(%curnorms);
    my $regex = join("|", map{quotemeta} @keys);
    my $replaced = 0;
    while(<IN>) {
        chomp;
        my $last_match = '';
        while(/($regex)/) {
            my $m = $1;
            if($m eq $last_match) {
                print STDERR "Loop matching $file: $_\n";
                next;
            }
            my $in = quotemeta($m);
            my $out = $curnorms{$m};
            if($out eq ' ') {
                s/$m//;
                $replaced++;
            } else {
                s/$m/$out/;
                $replaced++;
            }
            $last_match = $m;
        }
        print OUT "$_\n";
    }
    my $size = keys(%curnorms);
    print STDERR "Performed replacements: $replaced; available: $size\n";
    close(IN);
    close(OUT);
}

for my $file(keys %norms) {
    if(!$DUAL) {
        do_file($file, "both");
    } else {
        do_file($file, "corr");
        #do_file("$file.original", "corr");
        #do_file("$file.clean", "norm");
    }
}
