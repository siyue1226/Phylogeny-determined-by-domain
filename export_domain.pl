#!/usr/bin/perl



$infile = shift @ARGV;
$output = shift @ARGV;

open IF, "<$infile" or die "can not open this file:$!\n";

while (<IF>) {
	chomp;
	@line = split /\s+/, $_;
	$name = $line[0];
	$hash{$name}++;
}

close IF;

open OUT, ">$output" or die "can not create this file:$!\n";

for $a ( keys %hash ) {
	print OUT "$a\n";
}

close OUT;