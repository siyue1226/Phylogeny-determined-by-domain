#!/usr/bin/perl
use strict;
use warnings;

use YAML qw(Dump Load DumpFile LoadFile);

#每个pro序列对应的domain

my $species = shift;
my $outdir = shift;
my $domtblout_infile = "${species}_trans2aa_domtblout";   #Acoerulea_pro_domtblout
my ($do, $pro);
my %dof_pro;

open my $infh, '<', $domtblout_infile ;
while ( my $line = <$infh> ) {
    chomp $line;
    if  ($line =~ /^#/) {
    #nothing
    } else {
        #print "\$line\t$line\n";
        my @line = split /\s+/, $line;
        $do = $line[0];
        $pro = $line[3];
        
        if ( exists $dof_pro{$pro} ) {
            push @{ $dof_pro{$pro} }, $do;
        }
        else {
            $dof_pro{$pro} = [$do];
        }
     
        
    }   
}
close $infh;
  
   
foreach my $p ( keys %dof_pro  ) {
    print "$p\t" . "#$p#\n";
    my %count;
    my @uniq = grep {++$count{ $_ } < 2;} @{$dof_pro{$p}};
    $dof_pro{$p} = [@uniq];   
}

DumpFile( "$outdir/${species}_trans2aa_dof_pro.yaml",    \%dof_pro );



#perl yml_pro_domain.pl $species /home/wangq1/data/genefamily/