#!/usr/bin/perl -w 

open IN, "../ncbi-genomes-2019-02-09_Info.parsed";
while (<IN>)
{
	chomp;
	my @tmp = split (/\t/, $_);
	my @temp = split (/\//, $tmp[6]);
	my $gz = $temp[-1];
	$gz =~ s/fna.gz/gbff.gz/g;
	system ("gzip -d $gz");
	$tmp1 = "$tmp[9].gb";
	my $gb = $temp[-1];
	$gb =~ s/fna.gz/gbff/g;
	system ("mv $gb $tmp1");
}
close IN;
