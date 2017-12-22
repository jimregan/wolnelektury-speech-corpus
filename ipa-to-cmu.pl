#!/usr/bin/perl

use warnings;
use strict;
use utf8;

my %ipa_to_cmu = (
    'a' => 'A',
    'b' => 'B',
    't͡ʂ' => 'CZ',
    'd' => 'D',
    'd͡ʐ' => 'DRZ',
    'd͡z' => 'DZ',
    'd͡ʑ' => 'DZI',
    'ɛ' => 'E',
    'ɛŋ' => 'EN',
    'f' => 'F',
    'ɡ' => 'G',
    'i' => 'I',
    'j' => 'J',
    'ʲ' => 'J',
    'k' => 'K',
    'l' => 'L',
    'm' => 'M',
    'n' => 'N',
    'ɲ' => 'NI',
    'ɔ' => 'O',
    'ɔ̃' => 'ON',
    'p' => 'P',
    'r' => 'R',
    'ʐ' => 'RZ',
    's' => 'S',
    'ɕ' => 'SI',
    'ʂ' => 'SZ',
    't' => 'T',
    't͡s' => 'TS',
    't͡ɕ' => 'TSI',
    'u' => 'U',
    'v' => 'V',
    'w' => 'W',
    'x' => 'X',
    'ɨ' => 'Y',
    'z' => 'Z',
    'ʑ' => 'ZI',
    "ˈ" => '',
    '.' => '',
);

my $re = '(' . join("|", sort { length($b) <=> length($a) } keys %ipa_to_cmu) . ')';

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

while(<STDIN>) {
    chomp;
    my @parts = split/[ \t]/;
    my $word = shift @parts;
    $word = lc($word);
    my $pron = shift @parts;
    my @out = ();
    $pron =~ s/ʲ([^aɛɔu])/$1/g;
    while($pron =~ /$re/g) {
        my $m = $1;
        if(exists $ipa_to_cmu{$m} && $ipa_to_cmu{$m} ne '') {
            push @out, $ipa_to_cmu{$m};
        }
        next;
    }
    my $pronout = join(' ', @out);
    if($word =~ /ę$/ && $pronout =~ /E$/) {

    }
    print "$word $pronout\n";
    if($word =~ /ę$/ && $pronout =~ /E$/) {
        my $alt = $pronout;
        $alt =~ s/E$/EN/;
        print "$word $alt\n";
    }
}
