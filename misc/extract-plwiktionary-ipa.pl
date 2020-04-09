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
    }
    if(/== *(.*)\(\{\{język ([^}]*)\}\}\) *==/) {
        my $lang = $2;
        if($lang eq 'polski') {
            $polish_seen = 1;
        } else {
            $polish_seen = 0;
        }
    }
    if($polish_seen) {
        my $orth = '';
        if(/\{\{ortograficzny\|([^}]*)\}\}/) {
            $orth = $1;
        }
        if(/\{\{IPA3\|([^}]*)\}\}/) {
            my $pron = $1;
            doentry($title, $orth, $pron);
        } else {
            doentry($title, $orth, '');
        }
    }
}

sub trim {
    my $var = shift;
    $var =~ s/^ *//;
    $var =~ s/ *$//;
    $var;
}

sub doentry {
    my $title = $_[0];
    my $orth = $_[1];
    my $pron = $_[2];

    $pron =~ s/\&lt;sup\&gt;j\&lt;\/sup\&gt;/ʲ/g;
    $pron =~ s/\&lt;sup\&gt;w\&lt;\/sup\&gt;/ʷ/g;
    $pron =~ s/'''//g;

    # skip in current dump - 'masy' is given the pronunciation of 'ludzie'
    return if($title eq 'masy');
    if($title eq 'kipiatok') {
        print "kipiatok\tcipʲjaˈtɔk\t";
    }
    
    my $orth_out = '';
    if($pron eq '') {
        print "$title\t\t$orth\n" if($orth ne '');
    } else {
        if($pron =~ /\|/) {
            for my $part (split/\|/, $pron) {
                print "$title\t$part\t$orth\n";
            }
        } else {
            print "$title\t$pron\t$orth\n";
        }
    }
}