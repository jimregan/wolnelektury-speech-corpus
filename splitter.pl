#!/usr/bin/perl
# Split longer texts to match audio

use warnings;
use strict;
use utf8;
use Data::Dumper;

my $DEBUG=0;

my %patterns = (
    'wyspa-skarbow.txt' => '^Część ',
    'sztuka-kochania.txt' => '^Księga ',
    'robinson-crusoe.txt' => 'Rozdział ',
    'wspomnienia-niebieskiego-mundurka.txt' => 'rozdział ',
    'powiesci-fantastyczne-wybor-narzeczonej.txt' => 'Rozdział ',
    'kim.txt' => 'Rozdział ',
    'przygody-tomka-sawyera.txt' => 'Rozdział ',
    'chlopi-czesc-pierwsza-jesien.txt' => 'Rozdział ',
    'spowiedz-dzieciecia-wieku.txt' => '^(Część|Rozdział (pią|[dtcs]))',
    'cierpienia-mlodego-wertera.txt' => '^Część ',
    'don-kichot-z-la-manchy.txt' => '^(Księga|Rozdział (pi[ąę]|[dtcsjóo]))',
);

my %firstpatterns = (
    'wyspa-skarbow.txt' => '^Część pierwsza',
    'sztuka-kochania.txt' => '^Księga pierwsza',
    'don-kichot-z-la-manchy.txt' => '^Księga pierwsza',
    'robinson-crusoe.txt' => 'Rozdział pierwszy',
    'wspomnienia-niebieskiego-mundurka.txt' => 'DUMMY_TO_SKIP',
    'powiesci-fantastyczne-wybor-narzeczonej.txt' => 'Rozdział pierwszy',
    'kim.txt' => 'DUMMY_TO_SKIP',
    'przygody-tomka-sawyera.txt' => 'Rozdział pierwszy',
    'piesn-o-rolandzie.txt' => '^I',
    'wierna-rzeka.txt' => '^I',
    'chlopi-czesc-pierwsza-jesien.txt' => 'Rozdział pierwszy',
    'spowiedz-dzieciecia-wieku.txt' => '^Część pierwsza',
    'cierpienia-mlodego-wertera.txt' => '^Część pierwsza',
);

my %skipfirst = (
    'sztuka-kochania.txt' => 1,
);

my %split_by_starts = (
    'balzac-komedia-ludzka-corka-ewy.txt' => [
        'Od tłumacza',
        'Córka Ewy',
        'Pani de Vandenesse, która widocznie',
        'Były to niebezpieczne krewniaczki',
        'Tak więc, podczas gdy biedna Ewa,',
        'Paryż jest jedynym miejscem na świecie,',
        'Fantazja Raula zespoliła niby',
        'Pani Feliksowa de Vandenesse była trzy razy w lasku',
        'W październiku zapadł termin weksli;',
        'Ze swej strony hrabina, szczęśliwa',
        'Na kilka chwil przed południem,'
    ],
    'balzac-komedia-ludzka-jaszczur.txt' => [
        'Panu Savary Członkowi Akademii Nauk',
        'Czyż nie był pijany życiem lub może',
        'Oto dziwne zjawisko, które',
        'Wypadając ze sklepu na ulicę,',
        'Deser zjawił się jakby czarami.',
        'II. Kobieta bez serca',
        'Udzieliłem sobie tego czasu',
        'Aż do ostatniej zimy pędziłem',
        'Wróciłem pieszo z dzielnicy',
        '— Ha! ha! — rzekł Rastignac',
        'Kaprys mody lub owa',
        'W dwa dni później',
        'Kiedym opuszczał ulicę',
        'Spekulant jakiś zaproponował mi',
        'III. \*Agonia\*',
        'Czy widzicie ten bogaty pojazd,',
        'Byłoby nużącym wiernie notować',
        'Planchette był to wysoki chudy człowiek,',
        'W kilka dni po tej rozpaczliwej scenie,',
        'W miesiąc później, po powrocie',
        'Przybywszy tegoż samego wieczora',
        'Po całonocnej podróży'
    ],
    'balzac-komedia-ludzka-kobieta-trzydziestoletnia.txt' => [
        'Kobieta trzydziestoletnia',
        'II. Nieznane cierpienia',
        'III. Kobieta trzydziestoletnia',
        'IV. Palec boży',
        'V. Dwa spotkania',
        'VI. Starość występnej matki'
    ],
    'balzac-komedia-ludzka-male-niedole-pozycia-malzenskiego.txt' => [
        'Honoré Balzac',
        'Część pierwsza',
        'I. Zdradziecki sztych',
        'II. Odkrycia',
        'III. Gorliwość młodej żony',
        'IV. Sprzeczki',
        'V. Niezrozumiana…',
        'VI. Logika kobiet',
        'VII. Jezuityzm kobiet',
        'VII. Wspominki i żale',
        'IX. Spostrzeżenie',
        'X. Bąk małżeński',
        'XI. Ciężkie roboty',
        'XII. Żółty śmiech',
        'XIII. Historia kliniczna willi za miastem',
        'XIV. Niedola w niedoli',
        'XV. Osiemnasty brumaire małżeństwa',
        'XVI. Sztuka stania się ofiarą',
        'XVII. Krytyczne dni',
        'XVIII. Marsz pogrzebowy',
        'Część druga',
        'XIX. Mężowie w drugim miesiącu',
        'XX. Zawiedzione ambicje',
        'XXI. Cierpienia naiwne',
        'XXII. Adonis wieczny tułacz',
        'XXIII. Bez zajęcia',
        'XXIV. Poufałości i niedyskrecje',
        'XXV. Brutalne przebudzenia',
        'XXVI. Partia odroczona',
        'XXVII. Stracone zachody miłości',
        'XXVIII. Dym bez ognia',
        'XXIX. Tyran domowy',
        'XXX. Wyznania',
        'XXXI. Upokorzenia',
        'XXXII. Ostatnia sprzeczka',
        'XXXIII. Akta sprawy Chaumontel',
        'XXXIV. „Klapa”',
        'XXXV. Kasztany z ognia',
        'XXXVI. Rozwiązanie',
        'XXXVII. Komentarz, który objaśnia słowo „felichitta” finałów'
    ],
    'bartek-zwyciezca.txt' => [
        'Henryk Sienkiewicz',
        'W jedną stronę wraca ku',
        'Ranek! Rozpierzchłe',
        'Bliższy udział w walnej',
        'W jakiś czas potem',
        'Znów upłynęło kilka',
        'Bartek wrócił jednak tak',
        'Sprawa stała się groźna.',
        'Magda naprawdę była tyle warta',
        'Wybory! Wybory! Pani Maria'
    ],
    'balzac-komedia-ludzka-muza-z-zascianka.txt' => [
        'Od tłumacza',
        'Muza z zaścianka',
        'Ksiądz Duret, proboszcz Sancerre,',
        'Ta pierwsza faza egzystencji',
        'Poezja i marzenia o sławie,',
        'Pani de La Baudraye popadła w manię',
        '— Niedługo po osiemnastym brumaire',
        'Tydzień temu, około jedenastej wieczór',
        'Pochwała ta upoiła panią',
        'kobiety, które chcą kochać,',
        'W tej chwili weszła pani de La Baudraye,',
        '— Proszę pana — rzekł posłaniec',
        'Lousteau chciał upiększyć swą',
        'Nawiązała przez matkę rokowania',
        'Po czterech latach współżycia',
        'Pewnego pięknego dnia w maju'
    ],
    'balzac-komedia-ludzka-eugenia-grandet.txt' => [
        'Warszawa, w marcu 1933',
        'Eugenia Grandet',
        'We framudze',
        'W chwili, gdy Grandet',
        'A teraz, jeśli chcecie',
        'Kiedy rodzina znalazła',
        'Stary Grandet, nie mając',
        'Przed tym dniem nigdy Eugenia',
        'W tej chwili miasto Saumur',
        'Kiedy stary Grandet zamknął',
        'Wszystkie trzy kobiety miały',
        'Aby nie przerywać biegu',
        '— Nie masz już',
        'Grandet zaczynał wówczas',
        'Eugenia Grandet znalazła się',
        'W początkach sierpnia'
    ],
    'boy-swietoszek.txt' => [
        'Wstęp',
        'II. Wystawienie Świętoszka',
        'III. Podłoże „Świętoszka”.',
        'IV. Stosunek Moliera',
        'V. Zdobycze komedii Moliera.',
        'VI. Doniosłość',
        'VII. Źródła „Świętoszka”.',
        'VIII. Artyzm Świętoszka.',
        'Przedmowa',
        'Pierwsze podanie',
        'Drugie podanie',
        'Trzecie podanie',
        'Świętoszek \(Tartufe\)',
        'SCENA DRUGA',
        'SCENA TRZECIA',
        'SCENA CZWARTA',
        'SCENA  PIĄTA',
        'SCENA SZÓSTA',
        'AKT II',
        'SCENA DRUGA',
        'SCENA TRZECIA',
        'SCENA CZWARTA',
        'AKT III',
        'SCENA DRUGA',
        'SCENA TRZECIA',
        'SCENA CZWARTA',
        'SCENA PIĄTA',
        'SCENA SZÓSTA',
        'SCENA SIÓDMA',
        'AKT IV',
        'SCENA DRUGA',
        'SCENA TRZECIA',
        'SCENA CZWARTA',
        'SCENA PIĄTA',
        'SCENA SZÓSTA',
        'SCENA SIÓDMA',
        'SCENA ÓSMA',
        'AKT V',
        'SCENA DRUGA',
        'SCENA TRZECIA',
        'SCENA CZWARTA',
        'SCENA PIĄTA',
        'SCENA SZÓSTA',
        'SCENA SIÓDMA',
        'SCENA ÓSMA',
    ],
    'przedwiosnie.txt' => [
        'Stefan Żeromski',
        'Część pierwsza',
        'Część druga',
        'Część trzecia',
        'Pewnego dnia rano Lulek',
    ],
    'golem.txt' => [
        'Sen',
        'Dzień',
        'J\\.',
        'Praga',
        'Poncz',
        'Noc',
        'Jawa',
        'Śnieg',
        'Strach',
        'Światło',
        'Nędza',
        'Trwoga',
        'Pęd',
        'Kobieta',
        'Podstęp',
        'Męka',
        'Maj',
        'Księżyc',
        'Wolny',
        'Kres'
    ],
);
my %split_by_whole = (
    'piesn-o-rolandzie.txt' => [
        "I",
        "II",
        "III",
        "IV",
        "V",
        "VI",
        "VII",
        "VIII",
        "IX",
        "X",
        "XI",
        "XII",
        "XIII",
        "XIV",
        "XV",
        "XVI",
        "XVII",
        "XVIII",
        "XIX",
        "XX",
        "XXI",
        "XXII",
        "XXIII",
        "XXIV",
        "XXV",
        "XXVI",
        "XXVII",
        "XXVIII",
        "XXIX",
        "XXX",
        "XXXI",
        "XXXII",
        "XXXIII",
        "XXXIV",
        "XXXV",
        "XXXVI",
        "XXXVII",
        "XXXVIII",
        "XXXIX",
        "XL",
        "XLI",
        "XLII",
        "XLIII",
        "XLIV",
        "XLV",
        "XLVI",
        "XLVII",
        "XLVIII",
        "XLIX",
        "L",
        "LI",
        "LII",
        "LIII",
        "LIV",
        "LV",
        "LVI",
        "LVII",
        "LVIII",
        "LIX",
        "LX",
        "LXI",
        "LXII",
        "LXIII",
        "LXIV",
        "LXV",
        "LXVI",
        "LXVII",
        "LXVIII",
        "LXIX",
        "LXX",
        "LXXI",
        "LXXII",
        "LXXIII",
        "LXXIV",
        "LXXV",
        "LXXVI",
        "LXXVII",
        "LXXVIII",
        "LXXIX",
        "LXXX",
        "LXXXI",
        "LXXXII",
        "LXXXIII",
        "LXXXIV",
        "LXXXV",
        "LXXXVI",
        "LXXXVII",
        "LXXXVIII",
        "LXXXIX",
        "XC",
        "XCI",
        "XCII",
        "XCIII",
        "XCIV",
        "XCV",
        "XCVI",
        "XCVII",
        "XCVIII",
        "XCIX",
        "C",
        "CI",
        "CII",
        "CIII",
        "CIV",
        "CV",
        "CVI",
        "CVII",
        "CVIII",
        "CIX",
        "CX",
        "CXI",
        "CXII",
        "CXIII",
        "CXIV",
        "CXV",
        "CXVI",
        "CXVII",
        "CXVIII",
        "CXIX",
        "CXX",
        "CXXI",
        "CXXII",
        "CXXIII",
        "CXXIV",
        "CXXV",
        "CXXVI",
        "CXXVII",
        "CXXVIII",
        "CXXIX",
        "CXXX",
        "CXXXI",
        "CXXXII",
        "CXXXIII",
        "CXXXIV",
        "CXXXV",
        "CXXXVI",
        "CXXXVII",
        "CXXXVIII",
        "CXXXIX",
        "CXL",
        "CXLI",
        "CXLII",
        "CXLIII",
        "CXLIV",
        "CXLV",
        "CXLVI",
        "CXLVII",
        "CXLVIII",
        "CXLIX",
        "CL",
        "CLI",
        "CLII",
        "CLIII",
        "CLIV",
        "CLV",
        "CLVI",
        "CLVII",
        "CLVIII",
        "CLIX",
        "CLX",
        "CLXI",
        "CLXII",
        "CLXIII",
        "CLXIV",
        "CLXV",
        "CLXVI",
        "CLXVII",
        "CLXVIII",
        "CLXIX",
        "CLXX",
        "CLXXI",
        "CLXXII",
        "CLXXIII",
        "CLXXIV",
        "CLXXV",
        "CLXXVI",
        "CLXXVII",
        "CLXXVIII",
        "CLXXIX",
        "CLXXX",
        "CLXXXI",
        "CLXXXII",
        "CLXXXIII",
        "CLXXXIV",
        "CLXXXV",
        "CLXXXVI",
        "CLXXXVII",
        "CLXXXVIII",
        "CLXXXIX",
        "CXC",
        "CXCI",
        "CXCII",
        "CXCIII",
        "CXCIV",
        "CXCV",
        "CXCVI",
        "CXCVII",
        "CXCVIII",
        "CXCIX",
        "CC",
        "CCI",
        "CCII",
        "CCIII",
        "CCIV",
        "CCV",
        "CCVI",
        "CCVII",
        "CCVIII",
        "CCIX",
        "CCX",
        "CCXI",
        "CCXII",
        "CCXIII",
        "CCXIV",
        "CCXV",
        "CCXVI",
        "CCXVII",
        "CCXVIII",
        "CCXIX",
        "CCXX",
        "CCXXI",
        "CCXXII",
        "CCXXIII",
        "CCXXIV",
        "CCXXV",
        "CCXXVI",
        "CCXXVII",
        "CCXXVIII",
        "CCXXIX",
        "CCXXX",
        "CCXXXI",
        "CCXXXII",
        "CCXXXIII",
        "CCXXXIV",
        "CCXXXV",
        "CCXXXVI",
        "CCXXXVII",
        "CCXXXVIII",
        "CCXXXIX",
        "CCXL",
        "CCXLI",
        "CCXLII",
        "CCXLIII",
        "CCXLIV",
        "CCLXV",
        "CCXLVI",
        "CCXLVII",
        "CCXLVIII",
        "CCXLIX",
        "CCL",
        "CCLI",
        "CCLII",
        "CCLIII",
        "CCLIV",
        "CCLV",
        "CCLVI",
        "CCLVII",
        "CCLVIII",
        "CCLIX",
        "CCLX",
        "CCLXI",
        "CCLXII",
        "CCLXIII",
        "CCLXIV",
        "CCLXV",
        "CCLXVI",
        "CCLXVII",
        "CCLXVIII",
        "CCLXIX",
        "CCLXX",
        "CCLXXI",
        "CCLXXII",
        "CCLXXIII",
        "CCLXXIV",
        "CCLXXV",
        "CCLXXVI",
        "CCLXXVII",
        "CCLXXVIII",
        "CCLXXIX",
        "CCLXXX",
        "CCLXXXI",
        "CCLXXXII",
        "CCLXXXIH",
        "CCLXXXIV",
        "CCLXXXV",
        "CCLXXXVI",
        "CCLXXXVII",
        "CCLXXXVIII",
        "CCLXXXIX",
        "CCXC",
        "CCXCI",
    ],
    'wierna-rzeka.txt' => [
        "I",
        "II",
        "III",
        "V",
        "VI",
        "VII",
        "VIII",
        "IX",
        "X",
        "XI",
        "XII",
        "XIII",
        "XIV",
        "XV",
        "XVI",
        "XVII"
    ]
);

my %split_inner = (
    'balzac-komedia-ludzka-corka-ewy.txt' => [
        'Paryż jest jedynym miejscem na świecie,',
        'Fantazja Raula zespoliła niby',
    ],
    'balzac-komedia-ludzka-eugenia-grandet.txt' => [
        'Przed tym dniem nigdy Eugenia',
        'Wszystkie trzy kobiety miały',
    ],
    'balzac-komedia-ludzka-jaszczur.txt' => [
        'Czyż nie był pijany życiem lub może',
        'Wypadając ze sklepu na ulicę,',
        'Udzieliłem sobie tego czasu',
        'Kiedym opuszczał ulicę',
        'Spekulant jakiś zaproponował mi',
    ],
    'balzac-komedia-ludzka-muza-z-zascianka.txt' => [
        'Poezja i marzenia o sławie,',
        'Pani de La Baudraye popadła w manię',
        'Tydzień temu, około jedenastej wieczór',
        'Pochwała ta upoiła panią',
        'kobiety, które chcą kochać,',
        'Nawiązała przez matkę rokowania',
    ],
);

my %inner_split = ();

my $filename = $ARGV[0];
open(INPUT, '<', $filename) or die "$!";
binmode(INPUT, ":utf8");

my $fn = '';
if($filename =~ /.*\/([^\/]*)$/) {
    $fn = $1;
} else {
    $fn = $filename;
}

if($DEBUG) {
    print STDERR "Filename: $fn\n";
}

my $pattern = '';
my @patterns = ();
my $firstpattern = '';
if(exists $firstpatterns{$fn}) {
    $firstpattern = $firstpatterns{$fn};
}

if($DEBUG) {
    print STDERR "First pattern: $firstpattern\n";
}

if(exists $patterns{$fn}) {
    $pattern = $patterns{$fn};
} elsif(exists $split_by_starts{$fn}) {
    @patterns = @{ $split_by_starts{$fn} };
    my $pat = shift @patterns;
    $pattern = '^'. $pat;
    $firstpattern = $pattern;
} elsif(exists $split_by_whole{$fn}) {
    @patterns = @{ $split_by_whole{$fn} };
    my $pat = shift @patterns;
    $pattern = '^'. $pat .'$';
    $firstpattern = $pattern;
} else {
    die "No pattern for filename $fn";
}

if($DEBUG) {
    print STDERR "Pattern: $pattern\n";
    print STDERR "First pattern: $firstpattern\n";
}

if(exists $split_inner{$fn}) {
    for my $si (@{ $split_inner{$fn} }) {
        $inner_split{$si} = 1;
    }
}
my $is_inner = 0;

my $count = 1;
my $printing = (exists $skipfirst{$fn}) ? 0 : 1;
if($filename eq 'wspomnienia-niebieskiego-mundurka.txt' || $filename eq 'kim.txt' || $filename eq 'przedwiosnie.txt') {
    $count = 0;
    $printing = 1;
}

my %skip_pattern = map { $_ => 1 } qw/wierna-rzeka.txt/;

my $count_spec = '%02d';
if($filename eq 'don-kichot-z-la-manchy.txt') {
    $count_spec = '%03d';
}

my $outfile = $filename . "-" . sprintf("$count_spec.txt", $count);
open(OUTPUT, '>', $outfile);
binmode(OUTPUT, ":utf8");
binmode(STDERR, ":utf8");

while(<INPUT>) {
    s/\r//;
    chomp;
    if(/$pattern/) {
        my $point = $-[0];
        $printing = 1;
        if($is_inner) {
            print OUTPUT substr $_, 0, $point - 1 . "\n";
            $count++;
            $outfile = $filename . "-" . sprintf("$count_spec.txt", $count);
            close OUTPUT;
            open(OUTPUT, '>', $outfile);
            binmode(OUTPUT, ":utf8");
            print OUTPUT substr $_, $point . "\n";
        } elsif($pattern ne $firstpattern && $_ !~ /$firstpattern/) {
            $count++;
            $outfile = $filename . "-" . sprintf("$count_spec.txt", $count);
            close OUTPUT;
            open(OUTPUT, '>', $outfile);
            binmode(OUTPUT, ":utf8");
            if(!exists $skip_pattern{$filename}) {
                print OUTPUT "$_\n";
            }
        } else {
            print OUTPUT "$_\n";
        }
        if((exists $split_by_starts{$fn} || exists $split_by_whole{$fn}) && @patterns) {
            my $pat = shift @patterns;
            if(exists $inner_split{$pat}) {
                $is_inner = 1;
                $pattern = $pat;
            } else {
                $is_inner = 0;
                $pattern = '^'. $pat;
            }
        }
    } else {
        if($printing) {
            print OUTPUT "$_\n";
        }
    }
}
