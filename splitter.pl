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
    'kim.txt' => 'Rozdział ',
    'przygody-tomka-sawyera.txt' => 'Rozdział ',
);

my %firstpatterns = (
    'wyspa-skarbow.txt' => '^Część pierwsza',
    'sztuka-kochania.txt' => '^Księga pierwsza',
    'robinson-crusoe.txt' => 'Rozdział pierwszy',
    'wspomnienia-niebieskiego-mundurka.txt' => 'DUMMY_TO_SKIP',
    'powiesci-fantastyczne-wybor-narzeczonej.txt' => 'Rozdział pierwszy',
    'kim.txt' => 'DUMMY_TO_SKIP',
    'przygody-tomka-sawyera.txt' => 'Rozdział pierwszy',
);

my %skipfirst = (
    'sztuka-kochania.txt' => 1,
);

my %split_by_starts = (
    'balzac-komedia-ludzka-corka-ewy.txt' => [
        'Od tłumacza',
        'Córka Ewy',
        'Pani de Vandenesse, która widocznie',
        'Były to niebezpieczne krewniaczki',
        'Tak więc, podczas gdy biedna Ewa,',
        'Paryż jest jedynym miejscem na świecie,',
        'Fantazja Raula zespoliła niby',
        'Pani Feliksowa de Vandenesse była trzy razy w lasku',
        'W październiku zapadł termin weksli;'
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

my %split_inner = (
    'balzac-komedia-ludzka-corka-ewy.txt' => [
        'Paryż jest jedynym miejscem na świecie,',
        'Fantazja Raula zespoliła niby',
    ],
);

my %inner_split = ();

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

if(exists $split_inner{$fn}) {
    for my $si (@{ $split_inner{$fn} }) {
        $inner_split{$si} = 1;
    }
}
my $is_inner = 0;

my $count = 1;
my $printing = (exists $skipfirst{$fn}) ? 0 : 1;
if($filename eq 'wspomnienia-niebieskiego-mundurka.txt' || $filename eq 'kim.txt') {
    $count = 0;
    $printing = 1;
}

my $outfile = $filename . "-" . sprintf("%02d.txt", $count);
open(OUTPUT, '>', $outfile);
binmode(OUTPUT, ":utf8");

while(<INPUT>) {
    chomp;
    if(/$pattern/) {
        my $point = $-[0];
        $printing = 1;
        if($is_inner) {
            print OUTPUT substr $_, 0, $point - 1 . "\n";
            $count++;
            $outfile = $filename . "-" . sprintf("%02d.txt", $count);
            close OUTPUT;
            open(OUTPUT, '>', $outfile);
            binmode(OUTPUT, ":utf8");
            print OUTPUT substr $_, $point . "\n";
        } elsif($_ !~ /$firstpattern/) {
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
            if(exists $inner_split{$pat}) {
                $is_inner = 1;
                $pattern = $pat;
            } else {
                $is_inner = 0;
                $pattern = '^'. $pat;
            }
        }
    } else {
        if($printing) {
            print OUTPUT "$_\n";
        }
    }
}
