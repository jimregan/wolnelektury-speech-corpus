package NumberNorm;

use warnings;
#use strict;
use utf8;

use Exporter;

our @ISA = qw/Exporter/;
our @EXPORT = qw/num2text inflect_ordinal expand_year/;

my %roman_ord_masc = (
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
    18 => 'osiemnasty',
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
    18 => 'osiemnaście',
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

my %ones_ord = (
    1 => 'pierwszy',
    2 => 'drugi',
    3 => 'trzeci',
    4 => 'czwarty',
    5 => 'piąty',
    6 => 'szósty',
    7 => 'siódmy',
    8 => 'ósmy',
    9 => 'dziewiąty'
);

my %card_to_ord_years = (
    'jeden' => 'pierwszy',
    'dwa' => 'drugi',
    'trzy' => 'trzeci',
    'cztery' => 'czwarty',
    'pięć' => 'piąty',
    'sześć' => 'szósty',
    'siedem' => 'siódmy',
    'osiem' => 'ósmy',
    'dziewięć' => 'dziewiąty',
    'dziesięć' => 'dziesiąty',
    'jedenaście' => 'jedenasty',
    'dwanaście' => 'dwunasty',
    'trzynaście' => 'trzynasty',
    'czternaście' => 'czternasty',
    'piętnaście' => 'piętnasty',
    'szesnaście' => 'szesnasty',
    'siedemnaście' => 'siedemnasty',
    'osiemnaście' => 'osiemnasty',
    'dziewiętnaście' => 'dziewiętnasty',
    'dwadzieścia' => 'dwudziesty',
    'trzydzieści' => 'trzydziesty',
    'czterdzieści' => 'czterdziesty',
    'pięćdziesiąt' => 'pięćdziesiąty',
    'sześćdziesiąt' => 'sześćdziesiąty',
    'siedemdziesiąt' => 'siedemdziesiąty',
    'osiemdziesiąt' => 'osiemdziesiąty',
    'dziewięćdziesiąt' => 'dziewięćdziesiąty'
);

my %numbers_regexes = (
    'jeden' => 'jed(?:en|nego|nemu|nej|nych|nymi?|n[oaieą])|pierwsi|pierwsz(?:ego|emu|ymi?|ych|ej|[eaąy])',
    'dwa' => 'dw(?:aj?|óch|óm|ie|oma|iema|u)|dwoj(?:e|ga|gu|giem)|drudzy|drug[aą]|drugi(?:ego|emu|ej|ch|mi?)?',
    'trzy' => 'trz(?:y|ech|ej|ema?)|troj(?:e|ga|gu|giem)|trzeci(?:ego|emu|ej|ch|mi|[aemą])?',
    'cztery' => 'czter(?:y|ech|ej|ema?)|czwor(?:o|ga|gu|giem)|czwarci|czwart(?:ego|emu|ymi?|ych|ej|[eaąy])',
    'pięć' => 'pię(?:ć|ciu|cioma)|pięcior(?:o|ga|gu|giem)|piąci|piąt(?:ego|emu|ymi?|ych|ej|[eaąy])',
    'sześć' => 'sześ(?:ć|ciu|cioma)|sześcior(?:o|ga|gu|giem)|szóści|szóst(?:ego|emu|ymi?|ych|ej|[eaąy])',
    'siedem' => 'siedem|siedm(?:iu|ioma)|siedmior(?:o|ga|gu|giem)|siódmi|siódm(?:ego|emu|ymi?|ych|ej|[eaąy])',
    'dziewięć' => 'dziewięć|dziewięc(?:iu|ioma)|dziewięcior(?:o|ga|gu|giem)|dziewiąci|dziewiąt(?:ego|emu|ymi?|ych|ej|[eaąy])',
    'dziesięć' => 'dziesięć|dziesięc(?:iu|ioma)|dziesięcior(?:o|ga|gu|giem)|dziesiąci|dziesiąt(?:ego|emu|ymi?|ych|ej|[eaąy])',
    'jedenaście' => 'jedenaście|jedenast(?:u|oma)|jedenaścior(?:o|ga|gu|giem)|jedenaści|jedenast(?:ego|emu|ymi?|ych|ej|[eaąy])',
);

sub year_card_to_ord {
    my $num = $_[0];
    my $gen = 'm';
    my $case = ($#_ > 0) ? $_[1] : 'nom';
    if(exists $card_to_ord_years{$num}) {
        return inflect_ordinal($card_to_ord_years{$num}, $gen, $case);
    } else {
        return $num;
    }
}

sub expand_year {
    shift if($_[0] eq 'expand_year');
    my $year = $_[0];
    my $text = num2text($year);
    my $case = ($#_ > 0) ? $_[1] : 'nom';
    my @parts = split/ /, $text;
    my @ords = map {local $_ = $_; year_card_to_ord($_, $case)} @parts;
    return join(" ", @ords);
}

sub inflect_ordinal {
    shift if($_[0] eq 'inflect_ordinal');
    my $ordinal = $_[0];
    if($ordinal =~ /^[0-9]+$/) {
      $ordinal = expand_year($ordinal)
    }
    my $gender = 'm';
    if($#_ > 0) {
        $gender = $_[1];
    }
    my $case = 'nom';
    if($#_ > 1) {
        $case = $_[2];
    }
    if($gender eq 'm') {
        if($case eq 'nom') {
            return $ordinal;
        } elsif($case eq 'loc' || $case eq 'ins') {
            return $ordinal . "m";
        } elsif($case eq 'gen') {
            $ordinal =~ s/y$/ego/;
            $ordinal =~ s/i$/iego/;
            return $ordinal;
        }
    } elsif($gender eq 'f') {
        if($case eq 'nom') {
            $ordinal =~ s/y$/a/;
            $ordinal =~ s/gi$/ga/;
            $ordinal =~ s/i$/ia/;
            return $ordinal;
        } elsif($case eq 'acc' || $case eq 'ins') {
            $ordinal =~ s/y$/ą/;
            $ordinal =~ s/gi$/gą/;
            $ordinal =~ s/i$/ią/;
            return $ordinal;
        } elsif($case eq 'gen' || $case eq 'dat' || $case eq 'loc') {
            $ordinal =~ s/y$/ej/;
            $ordinal =~ s/i$/iej/;
            return $ordinal;
        }
    }
}

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
    shift if($_[0] eq 'num2text');
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
unless (caller) {
    binmode(STDOUT, ":utf8");
    print shift->(@ARGV) . "\n";
}
1;
