#!/usr/bin/perl

use strict;
use warnings;

my $kingdom = "Archaea";

open IN, "lost_faa_list";
while (<IN>){
        chomp;
        my @tmp = split (/\t/,$_);
        my $name = $tmp[0];
	my $locustag = $tmp[1];
        `prokka fa/$name.fa --outdir tmp --cpus 32 --centre X --compliant --prefix $name  --locustag $locustag --kingdom $kingdom`;
		open INN, "fa/$name.fa";
		open OUT, ">tmp/${name}_locus_to_seq.map.txt";
		my $i =1;
		while (<INN>){
			chomp;
			if (/>/){
				my ($tmp) = $_ =~ /^>(.+?)$/;
				print OUT $tmp."\t"."$locustag\_$i\n";
				$i++;
			}
		}
		close INN;
		`mv tmp/*map.txt faa_compatible; mv tmp/*.faa faa_compatible; rm -r tmp`;
}
close IN;
