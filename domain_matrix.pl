#!/usr/bin/perl
use strict;
use warnings;

my $total_file = shift || '/home/wangq1/data/genefamily/44species/pro/pfamA/total_dore_a_sq';   #total_domain_a_sq   #total_dore_a_sq
my $namelist = shift ||'/home/wangq1/data/genefamily/44species/43_namelist';

my (@total, @species);


open my $infh, '<', $total_file;
while ( my $line = <$infh> ) {
    chomp $line;
    push (@total, $line);
}
close $infh;

chdir "/home/wangq1/data/genefamily/ensemblplants/trans/domain_parse/";

open my $infh2, '<', $namelist;
while ( my $species = <$infh2> ) {
    chomp $species;
    my $domain_file = "$species"."_trans2aa_domtblout_parse_sq_1";                 #Stuberosum_pro_a_domtblout_parse_sq  #Smoellendorffii_dore_a_sq
    
        my %hashof;
        open my $in, '<', "./$domain_file";
        while ( my $d = <$in> ) {
        chomp $d;
        #print "$species\t";
        $hashof{$d} = $species;
        }    
            my $species_string;
            foreach my $t (@total) {
                if (exists $hashof{$t}) {
                    $species_string .=1; 
                }else {
                    $species_string .=0;
                }
            }
            print ">"."$species\n"."$species_string\n";
    
}
close $infh2;

#[wangq1@ega pfamA]$ perl domain_matrix.pl >pro_a_domain_matrix
