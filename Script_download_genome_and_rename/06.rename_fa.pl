#!/usr/bin/perl -w 

open IN, "../ncbi-genomes-2019-02-09_Info.parsed";
while (<IN>)
{
	chomp;
	my @tmp = split (/\t/, $_);
	my @temp = split (/\//, $tmp[6]);	
	system ("gzip -d $temp[-1]");
	$tmp1 = "$tmp[9].fa";
	my $fna = $temp[-1];
	$fna =~ s/.gz//g;
	system ("mv $fna $tmp1");
}
close IN;
