#!/usr/bin/perl -w 

open IN, "Organism_name.txt";
%hash = ();
while (<IN>)
{	
	chomp;
	my @tmp = split (/\t/ , $_);
	if ($tmp[1] =~ /archaeon\s\(Candidatus\sHuberarchaea\)/)
	{
		$tmp[1] =~ s/archaeon\s\(Candidatus\sHuberarchaea\)/Candidatus Huberarchaea/g;
	}
	$tmp[1] =~ s/\(.+?\)//g;
	$hash{$tmp[0]}[0] = $tmp[1];
	$hash{$tmp[0]}[1] = "NA";
	$hash{$tmp[0]}[2] = "NA";
	my ($temp) = $tmp[0] =~ /^(.{15})/;
	$hash{$tmp[0]}[3] = $temp;
	my ($p1,$p2,$p3,$p4) = $temp =~ /^(.{3})_(.{3})(.{3})(.{3})/;
	$temp2 ='ftp://ftp.ncbi.nlm.nih.gov/genomes/all/'."$p1\/$p2\/$p3\/$p4\/$tmp[0]";
	$hash{$tmp[0]}[4] = $temp2;
	chomp $temp2;
	my @tmp2 = split (/\//, $temp2);	
	$temp3 = $temp2."\/".$tmp2[-1]."_genomic.fna.gz";
	$hash{$tmp[0]}[5] = $temp3;
	$temp4 = $temp2."\/".$tmp2[-1]."_protein.faa.gz";
	$hash{$tmp[0]}[6] = $temp4;

}
close IN;

open IN, "Infraspecific_name.txt";
while (<IN>)
{	
	chomp;
	my @tmp = split (/\t/ , $_);
	$hash{$tmp[0]}[1] = $tmp[1];
}
close IN;

open IN, "Isolate.txt";
while (<IN>)
{	
	chomp;
	my @tmp = split (/\t/ , $_);
	$hash{$tmp[0]}[2] = $tmp[1];
}
close IN;

open IN, "lineage.txt";
while (<IN>)
{	
	chomp;
	my @tmp = split (/\t/ , $_);
	$hash{$tmp[0]}[7] = $tmp[1];
}
close IN;

foreach my $key (sort keys %hash)
{
	if ($key eq "")
	{
		delete $hash{$key};
	}
}


foreach my $key (sort keys %hash)
{
	$V8 = $hash{$key}[8];
	$V0 = $hash{$key}[0];
	$V0 =~ s/ $//g;
	$V1 = $hash{$key}[1];
	$V2 = $hash{$key}[2];
	$V7 = $hash{$key}[7];	
	$V8 = "NA";
	
	my @tmp = split (/\;/ , $V7);
	if ($V0 !~ /$tmp[-1]/)
	{
		if (($V1 ne "NA") and ($V0 =~ $V1))
		{
			$V7 =~ s/;/_/g;
			$V7 =~ s/\s/_/g;
			$V0 =~ s/\s/_/g;
			$V8 = "$V7\_$V0";
		}elsif(($V1 ne "NA") and ($V0 !~ $V1))
		{
			$V7 =~ s/;/_/g;
			$V7 =~ s/\s/_/g;
			$V0 =~ s/\s/_/g;
			$V1 =~ s/\s/_/g;
			$V1 =~ s/\//_/g;
			$V1 =~ s/\;/_/g;
			$V1 =~ s/\(/_/g;
			$V1 =~ s/\)/_/g;
			$V8 = "$V7\_$V0\_$V1";
		}elsif (($V1 eq "NA") and ($V2 ne "NA") and ($V0 =~ $V2))
		{
			$V7 =~ s/;/_/g;
			$V7 =~ s/\s/_/g;
			$V0 =~ s/\s/_/g;
			$V8 = "$V7\_$V0";
		}elsif (($V1 eq "NA") and ($V2 ne "NA") and ($V0 !~ $V2))
		{
			$V7 =~ s/;/_/g;
			$V7 =~ s/\s/_/g;
			$V0 =~ s/\s/_/g;
			$V2 =~ s/\s/_/g;
			$V2 =~ s/\//_/g;
			$V2 =~ s/\;/_/g;
			$V2 =~ s/\(/_/g;
			$V2 =~ s/\)/_/g;
			$V8 = "$V7\_$V0\_$V2";
		}elsif (($V1 eq "NA") and ($V2 eq "NA"))
		{
			$V7 =~ s/;/_/g;
			$V7 =~ s/\s/_/g;
			$V0 =~ s/\s/_/g;
			$V8 = "$V7\_$V0";	
		}
	}else
	{
		$V7 =~ s/\;$tmp[-1]//g;
		if (($V1 ne "NA") and ($V0 =~ $V1))
		{
			$V7 =~ s/;/_/g;
			$V7 =~ s/\s/_/g;
			$V0 =~ s/\s/_/g;
			$V8 = "$V7\_$V0";
		}elsif(($V1 ne "NA") and ($V0 !~ $V1))
		{
			$V7 =~ s/;/_/g;
			$V7 =~ s/\s/_/g;
			$V0 =~ s/\s/_/g;
			$V1 =~ s/\s/_/g;
			$V1 =~ s/\;/_/g;
			$V1 =~ s/\//_/g;
			$V1 =~ s/\(/_/g;
			$V1 =~ s/\)/_/g;
			$V8 = "$V7\_$V0\_$V1";
		}elsif (($V1 eq "NA") and ($V2 ne "NA") and ($V0 =~ $V2))
		{
			$V7 =~ s/;/_/g;
			$V7 =~ s/\s/_/g;
			$V0 =~ s/\s/_/g;
			$V8 = "$V7\_$V0";
		}elsif (($V1 eq "NA") and ($V2 ne "NA") and ($V0 !~ $V2))
		{
			$V7 =~ s/;/_/g;
			$V7 =~ s/\s/_/g;
			$V0 =~ s/\s/_/g;
			$V2 =~ s/\s/_/g;
			$V2 =~ s/\;/_/g;
			$V2 =~ s/\//_/g;
			$V2 =~ s/\(/_/g;
			$V2 =~ s/\)/_/g;
			$V8 = "$V7\_$V0\_$V2";
		}elsif (($V1 eq "NA") and ($V2 eq "NA"))
		{
			$V7 =~ s/;/_/g;
			$V7 =~ s/\s/_/g;
			$V0 =~ s/\s/_/g;
			$V8 = "$V7\_$V0";	
		}
	
	
	}
	$V8 =~ s/\//_/g;
	$hash{$key}[8] = "$V8\_$hash{$key}[3]";

}


open OUT, ">ncbi-genomes-2019-02-09_Info.parsed";
open OUT2, ">ncbi-genomes-2019-02-09_fa.list";
open OUT3, ">ncbi-genomes-2019-02-09_faa.list";
open OUT4, ">ncbi-genomes-2019-02-09_gb.list";
foreach my $key (sort keys %hash)
{
	print OUT "$key\t$hash{$key}[0]\t$hash{$key}[1]\t$hash{$key}[2]\t$hash{$key}[3]\t$hash{$key}[4]\t$hash{$key}[5]\t$hash{$key}[6]\t$hash{$key}[7]\t$hash{$key}[8]\n";
	print OUT2 "$hash{$key}[5]\n";
	print OUT3 "$hash{$key}[6]\n";
	$tmp = $hash{$key}[5];
	$tmp =~ s/fna/gbff/gi;
	print OUT4 "$tmp\n";
}
close OUT;
close OUT2;
close OUT3;
close OUT4;
