#!/usr/bin/perl

use strict;
use warnings;

system ("mkdir rp_tblout");

my %MAG_info = (); # bin => Bacteria/Archaeas
open IN, "/slowdata/data1/Arc_Genome_20190209/faa_compatible/name_changed/faa.list";
while (<IN>){
	chomp;
	my ($bin) = $_ =~ /^(.+?)\.faa/;
	$MAG_info{$bin} = "Archaea";	
}
close IN;


my @RPs = qw /rpL14 rpL15 rpL16 rpL18 rpL22 rpL24 rpL2 rpL3 rpL4 rpL5 rpL6 rpS10 rpS17 rpS19 rpS3 rpS8/;

open OUT, ">parse_out_16RPs.cmd.tmp";
foreach my $bin (sort keys %MAG_info){
	if ($MAG_info{$bin} eq "Archaea"){
		foreach my $rp (@RPs){
			print OUT "hmmsearch --cut_nc --cpu 1 --tblout rp_tblout/${bin}_to_add_vs_${rp}.out /home/zhichao/rp16_HMM/${rp}_arch.HMM /slowdata/data1/Arc_Genome_20190209/faa_compatible/name_changed/${bin}.faa\n";
		}
	}else{
		foreach my $rp (@RPs){
			print OUT "hmmsearch --cut_nc --cpu 1 --tblout rp_tblout/${bin}_to_add_vs_${rp}.out /slowdata/databases/rp16_HMM/${rp}_bact.HMM ${bin}.protein\n";		
		}
	}	
}
close OUT;

`cat parse_out_16RPs.cmd.tmp | parallel -j 30`;
`rm parse_out_16RPs.cmd.tmp`;
