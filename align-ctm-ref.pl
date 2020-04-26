#!/usr/bin/perl

use warnings;
use strict;
use utf8;
use Data::Dumper;

open(CTM, "<", $ARGV[0]);
binmode(CTM, ":utf8");
open(REF, "<", $ARGV[0]);
binmode(REF, ":utf8");

while(<CTM>) {
    chomp;
    my @parts = split/ /;
    next if($parts[4] ne 'speech');
    push @speech, { 'start' => $parts[2], 'end' => $parts[3], 'text' => $parts[4] };
}
my @wordsctm = map { local $_ = $_->{'text'} } @speech;

my @points = ();

my @wordsref = ();
while(<REF>) {
    chomp;
    my @words = split/ /;
    push @wordsref, @words;
    # this is dumb, but I only care about the size matching
    my @pts = map { local $_ = 0 } @words;
    $pts[0] = 1; # first word in sentence
    $pts[$#pts] = 2; # last word in sentence
    push @points, @pts;
}

my (@align_matrix, @backtrace_matrix);
initialize(\@wordsref, \@wordsctm, \@align_matrix, \@backtrace_matrix);

print Dumper @align_matrix;

# https://github.com/cmusphinx/sphinxtrain/blob/master/scripts/decode/word_align.pl
sub initialize {
    my ($ref_words, $hyp_words, $align_matrix, $backtrace_matrix) = @_;

    # All initial costs along the j axis are insertions
    for (my $j = 0; $j <= @$hyp_words; ++$j) {
	$$align_matrix[0][$j] = $j;
    }
    for (my $j = 0; $j <= @$hyp_words; ++$j) {
	$$backtrace_matrix[0][$j] = INS;
    }
    # All initial costs along the i axis are deletions
    for (my $i = 0; $i <= @$ref_words; ++$i) {
	$$align_matrix[$i][0] = $i;
    }
    for (my $i = 0; $i <= @$ref_words; ++$i) {
	$$backtrace_matrix[$i][0] = DEL;
    }
}

sub align {
    my ($ref_words, $hyp_words, $align_matrix, $backtrace_matrix) = @_;

    for (my $i = 1; $i <= @$ref_words; ++$i) {
	for (my $j = 1; $j <= @$hyp_words; ++$j) {
	    # Find insertion, deletion, substitution scores
	    my ($ins, $del, $subst);

	    # Cost of a substitution (0 if they are equal)
	    my $cost = $$ref_words[$i-1] ne $$hyp_words[$j-1];

	    # Find insertion, deletion, substitution costs
	    $ins = $$align_matrix[$i][$j-1] + 1;
	    $del = $$align_matrix[$i-1][$j] + 1;
	    $subst = $$align_matrix[$i-1][$j-1] + $cost;
	    print "Costs at $i $j: INS $ins DEL $del SUBST $subst\n"
		if $Verbose;

	    # Get the minimum one
	    my $min = BIG_NUMBER;
	    foreach ($ins, $del, $subst) {
		if ($_ < $min) {
		    $min = $_;
		}
	    }
	    $$align_matrix[$i][$j] = $min;

	    # If the costs are equal, prefer match or substitution
	    # (keep the path diagonal).
	    if ($min == $subst) {
		$$backtrace_matrix[$i][$j] = MATCH + $cost;
		print(($cost ? "SUBSTITUTION" : "MATCH"),
		      "($$ref_words[$i-1] <=> $$hyp_words[$j-1])\n")
		    if $Verbose;
	    }
	    elsif ($min == $ins) {
		$$backtrace_matrix[$i][$j] = INS;
		print "INSERTION (0 => $$hyp_words[$j-1])\n" if $Verbose;
	    }
	    elsif ($min == $del) {
		$$backtrace_matrix[$i][$j] = DEL;
		print "DELETION ($$ref_words[$i-1] => 0)\n" if $Verbose;
	    }
	}
    }
    return $$align_matrix[@$ref_words][@$hyp_words];
}

sub backtrace {
    my ($ref_words, $hyp_words, $align_matrix, $backtrace_matrix) = @_;

    # Backtrace to find number of ins/del/subst
    my @alignment;
    my $i = @$ref_words;
    my $j = @$hyp_words;
    my ($inspen, $delpen, $substpen, $match) = (0, 0, 0, 0);

    while (!($i == 0 and $j == 0)) {
	my $pointer = $$backtrace_matrix[$i][$j];
	print "Cost at $i $j: $$align_matrix[$i][$j]\n" if $Verbose;
	if ($pointer == INS) {
	    print "INSERTION (0 => $$hyp_words[$j-1])" if $Verbose;
	    # Append the pair 0:hyp[j] to the front of the alignment
	    unshift @alignment, [undef, $$hyp_words[$j-1]];
	    ++$inspen;
	    --$j;
	    print " - moving to $i $j\n" if $Verbose;
	}
	elsif ($pointer == DEL) {
	    print "DELETION ($$ref_words[$i-1] => 0)" if $Verbose;
	    # Append the pair ref[i]:0 to the front of the alignment
	    unshift @alignment, [$$ref_words[$i-1], undef];
	    ++$delpen;
	    --$i;
	    print " - moving to $i $j\n" if $Verbose;
	}
	elsif ($pointer == MATCH) {
	    print "MATCH ($$ref_words[$i-1] <=> $$hyp_words[$j-1])" if $Verbose;
	    # Append the pair ref[i]:hyp[j] to the front of the alignment
	    unshift @alignment, [$$ref_words[$i-1], $$hyp_words[$j-1]];
	    ++$match;
	    --$j;
	    --$i;
	    print " - moving to $i $j\n" if $Verbose;
	}
	elsif ($pointer == SUBST) {
	    print "SUBSTITUTION ($$ref_words[$i-1] <=> $$hyp_words[$j-1])"
		if $Verbose;
	    # Append the pair ref[i]:hyp[j] to the front of the alignment
	    unshift @alignment, [$$ref_words[$i-1], $$hyp_words[$j-1]];
	    ++$substpen;
	    --$j;
	    --$i;
	    print " - moving to $i $j\n" if $Verbose;
	}
	else {
	    last;
	}
    }

    return (\@alignment, $inspen, $delpen, $substpen, $match);
}
