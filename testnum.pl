#!/usr/bin/perl
use warnings;
use strict;
use utf8;
use Data::Dumper;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

use File::Basename;
use lib dirname (__FILE__);
use NumberNorm qw/num2text/;

print num2text("1") . "\n";
print num2text("10") . "\n";
print num2text("20") . "\n";
print num2text("11") . "\n";
print num2text("21") . "\n";
print num2text("23") . "\n";
print num2text("123") . "\n";
print num2text("233") . "\n";
print num2text("1233") . "\n";
print num2text("12233") . "\n";
print num2text("923233") . "\n";
print num2text("1000") . "\n";
print num2text("1000000") . "\n";
print num2text("10000000") . "\n";
print num2text("1013000000") . "\n";
print num2text("1000000000") . "\n";