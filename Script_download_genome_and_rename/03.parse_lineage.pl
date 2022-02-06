#!/usr/bin/perl -w 

open IN, "Taxid_NR2lineage.txt.parsed";
%hash = ();
while (<IN>)
{
	chomp;
	my @tmp = split(/\t/, $_);
	$hash{$tmp[0]} = $tmp[1];
}
close IN;

open IN, "Taxid.txt";
%hash2 = ();
while (<IN>)
{
	chomp;
	my @tmp = split(/\t/, $_);
	$hash2{$tmp[0]} = $hash{$tmp[1]};
}
close IN;

open OUT, ">lineage.txt";
foreach my $key (sort keys %hash2)
{
	print OUT "$key\t$hash2{$key}\n";
}
close OUT;

