#!/usr/bin/perl

use warnings;
use strict;
use utf8;

my %patterns = (
    'wyspa-skarbow.txt' => '^Część ',
    'sztuka-kochania.txt' => '^Księga ',
    'robinson-crusoe.txt' => 'Rozdział ',
    'wspomnienia-niebieskiego-mundurka.txt' => 'rozdział ',
);

my %firstpatterns = (
    'wyspa-skarbow.txt' => '^Część pierwsza',
    'sztuka-kochania.txt' => '^Księga pierwsza',
    'robinson-crusoe.txt' => 'Rozdział pierwszy',
    'wspomnienia-niebieskiego-mundurka.txt' => 'DUMMY_TO_SKIP',
);

my %skipfirst = (
    'sztuka-kochania.txt' => 1,
);

my %split_by_starts = (
    'balzac-komedia-ludzka-corka-ewy.txt' => [
        'Córka Ewy',
        'Pani de Vandenesse, która widocznie',
        'Były to niebezpieczne krewniaczki',
        'Tak więc, podczas gdy biedna Ewa,'
    ],
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
if(exists $firstpatterns{$fn}) {
    $firstpattern = $firstpatterns{$fn};
}

my $count = 1;
my $printing = (exists $skipfirst{$fn}) ? 0 : 1;
if($filename eq 'wspomnienia-niebieskiego-mundurka.txt') {
    $count = 0;
    $printing = 1;
}

my $outfile = $filename . "-" . sprintf("%02d.txt", $count);
open(OUTPUT, '>', $outfile);
binmode(OUTPUT, ":utf8");

while(<INPUT>) {
    chomp;
    if(/$pattern/) {
        $printing = 1;
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
        if($printing) {
            print OUTPUT "$_\n";
        }
    }
}
