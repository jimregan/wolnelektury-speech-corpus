#!/usr/bin/perl

use warnings;
use strict;
use utf8;
use Data::Dumper;

my %patterns = (
    'wyspa-skarbow.txt' => '^Część ',
    'sztuka-kochania.txt' => '^Księga ',
    'robinson-crusoe.txt' => 'Rozdział ',
    'wspomnienia-niebieskiego-mundurka.txt' => 'rozdział ',
    'powiesci-fantastyczne-wybor-narzeczonej.txt' => 'Rozdział ',
);

my %firstpatterns = (
    'wyspa-skarbow.txt' => '^Część pierwsza',
    'sztuka-kochania.txt' => '^Księga pierwsza',
    'robinson-crusoe.txt' => 'Rozdział pierwszy',
    'wspomnienia-niebieskiego-mundurka.txt' => 'DUMMY_TO_SKIP',
    'powiesci-fantastyczne-wybor-narzeczonej.txt' => 'Rozdział pierwszy',
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
    'golem.txt' => [
        'Sen',
        'Dzień',
        'J\\.',
        'Praga',
        'Poncz',
        'Noc',
        'Jawa',
        'Śnieg',
        'Strach',
        'Światło',
        'Nędza',
        'Trwoga',
        'Pęd',
        'Kobieta',
        'Podstęp',
        'Męka',
        'Maj',
        'Księżyc',
        'Wolny',
        'Kres'
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
my @patterns = ();
my $firstpattern = '';
if(exists $firstpatterns{$fn}) {
    $firstpattern = $firstpatterns{$fn};
}

if(exists $patterns{$fn}) {
    $pattern = $patterns{$fn};
} elsif(exists $split_by_starts{$fn}) {
    @patterns = @{ $split_by_starts{$fn} };
    my $pat = shift @patterns;
    $pattern = '^'. $pat;
    $firstpattern = $pattern;
} else {
    die "No pattern for filename $fn";
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
        if(exists $split_by_starts{$fn} && @patterns) {
            my $pat = shift @patterns;
            $pattern = '^'. $pat;
        }
    } else {
        if($printing) {
            print OUTPUT "$_\n";
        }
    }
}
