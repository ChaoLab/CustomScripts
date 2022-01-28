#!/usr/bin/perl

use strict;
use warnings;

=pod
`zcat nr.gz | grep '^>' > nr_header.txt`;
`sed -i "s/\x01/\t/g" nr_header.txt`;
=cut

my %Nr_header = (); # $line => 1
open IN, "nr_header.txt";
while (<IN>){
	chomp;
	my $line = $_;
	my @tmp = split (/\t/,$line);
	my $tmp_element_num = scalar @tmp;
	if ($tmp_element_num >= 2){
		my $line_new = $tmp[0];
		
		for(my $i=1; $i<=$#tmp; $i++){
			my ($acc) = $tmp[$i] =~ /^(.+?)\s/;
			$line_new .= "\t".$acc;
		}
		
		$line = $line_new;
	}
	$Nr_header{$line} = 1;
}
close IN;

`rm nr_header.txt`;

open OUT, ">nr_header.txt";
foreach my $line (sort keys %Nr_header){
	print "$line\n";
}
close OUT;