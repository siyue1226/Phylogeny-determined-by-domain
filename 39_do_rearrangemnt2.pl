#!/usr/bin/perl
use strict;
use warnings;

use YAML qw(Dump Load DumpFile LoadFile);

my $list = shift || '18species_namelist';

chdir "/home/wangq1/data/genefamily/ensemblplants/trans/domain_com";

open my $infh, '<', $list;
while ( my $species = <$infh> ) {
    chomp $species;
    print "$species\n";
    system "perl /home/wangq1/data/genefamily/ensemblplants/trans/do_rearrangemnt2.pl $species ./numof_d.yaml >./${species}_dore";
    system "sort ./${species}_dore | uniq >./${species}_dore_sq"
}
close $infh;


#[wangq1@aphid genefamily]$ perl 18_do_rearrangemnt2.pl ./18species_namelist 