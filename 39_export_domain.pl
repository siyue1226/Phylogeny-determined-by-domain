#!/usr/bin/perl 
use strict;
use warnings;
use autodie;
use Cwd;


my $list = shift;


open my $infh, '<', $list;
while ( my $species = <$infh> ) {
    chomp $species;
    print "$species\n";
    chdir "/home/wangq1/data/genefamily/ensemblplants/trans/hmmout/";
    system
    "perl /home/wangq1/data/genefamily/ensemblplants/export_domain.pl ./${species}_trans2aa_domtblout ./${species}_trans2aa_domtblout_parse";
    system
    "sort ./${species}_trans2aa_domtblout_parse | uniq >./${species}_trans2aa_domtblout_parse_sq";
    system
    "sed -e '/#/d'  ${species}_trans2aa_domtblout_parse_sq >./${species}_trans2aa_domtblout_parse_sq_1";
        #"perl E:/program/export_domain.pl E:/phytozome_35transcript/${species}_domtblout E:/phytozome_35transcript/${species}.domain";
    }
close $infh;

#perl 39_export_domain.pl 39_namelist
