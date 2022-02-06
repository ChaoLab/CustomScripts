#!/usr/bin/perl

use strict;
use warnings;

my %RP_out = (); # rp => bin => protein id
my %Bin_id = (); # bin =>  1
open IN, "/slowdata/data1/Arc_Genome_20190209/rp_tblout/rp_tblout.list";
while (<IN>){
	chomp;
	my $file = $_;
	my ($bin, $rp) = $file =~ /^(.+?)\_to\_add\_vs\_(.+?)\.out$/; $Bin_id{$bin} = 1;
	open INN, "rp_tblout/$file";
	while (<INN>){
		chomp;
		if (!/^#/){
			my @tmp = split (/\s/,$_);
			$RP_out{$rp}{$bin} = $tmp[0];
			last;
		}
	}
	close INN;
}
close IN;

my @RPs = qw /rpL14 rpL15 rpL16 rpL18 rpL22 rpL24 rpL2 rpL3 rpL4 rpL5 rpL6 rpS10 rpS17 rpS19 rpS3 rpS8/;
my $dir_gbk_all_files = "/slowdata/data1/Arc_Genome_20190209/faa_compatible/name_changed";

foreach my $rp (@RPs){
	open OUT, ">$rp.accno.list";
	foreach my $bin (sort keys %Bin_id){
		if ($RP_out{$rp}{$bin}){
			print OUT "$RP_out{$rp}{$bin}\n";
		}
	}
	close OUT;
}

open OUT, ">tmp_batch_extractSeqs.sh";
foreach my $rp (@RPs){
	print OUT "perl /slowdata/scripts/scripts/SeqTools/extractSeqs.pl -f $dir_gbk_all_files/All_protein_cat.protein -l $rp.accno.list -o Arc_Genome_20190209_${rp}.fa\n";
}
close OUT;
`cat tmp_batch_extractSeqs.sh | parallel -j 16`;
`rm *.accno.list`;
