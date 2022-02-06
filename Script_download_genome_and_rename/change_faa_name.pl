#!/usr/bin/perl

use strict;
use warnings;

`mkdir name_changed`;
open IN,"faa.list";
while (<IN>){
        chomp;
        my $file = $_;
        my $head = ""; my %Seq = ();
        my ($file_name) = $file =~ /^(.+?)\.faa/;
        open INN, "$file";
        while (<INN>){
                chomp;
                if (/>/){
                        my ($id) = $_ =~ /^>(.+?)\s/;
                        $head = ">$file_name|$id";
                        $Seq{$head} = "";
                }else{
                        $Seq{$head} .= $_;
                }
        }
        close INN;
		
		open OUT, ">name_changed/$file";
		foreach my $key (sort keys %Seq){
			$Seq{$key} =~ s/\*//g;
			print OUT "$key\n$Seq{$key}\n";
		}
		close OUT;
}
close IN;
