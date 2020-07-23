#!/usr/bin/perl
use warnings;
use strict;

open my $f, '<', $ARGV[0] or die $!;
binmode($f, ":utf8");
binmode(STDOUT, ":utf8");

$/ = undef;

my $text = <$f>;

close $f;

$text =~ s/\n/ /g;
$text =~ s/\{\+[^+]+\+\}//g;
$text =~ s/\[\-.*?\-\]//g;
$text =~ s/  */ /g;
print $text;
