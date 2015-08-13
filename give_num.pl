#!/usr/bin/perl
use strict;
use warnings;

use YAML qw(Dump Load DumpFile LoadFile);

#��ÿ��domain���

my $domain_list = shift;
my $outdir = shift;
my %numof_d;

open my $infh, '<', $domain_list;
my $c =0;
while ( my $d = <$infh> ) {
    chomp $d;
    $c++;
    $numof_d{$d} =$c;
}

DumpFile( "$outdir/numof_d.yaml",   \%numof_d );