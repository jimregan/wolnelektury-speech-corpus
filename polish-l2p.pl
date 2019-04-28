#!/usr/bin/perl

use warnings;
use strict;
use utf8;
use Data::Dumper;

binmode(STDOUT, ":utf8");

my %g2p = (
    'a' => ['a'],
    'au' => ['a', 'w'],
    'ą' => ['ɔ̃'],
    'b' => ['b'],
    'bi' => ['bʲ', 'i'],
    'bia' => ['bʲ', 'a'],
    'bią' => ['bʲ', 'ɔ̃'],
    'bie' => ['bʲ', 'ɛ'],
    'bię' => ['bʲ', 'ɛ̃'],
    'bii' => ['bʲ', 'j', 'i'],
    'bio' => ['bʲ', 'ɔ'],
    'bió' => ['bʲ', 'u'],
    'biu' => ['bʲ', 'u'],
    'c' => ['t͡s'],
    'ch' => ['x'],
    'chi' => ['xʲ', 'i'],
    'chia' => ['xʲ', 'j', 'a'],
    'chią' => ['xʲ', 'j', 'ɔ̃'],
    'chie' => ['xʲ', 'j', 'ɛ'],
    'chię' => ['xʲ', 'j', 'ɛ̃'],
    'chii' => ['xʲ', 'j', 'i'],
    'chio' => ['xʲ', 'j', 'ɔ'],
    'chió' => ['xʲ', 'j', 'u'],
    'chiu' => ['xʲ', 'j', 'u'],
    'ci' => ['t͡ɕ', 'i'],
    'cia' => ['t͡ɕ', 'a'],
    'cią' => ['t͡ɕ', 'ɔ̃'],
    'cie' => ['t͡ɕ', 'ɛ'],
    'cię' => ['t͡ɕ', 'ɛ̃'],
    'cio' => ['t͡ɕ', 'ɔ'],
    'ció' => ['t͡ɕ', 'u'],
    'ciu' => ['t͡ɕ', 'u'],
    'ciy' => ['t͡ɕ', 'ɨ'],
    'cz' => ['t͡ʂ'],
    'ć' => ['t͡ɕ'],
    'd' => ['d'],
    'dzi' => ['d͡ʑ', 'i'],
    'dzia' => ['d͡ʑ', 'a'],
    'dzią' => ['d͡ʑ', 'ɔ̃'],
    'dzie' => ['d͡ʑ', 'ɛ'],
    'dzię' => ['d͡ʑ', 'ɛ̃'],
    'dzio' => ['d͡ʑ', 'ɔ'],
    'dzió' => ['d͡ʑ', 'u'],
    'dziu' => ['d͡ʑ', 'u'],
    'dziy' => ['d͡ʑ', 'ɨ'],
    'dż' => ['d͡ʐ'],
    'dź' => ['d͡ʑ'],
    'e' => ['ɛ'],
    'ee' => ['ɛ', 'ʔ', 'ɛ'],
    'eu' => ['ɛ', 'w'],
    'ę' => ['ɛ̃'],
    'f' => ['f'],
    'fi' => ['fʲ', 'i'],
    'fia' => ['fʲ', 'a'],
    'fią' => ['fʲ', 'ɔ̃'],
    'fie' => ['fʲ', 'ɛ'],
    'fię' => ['fʲ', 'ɛ̃'],
    'fii' => ['fʲ', 'j', 'i'],
    'fio' => ['fʲ', 'ɔ'],
    'fió' => ['fʲ', 'u'],
    'fiu' => ['fʲ', 'u'],
    'g' => ['ɡ'],
    'gi' => ['ɡʲ', 'i'],
    'gią' => ['ɡʲ', 'ɔ̃'],
    'gia' => ['ɡʲ', 'j', 'a'],
    'gie' => ['ɡʲ', 'ɛ'],
    'gię' => ['ɡʲ', 'ɛ̃'],
    'gii' => ['ɡʲ', 'j', 'i'],
    'gio' => ['ɡʲ', 'j', 'ɔ'],
    'gió' => ['ɡʲ', 'j', 'u'],
    'giu' => ['ɡʲ', 'j', 'u'],
    'h' => ['x'],
    'hi' => ['xʲ', 'i'],
    'hia' => ['xʲ', 'j', 'a'],
    'hią' => ['xʲ', 'j', 'ɔ̃'],
    'hie' => ['xʲ', 'j', 'ɛ'],
    'hię' => ['xʲ', 'j', 'ɛ̃'],
    'hii' => ['xʲ', 'j', 'i'],
    'hio' => ['xʲ', 'j', 'ɔ'],
    'hió' => ['xʲ', 'j', 'u'],
    'hiu' => ['xʲ', 'j', 'u'],
    'i' => ['i'],
    'j' => ['j'],
    'k' => ['k'],
    'ki' => ['kʲ', 'i'],
    'kia' => ['kʲ', 'j', 'a'],
    'kią' => ['kʲ', 'j', 'ɔ̃'],
    'kie' => ['kʲ', 'ɛ'],
    'kię' => ['kʲ', 'j', 'ɛ̃'],
    'kii' => ['kʲ', 'j', 'i'],
    'kio' => ['kʲ', 'j', 'ɔ'],
    'kió' => ['kʲ', 'j', 'u'],
    'kiu' => ['kʲ', 'j', 'u'],
    'l' => ['l'],
    'li' => ['lʲ', 'i'],
    'lia' => ['lʲ', 'a'],
    'lią' => ['lʲ', 'ɔ̃'],
    'lie' => ['lʲ', 'ɛ'],
    'lię' => ['lʲ', 'ɛ̃'],
    'lii' => ['lʲ', 'j', 'i'],
    'lio' => ['lʲ', 'ɔ'],
    'lió' => ['lʲ', 'u'],
    'liu' => ['lʲ', 'u'],
    'ł' => ['w'],
    'm' => ['m'],
    'mi' => ['mʲ', 'i'],
    'mia' => ['mʲ', 'a'],
    'mią' => ['mʲ', 'ɔ̃'],
    'mie' => ['mʲ', 'ɛ'],
    'mię' => ['mʲ', 'ɛ̃'],
    'mii' => ['mʲ', 'j', 'i'],
    'mio' => ['mʲ', 'ɔ'],
    'mió' => ['mʲ', 'u'],
    'miu' => ['mʲ', 'u'],
    'n' => ['n'],
    # not always
    'ng' => ['ŋ', 'ɡ'],
    'nk' => ['ŋ', 'k'],
    'ni' => ['ɲ', 'i'],
    'nia' => ['ɲ', 'a'],
    'nią' => ['ɲ', 'ɔ̃'],
    'nie' => ['ɲ', 'ɛ'],
    'nię' => ['ɲ', 'ɛ̃'],
    'nii' => ['ɲ', 'j', 'i'],
    'nio' => ['ɲ', 'ɔ'],
    'nió' => ['ɲ', 'u'],
    'niu' => ['ɲ', 'u'],
    'ń' => ['ɲ'],
    'o' => ['ɔ'],
    'oo' => ['ɔ', 'ʔ', 'ɔ'],
    'ó' => ['u'],
    'p' => ['p'],
    'pi' => ['pʲ', 'i'],
    'pia' => ['pʲ', 'a'],
    'pią' => ['pʲ', 'ɔ̃'],
    'pie' => ['pʲ', 'ɛ'],
    'pię' => ['pʲ', 'ɛ̃'],
    'pii' => ['pʲ', 'j', 'i'],
    'pio' => ['pʲ', 'ɔ'],
    'pió' => ['pʲ', 'u'],
    'piu' => ['pʲ', 'u'],
    'qu' => ['k', 'v'],
    'r' => ['r'],
    'ri' => ['rʲ', 'i'],
    'ria' => ['rʲ', 'j', 'a'],
    'rią' => ['rʲ', 'j', 'ɔ̃'],
    'rie' => ['rʲ', 'j', 'ɛ'],
    'rię' => ['rʲ', 'j', 'ɛ̃'],
    'rii' => ['rʲ', 'j', 'i'],
    'rio' => ['rʲ', 'j', 'ɔ'],
    'rió' => ['rʲ', 'j', 'u'],
    'riu' => ['rʲ', 'j', 'u'],
    'rz' => ['ʐ'],
    's' => ['s'],
    'si' => ['ɕ', 'i'],
    'sia' => ['ɕ', 'a'],
    'sią' => ['ɕ', 'ɔ̃'],
    'sie' => ['ɕ', 'ɛ'],
    'się' => ['ɕ', 'ɛ̃'],
    'sio' => ['ɕ', 'ɔ'],
    'sió' => ['ɕ', 'u'],
    'siu' => ['ɕ', 'u'],
    'siy' => ['ɕ', 'ɨ'],
    'sz' => ['ʂ'],
    'ś' => ['ɕ'],
    't' => ['t'],
    'u' => ['u'],
    'v' => ['v'],
    'vi' => ['vʲ', 'i'],
    'via' => ['vʲ', 'a'],
    'vią' => ['vʲ', 'ɔ̃'],
    'vie' => ['vʲ', 'ɛ'],
    'vię' => ['vʲ', 'ɛ̃'],
    'vii' => ['vʲ', 'j', 'i'],
    'vio' => ['vʲ', 'ɔ'],
    'vió' => ['vʲ', 'u'],
    'viu' => ['vʲ', 'u'],
    'w' => ['v'],
    'wi' => ['vʲ', 'i'],
    'wia' => ['vʲ', 'a'],
    'wią' => ['vʲ', 'ɔ̃'],
    'wie' => ['vʲ', 'ɛ'],
    'wię' => ['vʲ', 'ɛ̃'],
    'wii' => ['vʲ', 'j', 'i'],
    'wio' => ['vʲ', 'ɔ'],
    'wió' => ['vʲ', 'u'],
    'wiu' => ['vʲ', 'u'],
    'wj' => ['vʲ', 'j'],
    'x' => ['k', 's'],
    'y' => ['ɨ'],
    'z' => ['z'],
    'ż' => ['ʐ'],
    'ź' => ['ʑ'],
    'zi' => ['ʑ', 'i'],
    'zia' => ['ʑ', 'a'],
    'zią' => ['ʑ', 'ɔ̃'],
    'zie' => ['ʑ', 'ɛ'],
    'zię' => ['ʑ', 'ɛ̃'],
    'zio' => ['ʑ', 'ɔ'],
    'zió' => ['ʑ', 'u'],
    'ziu' => ['ʑ', 'u'],
    '-' => [''],
);

my %variants = (
    # 'strz' as 'szcz'
    'strz' => [ ['s', 't', 'ʂ'], ['ʂ', 't͡ʂ'] ],
    # 'trz' as 'cz'
    'trz' => [ ['t', 'ʂ'], ['t͡ʂ'] ],
);

my %reall2p = (
    'ɔ̃' => ['ɔ', 'w̃'],
);

my %devoice = (
    'b' => 'p',
    'd' => 't',
    'd͡z' => 't͡s',
    'd͡ʑ' => 't͡ɕ',
	'd͡ʐ' => 't͡ʂ',
    'ɡ' => 'k',
    'v' => 'f',
    'vʲ' => 'fʲ',
	'z' => 's',
    'ʑ' => 'ɕ',
    'ʐ' => 'ʂ',
);

sub is_voiced {
    my $in = shift;
    my %voice = map { $_ => 1 } keys %devoice;
    if($in && exists $voice{$in} && $voice{$in}) {
        return 1;
    } else {
        return 0;
    }
}

sub devoice_final {
    my @in = @_;
    for(my $i = $#in; $i >= 0; $i--) {
        if(is_voiced($in[$i])) {
            $in[$i] = $devoice{$in[$i]};
        } else {
            last;
        }
    }
    @in;
}

sub denasalise {
    my $in = shift;
    if($in eq 'ɛ̃') {
        return 'ɛ';
    } elsif($in eq 'ɔ̃') {
        return 'ɔ';
    } else {
        return $in;
    }
}

sub renasalise {
    my @in = @_;
    my %postnasals = (
        'p' => 'm',
        'pʲ' => 'm',
        'b' => 'm',
        'bʲ' => 'm',
        'k' => 'ŋ',
        'kʲ' => 'ŋ',
        'ɡ' => 'ŋ',
        'ɡʲ' => 'ŋ',
        'x' => 'ŋ',
        'xʲ' => 'ŋ',
        't' => 'n',
        'd' => 'n',
        't͡ʂ' => 'n',
        'd͡ʐ' => 'n',
        't͡s' => 'n',
        'd͡z' => 'n',
        't͡ɕ' => 'ɲ',
        'd͡ʑ' => 'ɲ',
        'ɕ' => 'ɲ',
        'ʑ' => 'ɲ',
    );
    my @out = ();
    for(my $i = 0; $i <= $#in; $i++) {
         if($i < $#in && ($in[$i] eq 'ɛ̃' || $in[$i] eq 'ɔ̃') && exists $postnasals{$in[$i+1]}) {
            push @out, denasalise($in[$i]);
            push @out, $postnasals{$in[$i+1]};
        } else {
            push @out, $in[$i];
        }
    }
    @out;
}

sub simple_g2p {
    my $in = shift;
    $in = lc($in);
    my @sortkeys = sort { length $b <=> length $a } keys %g2p;
    my $regex = '(' . join('|', @sortkeys) . ')';
    my @rawphones = ();
    while($in =~ /$regex/) {
        my $match = $1;
        push @rawphones, @{$g2p{$match}};
        $in = substr($in, length($match));
    }
    # denasalise final 'ę'
    if($rawphones[$#rawphones] eq 'ɛ̃') {
        $rawphones[$#rawphones] = 'ɛ';
    }
    @rawphones = renasalise(@rawphones);
    @rawphones = devoice_final(@rawphones);
    return join(" ", @rawphones);
}

print simple_g2p("ząb");
