#!/usr/bin/perl
use warnings;
use strict;
use utf8;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");
use Encode qw(decode_utf8);
@ARGV = map { decode_utf8($_, 1) } @ARGV;


my $base = $ARGV[0];
my $as = $ARGV[1];

my @pres = qw/uję ujesz uje ujemy ujecie ują
uj ujcie ujcież ujmy ujmyż ujże
ując/;

my @past = qw/li liby libyście libyśmy liście
liśmy ł ła łaby łabym łabyś łam łaś łby łbym 
łbyś łem łeś ło łoby ły łyby łybyście łybyśmy 
łyście łyśmy/;

my @adj_owa_ends = qw/a ą e ego ej emu i y ych ym ymi/; 

my @adj_uja_ends = qw/a ą e ego ej emu y ych ym ymi/;

my @vn_ends = qw/ia iach iami ie iem iom iu/;

if($base !~ /.*ować$/) {
	die "don't know how to handle '$base'\n";
}
if($as !~ /.*ować$/) {
	die "don't know how to handle '$as'\n";
}

my $base_stem = $base;
$base_stem =~ s/ować$//;
my $as_stem = $as;
$as_stem =~ s/ować$//;

print "$base\t$as\n";
for my $end(@pres) {
	print $base_stem . $end . "\t";
	print $as_stem . $end . "\n";
}
for my $end(@past) {
	print $base_stem . 'owa' . $end . "\t";
	print $as_stem . 'owa' . $end . "\n";
}
for my $end (@adj_owa_ends) {
	print $base_stem . 'owan' . $end . "\t";
	print $as_stem . 'owan' . $end . "\n";
	print 'nie' . $base_stem . 'owan' . $end . "\t";
	print 'nie' . $as_stem . 'owan' . $end . "\n";
}
print $base_stem . 'owań' . "\t";
print $as_stem . 'owań' . "\n";
print 'nie' . $base_stem . 'owań' . "\t";
print 'nie' . $as_stem . 'owań' . "\n";
for my $end (@vn_ends) {
	print $base_stem . 'owan' . $end . "\t";
	print $as_stem . 'owan' . $end . "\n";
	print 'nie' . $base_stem . 'owan' . $end . "\t";
	print 'nie' . $as_stem . 'owan' . $end . "\n";
}
print $base_stem . 'owano' . "\t";
print $as_stem . 'owano' . "\n";
for my $end (@adj_uja_ends) {
	print $base_stem . 'ując' . $end . "\t";
	print $as_stem . 'ując' . $end . "\n";
	print 'nie' . $base_stem . 'ując' . $end . "\t";
	print 'nie' . $as_stem . 'ując' . $end . "\n";
}
