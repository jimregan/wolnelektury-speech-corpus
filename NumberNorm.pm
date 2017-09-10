package NumberNorm;

use warnings;
use strict;
use utf8;

use Exporter;

our @ISA = qw/Exporter/;
our @EXPORT = qw/num2text/;

my %chapter_ord_masc = (
    'I' => 'pierwszy',
    'II' => 'drugi',
    'III' => 'trzeci',
    'IV' => 'czwarty',
    'V' => 'piąty',
    'VI' => 'szósty',
    'VII' => 'siódmy',
    'VIII' => 'ósmy',
    'IX' => 'dziewiąty',
    'X' => 'dziesiąty',
    'XI' => 'jedenasty',
    'XII' => 'dwunasty',
    'XIII' => 'trzynasty',
    'XIV' => 'czternasty',
    'XV' => 'piętnasty',
    'XVI' => 'szesnasty',
    'XVII' => 'siedemnasty',
    'XVIII' => 'osiemnasty',
    'XIX' => 'dziewiętnasty',
    'XX' => 'dwudziesty',
    'XXX' => 'trzydziesty',
    'XL' => 'czterdziesty',
    'L' => 'pięćdziesiąty',
    'LX' => 'sześćdziesiąty',
    'LXX' => 'siedemdziesiąty',
    'LXXX' => 'osiemdziesiąty',
    'XC' => 'dziewięćdziesiąty',
);

my %plurals = (
    'milion' => ['milion', 'miliony', 'milionów'],
    'tysiąc' => ['tysiąc', 'tysiące', 'tysięcy'],
    'miliard' => ['miliard', 'miliardy', 'miliardów'],
    
    'frank' => ['frank', 'franki', 'franków'],
    'centym' => ['centym', 'centymy', 'centymów'],
);

my %thousands = (
    1 => 'tysiąc',
);

my %hundreds = (
    1 => 'sto',
    2 => 'dwieście',
    3 => 'trzysta',
    4 => 'czterysta',
    5 => 'pięćset',
    6 => 'sześćset',
    7 => 'siedemset',
    8 => 'osiemset',
    9 => 'dziewięćset'
);

my %teens_ord = (
    10 => 'dziesiąty',
    11 => 'jedenasty',
    12 => 'dwunasty',
    13 => 'trzynasty',
    14 => 'czternasty',
    15 => 'piętnasty',
    16 => 'szesnasty',
    17 => 'siedemnasty',
    19 => 'osiemnasty',
    19 => 'dziewiętnasty',
);

my %teens = (
    10 => 'dziesięć',
    11 => 'jedenaście',
    12 => 'dwanaście',
    13 => 'trzynaście',
    14 => 'czternaście',
    15 => 'piętnaście',
    16 => 'szesnaście',
    17 => 'siedemnaście',
    19 => 'osiemnaście',
    19 => 'dziewiętnaście',
);

my %tens = (
    1 => 'dziesięć',
    2 => 'dwadzieścia',
    3 => 'trzydzieści',
    4 => 'czterdzieści',
    5 => 'pięćdziesiąt',
    6 => 'sześćdziesiąt',
    7 => 'siedemdziesiąt',
    8 => 'osiemdziesiąt',
    9 => 'dziewięćdziesiąt',
);

my %ones = (
    1 => 'jeden',
    2 => 'dwa',
    3 => 'trzy',
    4 => 'cztery',
    5 => 'pięć',
    6 => 'sześć',
    7 => 'siedem',
    8 => 'osiem',
    9 => 'dziewięć'
);

sub num2text_hundreds {
    my $num = $_[0];
    my $out = '';
    if(length($num) > 3) {
        return undef;
    }
    if(length($num) == 3) {
        my $lkup = substr($num, 0, 1);
        if($lkup == 0) {
            $out = '';
        } else {
            $out = $hundreds{$lkup};
        }
        $num = substr($num, 1);
    }
    if(length($num) == 2) {
        my $lkup = substr($num, 0, 1);
        my $space = ($out eq '') ? '' : ' ';
        if($lkup == 0) {
            $out .= '';
        } elsif($lkup == 1) {
            return $out . $space . $teens{$num};
        } else {
            $out .= $space . $tens{$lkup};
        }
        $num = substr($num, 1);
        if($num == 0) {
            return $out;
        }
    }
    if(length($num) == 1) {
        my $space = ($out eq '') ? '' : ' ';
        return $out . $space . $ones{$num};
    }
}

my %numparts = (
    0 => '',
    1 => 'tysiąc',
    2 => 'milion',
    3 => 'miliard',
);

sub num2text {
    my $num = $_[0];
    my @parts = ();
    
    my $num_work = $num;
    while(length($num_work) != 0) {
        my $mod3 = length($num_work) % 3;
        my $cont_len = ($mod3 != 0) ? $mod3 : 3;

        my $start = substr($num_work, 0, $cont_len);
        my $txtpart = ($start eq '000') ? '' : num2text_hundreds($start);
        push @parts, $txtpart;
        if(length($num_work) == 3) {
            $num_work = '';
        } else {
            $num_work = substr($num_work, $cont_len);
        }
    }
    my $out = '';
    if($#parts == 0) {
        return $parts[0];
    }
    for(my $i = 0; $i <= $#parts; $i++) {
        my $j = $#parts - $i;
        
        my $part = $parts[$i];
        my $space = ($out eq '') ? '' : ' ';

        my $thisnumpart = $numparts{$j};
        
        if($i != $#parts && $part eq 'jeden') {
            $part = $thisnumpart;
        } elsif($part eq '') {
        # Do nothing, else it'll be milion tysięcy etc.
        } elsif($j != 0) {
            if($part =~ / (dwa|trzy|cztery)$/ || $part =~ /^(dwa|trzy|cztery)$/) {
                $part .= " " . $plurals{$thisnumpart}->[1];
            } else {
                $part .= " " . $plurals{$thisnumpart}->[2];
            }
        }
        if($part ne '') {
            $out .= $space . $part;
        }
    }
    return $out;
}

1;