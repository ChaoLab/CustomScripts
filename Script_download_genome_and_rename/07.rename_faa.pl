#!/usr/bin/perl -w 

open IN, "../ncbi-genomes-2019-02-09_Info.parsed";
while (<IN>)
{
	chomp;
	my @tmp = split (/\t/, $_);
	my @temp = split (/\//, $tmp[7]);	
	system ("gzip -d $temp[-1]");
	$tmp1 = "$tmp[9].faa";
	my $faa = $temp[-1];
	$faa =~ s/.gz//g;
	system ("mv $faa $tmp1");
}
close IN;
