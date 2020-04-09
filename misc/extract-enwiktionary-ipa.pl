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
    if(/<title>([^<]*)<\/title>/) {
        $title = trim($1);
        $polish_seen = 0;
    } elsif(/== *Polish *==/) {
        $polish_seen = 1;
    } elsif(/== *([^=]*)==/) {
        if($1 !~ /polish/i) {
            $polish_seen = 0;
        }
    } elsif(/\{\{IPA\|([^}]*)\}\}/) {
        my $inner = $1;
        if($inner =~ /\|/) {
            my @parts = split/\|/, $inner;
            if($#parts != 1) {
                if($inner =~ /lang=pl$|lang=pl\|/) {
                    for my $part (@parts) {
                        next if($part =~ /^lang=pl$/);
                        print "$title\t$part\n";
                    }
                } else {
                    next;
                }
            } else {
                my $pron = ($parts[0] =~ /lang=/) ? $parts[1] : $parts[0];
                my $lang = ($parts[0] =~ /lang=/) ? $parts[0] : $parts[1];
                if($lang =~ /=pl$/) {
                    print "$title\t$pron\n";
                } else {
                    next;
                }
            }
        } elsif($polish_seen) {
            print "CHECK:\t$title\$inner\n";
        } else {
            next;
        }
        $polish_seen = 0;
    } else {
        next;
    }
}

sub trim {
    my $var = shift;
    $var =~ s/^ *//;
    $var =~ s/ *$//;
    $var;
}