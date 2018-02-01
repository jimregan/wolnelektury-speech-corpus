#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use Algorithm::Diff qw/sdiff/;
use Data::Dumper;

my %equals = (
  'j' => 'i',
  'ę' => 'e',
);

my $text_goog = '28 ganelon jedzie pod wysokimi drzewami oliwnymi przybył do posłów saraceński i do Blanka dryna który wszedł z nim w pogwarka obaj rozmawiają bardzo chytrze blancan powiada to cudowny człowiek ten karol podbił pulje i całą kalabrie przebył morze słone i zdobył świętemu piotrowi haracz anglii czego on jeszcze chce tutaj w naszym kraju ganelon odpowiada taka jest jego ochota nie będzie człowieka takiego jak on';

my $test_text = 'dwadzieścia osiem ganelon jedzie pod wysokimi drzewami oliwnymi przybył do posłów saraceńskich i do blankandryna który wszedł z nim w pogwarkę obaj rozmawiają bardzo chytrze blankandryn powiada to cudowny człowiek ten karol podbił pulię i całą kalabrię przebył morze słone i zdobył świętemu piotrowi haracz anglii czego on jeszcze chce tutaj w naszym kraju ganelon odpowiada taka jest jego ochota nie będzie człowieka takiego jak on';

my @a = split(/ /,$text_goog);
my @b = split(/ /,$test_text);

my @sdiffs = sdiff(\@a, \@b);

print Dumper @sdiffs;
