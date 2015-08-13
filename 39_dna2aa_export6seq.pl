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
    chdir "/home/llw/data/protein_domain/ensembl/trans/seq";
    my $file = `find . -name '*cdna.all.fa' | grep "$species"`;
    chomp $file;
    print "$file\n";
    system
        "perl /home/llw/data/protein_domain/ensembl/dna2aa_export6seq.pl -i $file -o ./${species}_trans2aa_a.fa -a";
}
close $infh;

#[wangq1@ega pep]$ perl 39_hmmscan.pl 39_namelist 
