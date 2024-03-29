package NumberNorm;

use warnings;
#use strict;
use utf8;

use Exporter;

our @ISA = qw/Exporter/;
our @EXPORT = qw/num2text inflect_ordinal expand_year get_num_regex inflect_ordinal_roman/;

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

sub romans_to_ordinal {
    my $in = shift;
    my $units = "IX|IV|III|II|I|VIII|VII|VI|V";
    my $tens = "XL|XC|XXX|XX|X|LXXX|LXX|LX";
    if($in =~ /^($tens)($units)$/) {
        my $tens = $1;
        my $units = $2;
        if($tens eq 'X') {
            return $roman_ord_masc{$tens . $units};
        } else {
            return $roman_ord_masc{$tens} . " " . $roman_ord_masc{$units};
        }
    } elsif($in =~ /^($tens)$/) {
        my $tens = $1;
        return $roman_ord_masc{$tens};
    } elsif($in =~ /^($units)$/) {
        my $units = $1;
        return $roman_ord_masc{$units};
    } else {
        return '';
    }
}

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
    'jeden' => '(?:jed(?:en|nego|nemu|nej|nych|nymi?|n[oaieą])|pierwsi|pierwsz(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'dwa' => '(?:dw(?:aj?|óch|óm|ie|oma|iema|u)|dwoj(?:e|ga|gu|giem)|drudzy|drug[aą]|drugi(?:ego|emu|ej|ch|mi?)?)',
    'trzy' => '(?:trz(?:y|ech|ej|ema?)|troj(?:e|ga|gu|giem)|trzeci(?:ego|emu|ej|ch|mi|[aemą])?)',
    'cztery' => '(?:czter(?:y|ech|ej|ema?)|czwor(?:o|ga|gu|giem)|czwarci|czwart(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'pięć' => '(?:pię(?:ć|ciu|cioma)|pięcior(?:o|ga|gu|giem)|piąci|piąt(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'sześć' => '(?:sześ(?:ć|ciu|cioma)|sześcior(?:o|ga|gu|giem)|szóści|szóst(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'siedem' => '(?:siedem|siedm(?:iu|ioma)|siedmior(?:o|ga|gu|giem)|siódmi|siódm(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'osiem' => '(?:osiem|ośm(?:iu|ioma)|ośmior(?:o|ga|gu|giem)|óśmi|ósm(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'dziewięć' => '(?:dziewięć|dziewięc(?:iu|ioma)|dziewięcior(?:o|ga|gu|giem)|dziewiąci|dziewiąt(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'dziesięć' => '(?:dziesięć|dziesięc(?:iu|ioma)|dziesięcior(?:o|ga|gu|giem)|dziesiąci|dziesiąt(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'jedenaście' => '(?:jedenaście|jedenast(?:u|oma)|jedenaścior(?:o|ga|gu|giem)|jedenaści|jedenast(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'dwanaście' => '(?:dwanaście|dwunast(?:u|oma)|dwanaścior(?:o|ga|gu|giem)|dwunaści|dwunast(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'trzynaście' => '(?:trzynaście|trzynast(?:u|oma)|trzynaścior(?:o|ga|gu|giem)|trzynaści|trzynast(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'czternaście' => '(?:czternaście|czternast(?:u|oma)|czternaścior(?:o|ga|gu|giem)|czternaści|czternast(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'piętnaście' => '(?:piętnaście|piętnast(?:u|oma)|piętnaścior(?:o|ga|gu|giem)|piętnaści|piętnast(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'szesnaście' => '(?:szesnaście|szesnast(?:u|oma)|szesnaścior(?:o|ga|gu|giem)|szesnaści|szesnast(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'siedemnaście' => '(?:siedemnaście|siedemnast(?:u|oma)|siedemnaścior(?:o|ga|gu|giem)|siedemnaści|siedemnast(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'osiemnaście' => '(?:osiemnaście|osiemnast(?:u|oma)|osiemnaścior(?:o|ga|gu|giem)|osiemnaści|osiemnast(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'dziewiętnaście' => '(?:dziewiętnaście|dziewiętnast(?:u|oma)|dziewiętnaścior(?:o|ga|gu|giem)|dziewiętnaści|dziewiętnast(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'dwadzieścia' => '(?:dwadzieścia|dwadziest(?:u|oma)|dwadzieścior(?:o|ga|gu|giem)|dwudzieści|dwudziest(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'trzydzieści' => '(?:trzydzieści|trzydziest(?:u|oma)|trzydzieścior(?:o|ga|gu|giem)|trzydzieści|trzydziest(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'czterdzieści' => '(?:czterdzieści|czterdziest(?:u|oma)|czterdzieścior(?:o|ga|gu|giem)|czterdzieści|czterdziest(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'pięćdziesiąt' => '(?:pięćdziesiąt|pięćdziesięci(?:u|oma)|pięćdziesięcior(?:o|ga|gu|giem)|pięćdziesiąci|pięćdziesiąt(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'sześćdziesiąt' => '(?:sześćdziesiąt|sześćdziesięci(?:u|oma)|sześćdziesięcior(?:o|ga|gu|giem)|sześćdziesiąci|sześćdziesiąt(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'siedemdziesiąt' => '(?:siedemdziesiąt|siedemdziesięci(?:u|oma)|siedemdziesięcior(?:o|ga|gu|giem)|siedemdziesiąci|siedemdziesiąt(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'osiemdziesiąt' => '(?:osiemdziesiąt|osiemdziesięci(?:u|oma)|osiemdziesięcior(?:o|ga|gu|giem)|osiemdziesiąci|osiemdziesiąt(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'dziewięćdziesiąt' => '(?:dziewięćdziesiąt|dziewięćdziesięci(?:u|oma)|dziewięćdziesięcior(?:o|ga|gu|giem)|dziewięćdziesiąci|dziewięćdziesiąt(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'sto' => '(?:sto|st(?:u|oma)|set|st(?:ami|a|y)|setni|setn(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'tysiąc' => '(?:tysięcy|tysiąc(?:owi|em|ami|om|ach|a|e|u)?|tysi[ęą]czn(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'milion' => '(?:milion(?:owi|em|ami|om|ach|ie|ów|a|y)?|milionow(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'miliard' => '(?:miliard(?:owi|em|ami|om|ach|zie|ów|a|y)?|miliardow(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'biliard' => '(?:biliard(?:owi|em|ami|om|ach|zie|ów|a|y)?|biliardow(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'zero' => '(?:zer(?:em|ami|om|ach|ze|[auo])?|zerow(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'dwieście' => '(?:dwieście|dwust(?:u|oma)|dw(?:u|óch)setn(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'trzysta' => '(?:trzysta|trzyst(?:u|oma)|trzechsetn(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'czterysta' => '(?:czterysta|czteryst(?:u|oma)|czterechsetn(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'pięćset' => '(?:pięćset|pięciuset|pięćsetn(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'sześćset' => '(?:sześćset|sześciuset|sześćsetn(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'siedemset' => '(?:siedemset|siedmiuset|siedemsetn(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'osiemset' => '(?:osiemset|ośmset|ośmiuset|osiemsetn(?:ego|emu|ymi?|ych|ej|[eaąy]))',
    'dziewięćset' => '(?:dziewięćset|dziewięciuset|dziewięćsetn(?:ego|emu|ymi?|ych|ej|[eaąy]))',
);

sub get_num_regex {
    my $num = shift;
    my $numtext = $num;
    if($num =~ /^[0-9]+$/) {
        $numtext = num2text($num);
    }
    if($numtext =~ / /) {
        my @parts = split/ /, $numtext;
        my @tmp = ();
        for (my $i = 0; $i <= $#parts; $i++) {
            if(!exists $numbers_regexes{$parts[$i]}) {
            }
            $tmp[$i] = $numbers_regexes{$parts[$i]};
        }
        return join(' ', @tmp);
    } else {
        if(!exists $numbers_regexes{$numtext}) {
        }
        return $numbers_regexes{$numtext};
    }
}

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
sub inflect_ordinal_roman {
    shift if($_[0] eq 'inflect_ordinal_roman');
    my $in = $_[0];
    my $gender = 'm';
    if($#_ > 0) {
        $gender = $_[1];
    }
    my $case = 'nom';
    if($#_ > 1) {
        $case = $_[2];
    }
    my $ord = romans_to_ordinal($in);
    return inflect_ordinal($ord, $gender, $case);
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
