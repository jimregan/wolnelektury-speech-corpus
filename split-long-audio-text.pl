#!/usr/bin/perl
# Split longer texts to match audio

use warnings;
use strict;
use utf8;
use Data::Dumper;

my $DEBUG=0;

my %patterns = (
);

my %firstpatterns = (
);

my %split_by_starts = (
    'przedwiosnie.txt-02.txt' => [
        '— Ho—ho—ho! — ryczał Hipolit',
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

if($DEBUG) {
    print STDERR "Filename: $fn\n";
}

my $pattern = '';
my @patterns = ();
my $firstpattern = '';
if(exists $firstpatterns{$fn}) {
    $firstpattern = $firstpatterns{$fn};
}

if($DEBUG) {
    print STDERR "First pattern: $firstpattern\n";
}

if(exists $patterns{$fn}) {
    $pattern = $patterns{$fn};
} elsif(exists $split_by_starts{$fn}) {
    @patterns = @{ $split_by_starts{$fn} };
    my $pat = shift @patterns;
    $pattern = '^'. $pat;
    $firstpattern = $pattern;
} elsif(exists $split_by_whole{$fn}) {
    @patterns = @{ $split_by_whole{$fn} };
    my $pat = shift @patterns;
    $pattern = '^'. $pat .'$';
    $firstpattern = $pattern;
} else {
    die "No pattern for filename $fn";
}

if($DEBUG) {
    print STDERR "Pattern: $pattern\n";
    print STDERR "First pattern: $firstpattern\n";
}

if(exists $split_inner{$fn}) {
    for my $si (@{ $split_inner{$fn} }) {
        $inner_split{$si} = 1;
    }
}
my $is_inner = 0;

my $count = 1;
my $printing = (exists $skipfirst{$fn}) ? 0 : 1;
if($filename eq 'wspomnienia-niebieskiego-mundurka.txt' || $filename eq 'kim.txt' || $filename eq 'przedwiosnie.txt' || $filename eq 'brazownicy.txt') {
    $count = 0;
    $printing = 1;
}

my %skip_pattern = map { $_ => 1 } qw/wierna-rzeka.txt/;

my $count_spec = '%02d';

my $outfile = $filename . "-" . sprintf("$count_spec.txt", $count);
open(OUTPUT, '>', $outfile);
binmode(OUTPUT, ":utf8");
binmode(STDERR, ":utf8");

while(<INPUT>) {
    s/\r//;
    chomp;
    if(/$pattern/) {
        my $point = $-[0];
        $printing = 1;
        if($is_inner) {
            print OUTPUT substr $_, 0, $point - 1 . "\n";
            $count++;
            $outfile = $filename . "-" . sprintf("$count_spec.txt", $count);
            close OUTPUT;
            open(OUTPUT, '>', $outfile);
            binmode(OUTPUT, ":utf8");
            print OUTPUT substr $_, $point . "\n";
        } elsif($pattern ne $firstpattern && $_ !~ /$firstpattern/) {
            $count++;
            $outfile = $filename . "-" . sprintf("$count_spec.txt", $count);
            close OUTPUT;
            open(OUTPUT, '>', $outfile);
            binmode(OUTPUT, ":utf8");
            if(!exists $skip_pattern{$filename}) {
                print OUTPUT "$_\n";
            }
        } else {
            print OUTPUT "$_\n";
        }
        if((exists $split_by_starts{$fn} || exists $split_by_whole{$fn}) && @patterns) {
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
