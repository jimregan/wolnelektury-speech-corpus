#!/usr/bin/perl

use warnings;
use strict;
use utf8;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

my $title = '';
my $polish_seen = 0;
while(<>) {
    if(/== *([^(]*)\(\{\{język polski\}\}\) *==/) {
        $title = $1;
        $polish_seen = 1;
    } elsif (/== *([^(]*)\(\{\{język ([^}]*)\}\}\) *==/) {
        my $tmptitle = $1;
        my $lang = $2;
        if($lang !~ /polski/i) {
            $polish_seen = 0;
        } else {
            $polish_seen = 1;
            $title = $tmptitle;
        }
    }
    if($polish_seen) {
        if(/\{\{IPA3\|([^}]*)\}\}/) {
            my $pron = $1;
            if($pron =~ /\|/) {
                for my $part (split/\|/, $pron) {
                    print "$title\t$part\n";
                }
            } else {
                print "$title\t$pron\n";
            }
        } 
        if(/\{\{ortograficzny\|([^}]*)\}\}/) {
            my $orth = $1;
            print "ORTH\t$title\t$orth\n";
        }
    }
} 
