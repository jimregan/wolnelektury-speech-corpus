#!/usr/bin/perl
#$ for i in audio/*zip ;do unzip -l $i;done | perl report-multiple-files.pl

my $fn = '';
my $numfiles = 0;

while(<>) {
        if(/Archive:\s+(.*)$/) {
                $fn = $1;
        }
        if(/\s*[0-9]+\s*([0-9]+) files?/) {
                $numfiles = $1;
                print "$fn $numfiles\n" if($numfiles > 1);
        }
}
