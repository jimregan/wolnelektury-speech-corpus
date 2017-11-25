#!/usr/bin/perl

use warnings;
use strict;
use utf8;

my %patterns = (
    'wyspa-skarbow.txt' => '^Część ',
);

my %firstpatterns = (
    'wyspa-skarbow.txt' => '^Część pierwsza',
);

my $filename = $ARGV[0];
open(INPUT, '<', $filename) or die "$!";
binmode(INPUT, ":utf8");

my $fn = '';
if($filename =~ /.*\/([^\/]*)$/) {
    $fn = $1;
} else {
    $fn = $filename;
}

my $pattern = '';
if(!exists $patterns{$fn}) {
    die "No pattern for filename $fn";
} else {
    $pattern = $patterns{$fn};
}
my $firstpattern = '';
if(!exists $firstpatterns{$fn}) {
    die "No pattern for filename $fn";
} else {
    $firstpattern = $firstpatterns{$fn};
}

my $count = 1;
my $outfile = $filename . "-" . sprintf("%02d.txt", $count);
open(OUTPUT, '>', $outfile);
binmode(OUTPUT, ":utf8");

while(<INPUT>) {
    chomp;
    if(/$pattern/) {
        if($_ !~ /$firstpattern/) {
            $count++;
            $outfile = $filename . "-" . sprintf("%02d.txt", $count);
            close OUTPUT;
            open(OUTPUT, '>', $outfile);
            binmode(OUTPUT, ":utf8");
            print OUTPUT "$_\n";
        } else {
            print OUTPUT "$_\n";
        }
    } else {
        print OUTPUT "$_\n";
    }
}