#!/usr/bin/perl

use warnings;
use strict;
use utf8;
use Data::Dumper;
use Getopt::Long;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

my $enwikt = 0;
my $simple_mode = 1;
my $pronounce_as = 0;
my $pronounce_both = 0;
my $DEBUG = 0;

GetOptions(
    'enwiktionary|enwikt|w' => \$enwikt,
    'debug' => \$DEBUG,
    'pronounce-both' => sub { $pronounce_both = 1; $simple_mode = 0;},
    'pronounce-as' => sub { $pronounce_as = 1; $simple_mode = 0;},
);

my %nodevoice = map { $_ => $_ } qw(
    bʲ ɡʲ m mʲ n ɲ ŋ w l lʲ j r rʲ
);

my %g2p = (
    'a' => ['a'],
    'aa' => ['a', 'ʔ', 'a'],
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
    'q' => ['k', 'u'],
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
    # eść -> ejść
    'eść' => [ ['ɛ', 'ɕ', 't͡ɕ'], ['ɛ', 'j', 'ɕ', 't͡ɕ'] ],
    # drz as dż (https://encenc.pl/blad-fonetyczny/)
    # unlikely that ASR can tell the difference here
    'drz' => [ ['d͡ʐ'], ['d', 'ʐ']],
);

my %reranie = (
    # https://pl.wikipedia.org/wiki/Reranie
    # skipping 'd', though, primarily because I've never heard it
    'r' => [ ['r'],  ['l'],  ['w'],  ['v'],  ['j'] ],
    'ri' => [ ['rʲ', 'i'],  ['lʲ', 'i'],  ['wʲ', 'i'],  ['vʲ', 'i'],  ['j', 'i'] ],
    'ria' => [ ['rʲ', 'j', 'a'],  ['lʲ', 'j', 'a'],  ['wʲ', 'j', 'a'],  ['vʲ', 'j', 'a'], ['j', 'a'] ],
    'rią' => [ ['rʲ', 'j', 'ɔ̃'],  ['lʲ', 'j', 'ɔ̃'],  ['wʲ', 'j', 'ɔ̃'],  ['vʲ', 'j', 'ɔ̃'], ['j', 'ɔ̃'] ],
    'rie' => [ ['rʲ', 'j', 'ɛ'],  ['lʲ', 'j', 'ɛ'],  ['wʲ', 'j', 'ɛ'],  ['vʲ', 'j', 'ɛ'], ['j', 'ɛ'] ],
    'rię' => [ ['rʲ', 'j', 'ɛ̃'],  ['lʲ', 'j', 'ɛ̃'],  ['wʲ', 'j', 'ɛ̃'],  ['vʲ', 'j', 'ɛ̃'], ['j', 'ɛ̃'] ],
    'rii' => [ ['rʲ', 'j', 'i'],  ['lʲ', 'j', 'i'],  ['wʲ', 'j', 'i'],  ['vʲ', 'j', 'i'], ['j', 'i'] ],
    'rio' => [ ['rʲ', 'j', 'ɔ'],  ['lʲ', 'j', 'ɔ'],  ['wʲ', 'j', 'ɔ'],  ['vʲ', 'j', 'ɔ'], ['j', 'ɔ'] ],
    'rió' => [ ['rʲ', 'j', 'u'],  ['lʲ', 'j', 'u'],  ['wʲ', 'j', 'u'],  ['vʲ', 'j', 'u'], ['j', 'u'] ],
    'riu' => [ ['rʲ', 'j', 'u'],  ['lʲ', 'j', 'u'],  ['wʲ', 'j', 'u'],  ['vʲ', 'j', 'u'], ['j', 'u'] ],
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
    my $ret = 0;
    my %voice = map { $_ => 1 } keys %devoice;
    if($in && exists $voice{$in} && $voice{$in}) {
        $ret = 1;
    } elsif($in && exists $nodevoice{$in} && $nodevoice{$in}) {
        $ret = 1;
    } else {
        $ret = 0;
    }
    if($DEBUG) {
        print STDERR "is_voiced: $in: $ret\n";
    }
    return $ret;
}

sub devoice_final {
    my @in = @_;
    for(my $i = $#in; $i >= 0; $i--) {
        if(is_voiced($in[$i])) {
            $in[$i] = $devoice{$in[$i]};
        } else {
            if(is_vowel($in[$i]) || is_sylmark($in[$i])) {
                last;
            } else {
                next;
            }
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
    'ʂ' => 'n',
    'ʐ' => 'n',
);
sub renasalise {
    my @in = @_;
    my @out = ();
    for(my $i = 0; $i <= $#in; $i++) {
        my $c = $in[$i];
        my $n = ($i < $#in && exists $postnasals{$in[$i+1]}) ? $postnasals{$in[$i+1]} : '';
        if(($c eq 'ɛ̃' || $c eq 'ɔ̃') && $n ne '') {
            push @out, denasalise($in[$i]);
            push @out, $n;
        } else {
            push @out, $c;
        }
    }
    @out;
}

sub is_vowel {
    my $in = shift;
    my %vowels = map { $_ => 1 } qw/a ɛ ɛ̃ i ɨ ɔ ɔ̃ u/;
    if(exists $vowels{$in} && $vowels{$in}) {
        return 1;
    }
    return 0;
}

sub is_fvoiced {
    my $in = shift;
    my %fvoiced = map { $_ => 1 } qw/v vʲ ʐ/;
    if(!$enwikt) {
        delete $fvoiced{'ʐ'};
    }
    if(exists $fvoiced{$in} && $fvoiced{$in}) {
        return 1;
    }
    return 0;
}

sub devoice_forward {
    my @in = @_;
    if($DEBUG) {
        print STDERR "devoice_forward: pre: " . join(" ", @in) . "\n";
    }
    for(my $i = 1; $i <= $#in; $i++) {
        if(is_fvoiced($in[$i]) && !is_vowel($in[$i-1]) && !is_voiced($in[$i-1])) {
            $in[$i] = $devoice{$in[$i]};
        }
    }
    if($DEBUG) {
        print STDERR "devoice_forward: post: " . join(" ", @in) . "\n";
    }
    @in;
}

my %sylmarks = (
    '.' => '.',
    "'" => "ˈ",
    ',' => 'ˌ',
);

sub is_sylmark {
    my $in = shift;
    my %smarks = map { $_ => 1 } keys %sylmarks;
    if (exists $smarks{$in}) {
        return 1;
    } else {
        return 0;
    }
}

sub wiktionary_compat {
    if($enwikt) {
        # These are not always velarised, so en.wiktionary uses a safe default
        # for our purposes, it's better to separate with a hyphen and put in
        # 'pronounce-as.tsv'
        $g2p{'ng'} = ['n', 'ɡ'];
        $g2p{'nk'} = ['n', 'k'];
        # I don't see how these can in any way be correct.
        $postnasals{'ʂ'} = 'ŋ';
        $postnasals{'ʐ'} = 'ŋ';
        delete $g2p{'aa'};
    } else {
        $g2p{'krz'} = ['k', 'ʂ'];
        $g2p{'trz'} = ['t', 'ʂ'];
        $g2p{'prz'} = ['p', 'ʂ'];
        $g2p{'chrz'} = ['x', 'ʂ'];
        $g2p{'frz'} = ['f', 'ʂ'];
        $g2p{'kż'} = ['g', 'ʐ'];
    }
}

sub simple_g2p {
    my $in = shift;
    $in = lc($in);
    wiktionary_compat;
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
    @rawphones = devoice_forward(@rawphones);
    my $out = join("", @rawphones);
    $out =~ s/  +/ /g;
    $out;
}

sub multiple_g2p {
    my %g2pmult = map { $_ => [ $g2p{$_} ] } keys %g2p;
}

while(<>) {
    chomp;
    s/\r//;
    if($simple_mode) {
        print "$_\t" . simple_g2p($_) . "\n";
    } elsif($pronounce_as || $pronounce_both) {
        my @words = split/\t/;
        my $baseword = $words[0];
        my $pronas = $words[1];
        if($pronounce_both) {
            print "$baseword " . simple_g2p($baseword) . "\n";
        }
        print "$baseword " . simple_g2p($pronas) . "\n";
    }
}