#!/usr/bin/perl 
use strict;
use warnings;
use autodie;

use Getopt::Long;
use Pod::Usage;

use File::Basename;

# getopt section
my $fasta_name ;
my $outfile ;
my $format_head;
my $upper_case;
my $export_all_fragment;
my $length;

my $man  = 0;
my $help = 0;

#此程序用于做六框翻译并输出六框中每个最长的片段，或六框所有的片段


GetOptions(
    'help|?'         => \$help,
    'man'            => \$man,
    "i|fasta_name=s" => \$fasta_name,
    "o|outfile=s"    => \$outfile,
    "f|format_head"  => \$format_head,
    "u|upper_case"   => \$upper_case,
    "a|export_all_fragment"   => \$export_all_fragment,
    "l|length=s" => \$length,
    
) or pod2usage(2);

pod2usage(1) if $help;
pod2usage( -exitstatus => 0, -verbose => 2 ) if $man;

# read
my ( $seq_of, $names ) = read_fasta($fasta_name);

# process
my $aa_seq_of = {};
my $six_seq_of = {};
foreach my $name ( @{$names} ) {
    #print "$name"."\n\n";
    my @orfs;
    push @orfs, $seq_of->{$name};
    push @orfs, ( substr $seq_of->{$name}, 1 );
    push @orfs, ( substr $seq_of->{$name}, 2 );
    my $rc = reverse $seq_of->{$name};
    $rc =~ tr/ATCGatcg/TAGCtagc/;
    push @orfs, $rc;
    push @orfs, ( substr $rc, 1 );
    push @orfs, ( substr $rc, 2 );

    my @pros;
    my @long_pros;
    for my $i ( 0 .. $#orfs ) {
        my $orf = $orfs[$i];
        for ( my $j = 0; $j < ( length($orf) - 2 ); $j += 3 ) {
            my $codon = substr( $orf, $j, 3 );
            $pros[$i] .= codon2aa($codon)
                ; #@orf中的六种情况分别翻译然后放入@pros中，两个数据内的编号对应
        }
        #print "$pros[$i]" . "\n\n";

        #把每个$six_seq的aa选出一个最长的放入@aa_seq2
        my @aa_seq = sort { length($b) <=> length($a) } split /_+/, $pros[$i];
        if ($export_all_fragment) {
            foreach my $f (@aa_seq) {                                            #foreach (my $f=0; $f<=4; $f++) { 
                if (length $f >=$length) {
                    push @long_pros, $f;
                }
            }
        }else {
           push @long_pros, $aa_seq[0];                      #取每框中最长的，push到@long_pros
        }

    }

    @long_pros = sort { length($b) <=> length($a) } @long_pros;
    $aa_seq_of->{$name} = $long_pros[0];
    $six_seq_of->{$name} = \@long_pros;
    
}

# write
open my $fh_out, ">$outfile";
for my $name ( @{$names} ) {
    for my $l (@{$six_seq_of->{$name}}) {
        print $fh_out ">$name\n";
        print ">$name\n";
        print $fh_out "$l" . "\n";
        #print "$l" . "\n";
    }
}
close $fh_out;

exit;

sub read_fasta {
    my $fasta_name = shift;

    my ( $seq_of, $names ) = ( {}, [] );

    my $cur_name;
    open my $fh_in, '<', $fasta_name;
    while ( my $line = <$fh_in> ) {
        chomp $line;
        if ( $line =~ /^>/ ) {
            if ($format_head) {
                ($cur_name) = split ' ', ( substr $line, 1 );
            }
            else {
                $cur_name = substr $line, 1;
            }
            push @{$names}, $cur_name;
        }
        elsif ( $line =~ /^#/ ) {

            # do nothing
        }
        elsif ( $line =~ /^\w+/ ) {
            if ($upper_case) {
                $line = uc $line;
            }
            next unless $cur_name;
            $seq_of->{$cur_name} .= $line;
        }
    }
    close $fh_in;
    return ( $seq_of, $names );
}

sub codon2aa {
    my ($codon) = @_;
    $codon = uc $codon;
    my (%genetic_code) = (
        'TCA' => 'S',    # Serine
        'TCC' => 'S',    # Serine
        'TCG' => 'S',    # Serine
        'TCT' => 'S',    # Serine
        'TTC' => 'F',    # Phenylalanine
        'TTT' => 'F',    # Phenylalanine
        'TTA' => 'L',    # Leucine
        'TTG' => 'L',    # Leucine
        'TAC' => 'Y',    # Tyrosine
        'TAT' => 'Y',    # Tyrosine
        'TAA' => '_',    # Stop
        'TAG' => '_',    # Stop
        'TGC' => 'C',    # Cysteine
        'TGT' => 'C',    # Cysteine
        'TGA' => '_',    # Stop
        'TGG' => 'W',    # Tryptophan
        'CTA' => 'L',    # Leucine
        'CTC' => 'L',    # Leucine
        'CTG' => 'L',    # Leucine
        'CTT' => 'L',    # Leucine
        'CCA' => 'P',    # Proline
        'CCC' => 'P',    # Proline
        'CCG' => 'P',    # Proline
        'CCT' => 'P',    # Proline
        'CAC' => 'H',    # Histidine
        'CAT' => 'H',    # Histidine
        'CAA' => 'Q',    # Glutamine
        'CAG' => 'Q',    # Glutamine
        'CGA' => 'R',    # Arginine
        'CGC' => 'R',    # Arginine
        'CGG' => 'R',    # Arginine
        'CGT' => 'R',    # Arginine
        'ATA' => 'I',    # Isoleucine
        'ATC' => 'I',    # Isoleucine
        'ATT' => 'I',    # Isoleucine
        'ATG' => 'M',    # Methionine
        'ACA' => 'T',    # Threonine
        'ACC' => 'T',    # Threonine
        'ACG' => 'T',    # Threonine
        'ACT' => 'T',    # Threonine
        'AAC' => 'N',    # Asparagine
        'AAT' => 'N',    # Asparagine
        'AAA' => 'K',    # Lysine
        'AAG' => 'K',    # Lysine
        'AGC' => 'S',    # Serine
        'AGT' => 'S',    # Serine
        'AGA' => 'R',    # Arginine
        'AGG' => 'R',    # Arginine
        'GTA' => 'V',    # Valine
        'GTC' => 'V',    # Valine
        'GTG' => 'V',    # Valine
        'GTT' => 'V',    # Valine
        'GCA' => 'A',    # Alanine
        'GCC' => 'A',    # Alanine
        'GCG' => 'A',    # Alanine
        'GCT' => 'A',    # Alanine
        'GAC' => 'D',    # Aspartic Acid
        'GAT' => 'D',    # Aspartic Acid
        'GAA' => 'E',    # Glutamic Acid
        'GAG' => 'E',    # Glutamic Acid
        'GGA' => 'G',    # Glycine
        'GGC' => 'G',    # Glycine
        'GGG' => 'G',    # Glycine
        'GGT' => 'G',    # Glycine
    );

    if ( exists $genetic_code{$codon} ) {
        return $genetic_code{$codon};
    }
    elsif ( $codon =~ /N/ ) {
        $genetic_code{$codon} = '_';
    }
}


# perl ./ensembl/dna2aa_export6seq.pl -i ./test.fa -o ./out.fa -a