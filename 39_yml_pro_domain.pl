#!/usr/bin/perl
use strict;
use warnings;

use YAML qw(Dump Load DumpFile LoadFile);

my $list = shift || '18species_namelist';


chdir "/home/wangq1/data/genefamily/ensemblplants/trans/hmmout/";

open my $infh, '<', $list;
while ( my $species = <$infh> ) {
    chomp $species;
    print "$species\n";
    system "perl /home/wangq1/data/genefamily/ensemblplants/trans/yml_pro_domain.pl $species /home/wangq1/data/genefamily/ensemblplants/trans/domain_com";
}
close $infh;

#[wangq1@aphid genefamily]$ perl 18_yml_pro_domain.pl ./18species_namelist 