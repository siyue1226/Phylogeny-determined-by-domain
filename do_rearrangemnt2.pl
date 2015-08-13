#!/usr/bin/perl
use strict;
use warnings;

use YAML qw(Dump Load DumpFile LoadFile);

use AlignDB::IntSpan;

#每个物种的pro序列鉴定出的uniq domain rearrangement


my $species = shift;
my $yaml_numof_d_file =shift || "/home/wangq1/data/genefamily/ensemblplants/pep/numof_d.yaml";
my $yaml_dof_pro_file ="/home/wangq1/data/genefamily/ensemblplants/trans/domain_com/${species}_trans2aa_dof_pro.yaml";  #Zmays_pro_a_dof_pro.yaml

my @do_re;

my $yaml_dof_pro
    = LoadFile(
    "$yaml_dof_pro_file"
 );
    
my $yaml_numof_d
    = LoadFile(
    "$yaml_numof_d_file"
 );
      
      
    foreach my $pro (keys %{$yaml_dof_pro}) {
        #print "\$pro\t"."$pro\n";
        my $pro_set = AlignDB::IntSpan->new;
        #print "\@dos\t@{$yaml_dof_pro->{$pro}}\n";
        foreach my $d (@{$yaml_dof_pro->{$pro}}) {
            #print "\t#$d#\n";
            $pro_set ->add("$yaml_numof_d->{$d}");
        }
        my $runlist = $pro_set->runlist;
        #print "\t\t$runlist\n";
        push (@do_re, $pro_set);
    }      

    my %count;
    my @uniq_do_re = grep {++$count{ $_ } < 2;} @do_re;
    
    my $num = scalar @uniq_do_re;
    #print "\$num\t$num\n";
    
    foreach my $u (@uniq_do_re) {
        my $do_runlist = $u->runlist();
        print "$do_runlist\n";
    }
    
    
#perl do_rearrangemnt2.pl $species ./numof_d.yaml >/home/wangq1/data/genefamily/do_re/${species}_dore