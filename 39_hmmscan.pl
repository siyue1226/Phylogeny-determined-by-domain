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
    chdir "/gpfssan1/home/wangq1/data/ensemblplants/trans/trans2aa";
    my $file;
    $file = `find . -name '*_trans2aa.fa' | grep "$species"`; 
    #system "find . -name '*.fa.gz' | grep "$species" >"$file"";  #¥ÌŒÛ”√∑®
    print "$file\n";
    system
        "hmmscan -o ./${species}_pro_hmmout --domtblout ./${species}_pro_domtblout  --noali --cpu 8  -E 0.0001 /gpfssan1/home/wangq1/software/Pfam-A.hmm $file";
}
close $infh;

#[wangq1@ega pep]$ perl 39_hmmscan.pl 39_namelist 
