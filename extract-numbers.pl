#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use FindBin;
use lib "$FindBin::RealBin";
use NumberNorm qw(get_num_regex);
use Pairs qw(get_audio_pair get_text_pair);
use CTM qw(read_ctm);

binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

my $CTM_PATH = 'kaldi/ctm/';
sub fix_ctm_name {
    my $fn = shift;
    die "$fn\n" if($fn eq '');
    print "$fn\n";
    $fn =~ s/\.mp3$/.ctm/;
    return $CTM_PATH . $fn;
}

my $filename = $ARGV[0];
my @nums = ();
my $mp3name = get_audio_pair($filename);
my $ctmfile = fix_ctm_name($mp3name);
my @ctmlines = read_ctm($ctmfile, 0.3);

open(INPUT, "<", $filename);
binmode(INPUT, ":utf8");
while(<INPUT>) {
    chomp;
    while(/([0-9]+)/g) {
        my $num = $1;
        my $regex = get_num_regex($num);
        for my $line (@ctmlines) {
            if($line =~ /($regex)/) {
                my $match = $1;
                print "# $_\n";
                print "# $line\n";
                print "$filename\t$num\t$match\n";
            }
        }
    }
}