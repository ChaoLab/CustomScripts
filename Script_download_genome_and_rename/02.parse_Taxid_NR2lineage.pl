#!/usr/bin/perl -w 

open IN, "Taxid_NR2lineage.txt";
%hash = ();
$i = 0;
while (<IN>)
{	
	if (/Taxonomy ID:/)
	{
		chomp;
		$i++;
		$hash{$i} = "$_\n";
		
	}else
	{
		chomp;
		$hash{$i} .= "$_\n";
	}
}
delete $hash{0};
close IN;


%hash2 = ();
foreach my $key (sort keys %hash)
{
	my $tax;
	my $lin;
	
	my $con = $hash{$key};
	if ($con =~ /Taxonomy\sID:\s(.+)\n/)
	{
		$tax = $1;
		chomp $tax;
		$hash2{$key}[0] = $tax;
	}
	if ($con =~ /Lineage:\s(.+)\n/)
	{
		$lin = $1;
		$lin =~ s/; /;/g;
		chomp $lin;
		$hash2{$key}[1] = $lin;
	}
}

open OUT, ">Taxid_NR2lineage.txt.parsed";
foreach my $key (sort keys %hash2)
{
	$hash2{$key}[0] =~ s/ +$//gi;
	print OUT "$hash2{$key}[0]\t$hash2{$key}[1]\n";
}