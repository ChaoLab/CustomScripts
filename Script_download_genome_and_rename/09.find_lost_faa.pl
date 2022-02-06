#!/usr/bin/perl -w 

system ("ls fa/*.fa | xargs -i basename {} > fa_list");
system ("ls faa_compatible/*.faa | xargs -i basename {} > faa_list");
#`mkdir faa_compatible`;
open IN, "fa_list";
%hash = ();
while (<IN>)
{
	chomp;
	$_ =~ s/\.fa//gi;
	$hash{$_} = "1";
}
close IN;

open IN, "faa_list";
while (<IN>)
{
	chomp;
	$_ =~ s/\.faa//gi;
	if (exists $hash{$_})
	{
		delete $hash{$_};
#		`cp faa/$_.faa faa_compatible`;
	}
}

open OUT, ">lost_faa_list";
foreach my $key (sort keys %hash)
{
	my @tmp = split (/\_/, $key);
	print OUT "$key\t$tmp[-2]_$tmp[-1]\n";
	
}
close OUT;

`rm fa_list faa_list`

